//
//  TerminalEmulatorAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 10/02/25.
//

import SwiftUI

struct TerminalEmulatorAppView: View {
    
    @StateObject private var appModel: Model
    
    @State private var inputText: String = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Text("user@playos:\(appModel.currentDirectory.path())$")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.green)
                TextField("", text: $inputText, onCommit: {
                    appModel.processCommand(inputText)
                })
                .onSubmit { inputText = "" }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.green)
                .accentColor(.green)
                .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(8)
            .background(Color.black)
            
            Divider().background(Color.green)
            
            ScrollViewReader { scrollView in
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(Array(appModel.outputLines.enumerated()), id: \.offset) { index, line in
                            Text(line)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(index)
                        }
                    }
                    .padding()
                }
                .background(Color.black)
                .onChange(of: appModel.outputLines.count) { _ in
                    
                    if let last = appModel.outputLines.indices.last {
                        withAnimation {
                            scrollView.scrollTo(last, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Supporting nested types

extension TerminalEmulatorAppView {
    
    /// A model representing a directory in the terminal's file system.
    ///
    /// The `Directory` class models a directory with a name, its child directories, and an optional parent.
    /// It provides methods for adding children, searching for a child by name, and computing its full path.
    fileprivate final class Directory: Identifiable, ObservableObject {
        
        /// The list of child directories.
        @Published var children: [Directory] = []
        
        /// A unique identifier for the directory.
        let id = UUID()
        
        /// The name of the directory.
        let name: String
        
        /// A weak reference to the parent directory. `nil` if this is the root directory.
        weak var parent: Directory?
        
        /// Creates a new directory with a given name and an optional parent.
        ///
        /// - Parameters:
        ///   - name: The name of the directory.
        ///   - parent: An optional parent directory. Defaults to `nil`.
        init(name: String, parent: Directory? = nil) {
            self.name = name
            self.parent = parent
        }
        
        /// Adds a child directory to this directory.
        ///
        /// The child’s parent property is updated to reference this directory before being appended to the children list.
        ///
        /// - Parameter child: The directory to add as a child.
        func addChild(_ child: Directory) {
            child.parent = self
            children.append(child)
        }
        
        /// Finds the first child directory with the specified name.
        ///
        /// - Parameter name: The name of the child directory to find.
        /// - Returns: The child directory if found; otherwise, `nil`.
        func findChild(named name: String) -> Directory? {
            return children.first(where: { $0.name == name })
        }
        
        /// Computes the full path of the directory.
        ///
        /// This method recursively builds the directory path by traversing up to the root.
        /// It ensures that the root directory is represented by a single slash (`"/"`).
        ///
        /// - Returns: A string representing the full path of the directory.
        func path() -> String {
            if let parent = parent {
                let parentPath = parent.path()
                // Avoid double slash for the root.
                return parentPath == "/" ? "/\(name)" : "\(parentPath)/\(name)"
            } else {
                return "/" // This is the root directory.
            }
        }
    }
    
    /// The view model for the Terminal Emulator.
    ///
    /// The `Model` class manages the terminal session's state, including the command output and the current directory.
    /// It provides functionality for processing terminal commands and updating the file system state.
    final class Model: ObservableObject {
        
        /// The list of output lines displayed in the terminal.
        @Published fileprivate var outputLines: [String] = []
        
        /// The current directory in the terminal session.
        @Published fileprivate var currentDirectory: Directory
        
        /// The root directory of the file system.
        private let rootDirectory: Directory
        
        /// Initializes the terminal emulator model with a default file system structure and welcome message.
        ///
        /// The default structure includes root-level directories such as `home`, `usr`, `bin`, `etc`, and `var`,
        /// with a nested `user` directory inside `home`.
        init() {
            let root = Directory(name: "/")
            let home = Directory(name: "home")
            let usr = Directory(name: "usr")
            let bin = Directory(name: "bin")
            let etc = Directory(name: "etc")
            let varDir = Directory(name: "var")
            
            root.addChild(home)
            root.addChild(usr)
            root.addChild(bin)
            root.addChild(etc)
            root.addChild(varDir)
            
            let userDir = Directory(name: "user")
            home.addChild(userDir)
            
            self.rootDirectory = root
            self.currentDirectory = root
            
            outputLines.append("Welcome to the PlayOS Terminal Emulator!")
            outputLines.append("Type 'help' to see available commands.")
        }
        
        /// Processes a command entered by the user.
        ///
        /// The method appends the command to the output (including the prompt) and executes the command,
        /// updating the terminal output accordingly.
        ///
        /// Supported commands include:
        /// - `help`: Displays a list of available commands.
        /// - `ls`: Lists the contents of the current directory.
        /// - `cd`: Changes the current directory.
        /// - `pwd`: Displays the current directory path.
        /// - `clear`: Clears the terminal output.
        /// - `about`: Displays terminal information.
        /// - `playfetch`: Displays a simulated system fetch with system details.
        /// - Any other command results in an "Unknown command" message.
        ///
        /// - Parameter input: The raw command string entered by the user.
        fileprivate func processCommand(_ input: String) {
            
            let prompt = "\(currentDirectory.path())$ \(input)"
            outputLines.append(prompt)
            
            let components = input.split(separator: " ").map { String($0) }
            guard let command = components.first else { return }
            let args = Array(components.dropFirst())
                    
            switch command {
            case "help":
                outputLines.append("Available commands: help, ls, cd, pwd, clear, about, playfetch")
                
            case "ls":
                let names = currentDirectory.children.map { $0.name }
                outputLines.append(names.isEmpty ? "(empty)" : names.joined(separator: "   "))
                
            case "cd":
                guard let target = args.first else {
                    outputLines.append("cd: missing argument")
                    return
                }
                changeDirectory(to: target)
                
            case "pwd":
                outputLines.append(currentDirectory.path())
                
            case "clear":
                outputLines.removeAll()
                
            case "about":
                outputLines.append("PlayOS Terminal Emulator v1.0")
                outputLines.append("Navigate a UNIX-like file system and try commands like ls, cd, pwd, help, and clear.")
                
            case "playfetch":
                outputLines.append("""
                ______ _             _____ _____ 
                | ___ \\ |           |  _  /  ___|
                | |_/ / | __ _ _   _| | | \\ `--. 
                |  __/| |/ _` | | | | | | |`--. \\
                | |   | | (_| | |_| \\ \\_/ /\\__/ /
                \\_|   |_|\\__,_|\\__, |\\___/\\____/ 
                                __/ |            
                               |___/             
                """)
                outputLines.append("Kernel: 5.10.42-play")
                outputLines.append("Uptime: 3 days, 4 hours, 12 minutes")
                outputLines.append("Window Manager: PlayWM")
                outputLines.append("Packages: 13")
                outputLines.append("Shell: Plash")
                
            default:
                outputLines.append("Unknown command: \(command)")
            }
        }
        
        /// Changes the current directory based on a target path or directory name.
        ///
        /// This method supports absolute paths (starting with `/`), relative directory names, and the special case
        /// of `".."` to navigate to the parent directory.
        ///
        /// - Parameter target: The target directory name or path.
        private func changeDirectory(to target: String) {
            if target.hasPrefix("/") {
                // Handle absolute path.
                let pathComponents = target.split(separator: "/").map { String($0) }
                var dir = rootDirectory
                for comp in pathComponents where !comp.isEmpty {
                    if let next = dir.findChild(named: comp) {
                        dir = next
                    } else {
                        outputLines.append("cd: no such file or directory: \(target)")
                        return
                    }
                }
                currentDirectory = dir
            } else if target == ".." {
                // Navigate to the parent directory, or remain at root if no parent exists.
                if let parent = currentDirectory.parent {
                    currentDirectory = parent
                } else {
                    currentDirectory = rootDirectory
                }
            } else {
                // Handle relative directory name.
                if let next = currentDirectory.findChild(named: target) {
                    currentDirectory = next
                } else {
                    outputLines.append("cd: no such file or directory: \(target)")
                }
            }
        }
    }
}

// MARK: - Application Protocol Conformances

/// Conformance of `TerminalEmulatorAppView.Model` to the `Application.Model` protocol.
extension TerminalEmulatorAppView.Model: Application.Model { }

/// Conformance of `TerminalEmulatorAppView` to the `Application.Content` protocol.
extension TerminalEmulatorAppView: Application.Content {
    
    /// Initializes the Terminal Emulator view with the provided model.
    ///
    /// - Parameter appModel: An instance of the Terminal Emulator's model containing the app's logic.
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}
