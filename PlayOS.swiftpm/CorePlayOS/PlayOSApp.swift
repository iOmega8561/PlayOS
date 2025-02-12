//
//  PlayOSApp.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

@main
struct PlayOSApp: App {
        
    private final class AppDelegate: NSObject, UIApplicationDelegate {
        
        func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return .landscape
        }
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    @StateObject private var playOSModel: PlayOSModel = .init()
    
    var body: some Scene {
        
        WindowGroup {
            
            ZStack {
                Color.black
                
                switch playOSModel.currentPhase {
                case .stopped: StoppedView()
                    
                case .poweringOn, .poweringOff:
                    PoweringView(
                        isPoweringOff: playOSModel.currentPhase == .poweringOff
                    )
                    
                case .login: GreeterView()
                case .desktop: DesktopView()
                }
            }
            .ignoresSafeArea()
            .statusBarHidden(true)
            .toolbar(.hidden)
            .environmentObject(playOSModel)
        }
    }
}
