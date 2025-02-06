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
                case .stopped: StoppedView()
                    
                case .poweringOn, .poweringOff:
                    PoweringView(isPoweringOff: currentMode == .poweringOff)
                    
                case .login: LoginView()
                    
                case .desktop: DesktopView()
                }
            }
            .ignoresSafeArea()
            .foregroundStyle(.white)
            .environment(\.setMode, setMode)
            .environmentObject(appModel)
            
        }
    }
    
    private func setMode(_ mode: Mode) {
        withAnimation(.default) { currentMode = mode }
    }
}
