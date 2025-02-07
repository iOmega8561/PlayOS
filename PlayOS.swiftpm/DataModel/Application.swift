//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

enum Application: CaseIterable {
    
    case test
    
    case settings
    
    @ViewBuilder @MainActor var content: some View {
        switch self {
        case .test: Color.black
        case .settings: SettingsAppView()
        }
    }
    
    var title: String {
        switch self {
        case .test: "Test"
        case .settings: "Settings"
        }
    }
}
