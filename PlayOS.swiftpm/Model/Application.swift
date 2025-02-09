//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

@dynamicMemberLookup
enum Application: CaseIterable, Hashable {
    
    struct MetaData {
        let title: String
        let sfSymbol: String
        let preferredSize: WindowSize
        let contentType: any Content.Type
    }
    
    case calculator
    case browser
    case paint
    case settings
    
    private var metaData: MetaData {
        switch self {
        case .calculator: .init(
            title: "Calculator",
            sfSymbol: "number",
            preferredSize: .small(fixed: true),
            contentType: CalculatorAppView.self
        )
        
        case .browser: .init(
            title: "Web Browser",
            sfSymbol: "safari",
            preferredSize: .large(fixed: false),
            contentType: BrowserAppView.self
        )
        
        case .paint: .init(
            title: "Paint",
            sfSymbol: "theatermask.and.paintbrush",
            preferredSize: .medium(fixed: false),
            contentType: PaintAppView.self
        )
        
        case .settings: .init(
            title: "Settings",
            sfSymbol: "gearshape",
            preferredSize: .medium(fixed: true),
            contentType: SettingsAppView.self
        )
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<MetaData, T>) -> T {
        self.metaData[keyPath: keyPath]
    }
}
