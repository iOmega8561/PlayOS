//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

@dynamicMemberLookup enum Application: CaseIterable {
    
    struct MetaData {
        let title: String
        let sfSymbol: String
        let preferredSize: WindowSize
        
        fileprivate init(title: String, sfSymbol: String, preferredSize: WindowSize) {
            self.title = title
            self.sfSymbol = sfSymbol
            self.preferredSize = preferredSize
        }
    }
    
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
    
    private var metaData: MetaData {
        switch self {
            case .calculator: .init(
                title: "Calculator",
                sfSymbol: "number",
                preferredSize: .small(fixed: true)
            )
            
            case .browser: .init(
                title: "Web Browser",
                sfSymbol: "safari",
                preferredSize: .large(fixed: false)
            )
            
            case .paint: .init(
                title: "Paint",
                sfSymbol: "theatermask.and.paintbrush",
                preferredSize: .medium(fixed: false)
            )
            
            case .settings: .init(
                title: "Settings",
                sfSymbol: "gearshape",
                preferredSize: .medium(fixed: true)
            )
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<MetaData, T>) -> T {
        self.metaData[keyPath: keyPath]
    }
}
