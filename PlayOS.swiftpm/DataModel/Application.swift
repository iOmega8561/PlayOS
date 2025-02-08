//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

enum Application: CaseIterable {
    
    case calculator
    case browser
    case paint
    case settings
    
    @ViewBuilder @MainActor var content: some View {
        switch self {
        case .calculator: CalculatorAppView()
        case .browser: BrowserAppView()
        case .paint: PaintAppView()
        case .settings: SettingsAppView()
        }
    }
    
    var title: String {
        switch self {
        case .calculator: "Calculator"
        case .browser: "Web Browser"
        case .paint: "Paint"
        case .settings: "Settings"
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .calculator: "number"
        case .browser: "safari"
        case .paint: "theatermask.and.paintbrush"
        case .settings: "gearshape"
        }
    }
     
    var preferredSize: WindowSize {
        switch self {
        case .browser: .large(fixed: false)
        case .calculator: .small(fixed: true)
        case .settings: .medium(fixed: true)
        default: .medium(fixed: false)
        }
    }
}
