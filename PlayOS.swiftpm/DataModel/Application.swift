//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

enum Application: CaseIterable {
    
    case test
    case browser
    case settings
    
    @ViewBuilder @MainActor var content: some View {
        switch self {
        case .test: Color.black
        case .browser: BrowserAppView()
        case .settings: SettingsAppView()
        }
    }
    
    var title: String {
        switch self {
        case .test: "Test"
        case .browser: "Web Browser"
        case .settings: "Settings"
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .test: "wrench.and.screwdriver"
        case .browser: "safari"
        case .settings: "gearshape"
        }
    }
}
