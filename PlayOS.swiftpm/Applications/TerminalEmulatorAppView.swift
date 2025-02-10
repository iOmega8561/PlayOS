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
    
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}

extension TerminalEmulatorAppView: Application.Content {
    
    fileprivate final class Directory: Identifiable, ObservableObject {
        
        @Published var children: [Directory] = []
        
        let id = UUID()
        let name: String
        weak var parent: Directory?
        
        init(name: String, parent: Directory? = nil) {
            self.name = name
            self.parent = parent
        }
        
        func addChild(_ child: Directory) {
            child.parent = self
            children.append(child)
        }
        
        func findChild(named name: String) -> Directory? {
            return children.first(where: { $0.name == name })
        }
        
        func path() -> String {
            if let parent = parent {
                let parentPath = parent.path()
                // Avoid double slash for the root.
                return parentPath == "/" ? "/\(name)" : "\(parentPath)/\(name)"
                
            } else { return "/" } // This is the root directory.
        }
    }

    final class Model: Application.Model {
        
        @Published fileprivate var outputLines: [String] = []
        
        @Published fileprivate var currentDirectory: Directory
            
        private let rootDirectory: Directory
        
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

                if let parent = currentDirectory.parent {
                    currentDirectory = parent
                    
                } else { currentDirectory = rootDirectory }
            } else {

                if let next = currentDirectory.findChild(named: target) {
                    currentDirectory = next
                    
                } else { outputLines.append("cd: no such file or directory: \(target)") }
            }
        }
    }
}
