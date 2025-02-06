//
//  MyApp.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

@main
struct MyApp: App {
    
    @State private var currentMode: Mode = .stopped
    
    @StateObject private var appModel: AppModel = .init()
    
    var body: some Scene {
        
        WindowGroup {
            
            ZStack {
                
                Color.black
                
                switch currentMode {
                    
                case .stopped:
                    
                    StoppedView()
                        .environment(\.setMode, setMode)
                    
                case .poweringOn, .poweringOff:
                    
                    PoweringView(isPoweringOff: currentMode == .poweringOff)
                        .environment(\.setMode, setMode)
                    
                case .login:
                    
                    LoginView()
                        .environmentObject(appModel)
                        .environment(\.setMode, setMode)
                    
                default: EmptyView()
                }
                
            }
            .ignoresSafeArea()
            .foregroundStyle(.white)
        }
    }
    
    private func setMode(_ mode: Mode) {
        withAnimation(.default) { currentMode = mode }
    }
}
