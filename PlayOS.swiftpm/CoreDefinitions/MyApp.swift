//
//  MyApp.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

@main
struct MyApp: App {
        
    @StateObject private var appModel: AppModel = .init()
    
    var body: some Scene {
        
        WindowGroup {
            ZStack {
                Color.black
                
                switch appModel.currentMode {
                case .stopped: StoppedView()
                    
                case .poweringOn, .poweringOff:
                    PoweringView(
                        isPoweringOff: appModel.currentMode == .poweringOff
                    )
                    
                case .login: LoginView()
                case .desktop: DesktopView()
                }
            }
            .ignoresSafeArea()
            .statusBarHidden(true)
            .toolbar(.hidden)
            .environmentObject(appModel)
        }
    }
}
