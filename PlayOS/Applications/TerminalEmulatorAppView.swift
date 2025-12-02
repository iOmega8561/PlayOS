//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
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
                
                TextField(text: $inputText, label: {})
                    .onSubmit {
                        appModel.processCommand(inputText)
                        inputText = ""
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.green)
                    .accentColor(.green)
                    .textFieldStyle(.plain)
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
        
    /// A struct that represents a shell command.
    ///
    /// Each command has a name, description, usage information, a minimum required number of
    /// parameters, and an execute closure that takes the current model and an array of command arguments.
    fileprivate struct ShellCommand: Sendable {
        
        /// The name of the command, usually the same as it would
        /// be on a UNIX-like operating system (ls, mkdir, cd ecc...)
        let name: String
        
        /// A brief description, along the line of what would come up
        /// at the start of the manpage if we were on a UNIX-like system
        let description: String
        
        /// A short usage instruction, that shows how to properly write the command
        let usage: String
        
        /// The minimum amount of arguments required by the command
        let minArgs: Int
        
        /// The closure to be executed by the command
        let execute: @Sendable (Model, [String]) -> Void
    }
    
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
    /// It now uses a dictionary of `ShellCommand` structs to define available commands programmatically.
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
            // Create the file system directories.
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
            
            // Display the welcome message.
            outputLines.append("Welcome to the PlayOS Terminal Emulator!")
            outputLines.append("Type 'help' to see available commands.")
        }
        
        /// Processes a command entered by the user.
        ///
        /// The method appends the command (including the prompt) to the output, checks if the provided
        /// arguments meet the command’s requirements, and then executes the corresponding `ShellCommand`.
        /// If the command is unknown or the arguments are insufficient, an appropriate message is displayed.
        ///
        /// - Parameter input: The raw command string entered by the user.
        fileprivate func processCommand(_ input: String) {
            // Append the prompt line.
            let prompt = "\(currentDirectory.path())$ \(input)"
            outputLines.append(prompt)
            
            // Break the input into the command name and arguments.
            let components = input.split(separator: " ").map { String($0) }
            guard let commandName = components.first else { return }
            let args = Array(components.dropFirst())
            
            // Look up the corresponding command.
            if let command = TerminalEmulatorAppView.commands[commandName] {
                // Check if the minimum required parameters are present.
                if args.count < command.minArgs {
                    outputLines.append("Usage: \(command.usage)")
                    return
                }
                command.execute(self, args)
            } else {
                outputLines.append("Unknown command: \(commandName)")
            }
        }
        
        /// Changes the current directory based on a target path or directory name.
        ///
        /// This method supports absolute paths (starting with `/`), relative directory names, and the special case
        /// of `".."` to navigate to the parent directory.
        ///
        /// - Parameter target: The target directory name or path.
        fileprivate func changeDirectory(to target: String) {
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

// MARK: - Available shell commands

extension TerminalEmulatorAppView {
    
    /// A dictionary containing the available shell commands for the terminal emulator.
    ///
    /// The keys of the dictionary are command names (e.g., "help", "ls", etc.), and the values are
    /// corresponding `ShellCommand` instances that encapsulate the command's metadata and behavior.
    /// This property is declared as `nonisolated` and `static` so that it can be accessed globally
    /// without being tied to a particular instance of `TerminalEmulatorAppView`.
    fileprivate nonisolated static let commands: [String: ShellCommand] = [
        
        /// The "help" command displays a list of available commands.
        "help": .init(
            name: "help",
            description: "Displays a list of available commands.",
            usage: "help",
            minArgs: 0,
            execute: { model, _ in
                // Retrieve and sort all available command names.
                let available = Self.commands.keys.sorted().joined(separator: ", ")
                // Append the list of available commands to the terminal output.
                model.outputLines.append("Available commands: \(available)")
            }
        ),
            
        /// The "ls" command lists the contents of the current directory.
        "ls": .init(
            name: "ls",
            description: "Lists the contents of the current directory.",
            usage: "ls",
            minArgs: 0,
            execute: { model, args in
                // Map the names of all children directories of the current directory.
                let names = model.currentDirectory.children.map { $0.name }
                // Append the joined names (or indicate an empty directory) to the terminal output.
                model.outputLines.append(names.isEmpty ? "(empty)" : names.joined(separator: "   "))
            }
        ),
            
        /// The "cd" command changes the current directory.
        ///
        /// This command requires at least one argument which is the target directory. The command's
        /// generic argument check ensures that the target argument is available.
        "cd": .init(
            name: "cd",
            description: "Changes the current directory.",
            usage: "cd <directory>",
            minArgs: 1,
            execute: { model, args in
                // Since minArgs is 1, we can safely access the first argument.
                let target = args[0]
                // Attempt to change the current directory to the specified target.
                model.changeDirectory(to: target)
            }
        ),
            
        /// The "pwd" command displays the full path of the current directory.
        "pwd": .init(
            name: "pwd",
            description: "Displays the current directory path.",
            usage: "pwd",
            minArgs: 0,
            execute: { model, _ in
                // Append the full path of the current directory to the terminal output.
                model.outputLines.append(model.currentDirectory.path())
            }
        ),
            
        /// The "clear" command clears all terminal output.
        "clear": .init(
            name: "clear",
            description: "Clears the terminal output.",
            usage: "clear",
            minArgs: 0,
            execute: { model, _ in
                model.outputLines.removeAll()
            }
         ),
            
        /// The "about" command displays terminal emulator information.
        "about": .init(
            name: "about",
            description: "Displays terminal information.",
            usage: "about",
            minArgs: 0,
            execute: { model, _ in
                model.outputLines.append("PlayOS Terminal Emulator v1.0")
                model.outputLines.append("Navigate a UNIX-like file system and try commands like ls, cd, pwd, help, and clear.")
            }
        ),
            
        /// The "playfetch" command displays a simulated system fetch output.
        ///
        /// It outputs a stylized ASCII logo along with system details such as the kernel version, uptime,
        /// window manager, package count, and shell name.
        "playfetch": .init(
            name: "playfetch",
            description: "Displays a simulated system fetch.",
            usage: "playfetch",
            minArgs: 0,
            execute: { model, _ in
                model.outputLines.append("""
                ______ _             _____ _____ 
                | ___ \\ |           |  _  /  ___|
                | |_/ / | __ _ _   _| | | \\ `--. 
                |  __/| |/ _` | | | | | | |`--. \\
                | |   | | (_| | |_| \\ \\_/ /\\__/ /
                \\_|   |_|\\__,_|\\__, |\\___/\\____/ 
                                __/ |            
                               |___/
                OS:            PlayOS 1.0 arm64
                Shell:         PlayOS Shell Interpreter
                Packages:      6 (apps), 4 (explore apps)
                DE:            PlayOS Desktop Environment
                WM:            PlayOS Window Manager
                Terminal:      PlayOS Terminal Emulator
                Terminal Font: San Francisco Monospaced
                """)
            }
        )
    ]
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
