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
        let displayName: String
        let sfSymbol: String
        let preferredSize: WindowSize
        let contentType: any Content.Type
    }
    
    case terminal
    case calculator
    case explore
    case paint
    case taskManager
    case settings
    
    private var metaData: MetaData {
        switch self {
        case .terminal: .init(
            displayName: .init(localized: "app-terminal"),
            sfSymbol: "command",
            preferredSize: .medium(fixed: false),
            contentType: TerminalEmulatorAppView.self
        )
        case .calculator: .init(
            displayName: .init(localized: "app-calculator"),
            sfSymbol: "plus.forwardslash.minus",
            preferredSize: .small(fixed: true),
            contentType: CalculatorAppView.self
        )
        case .explore: .init(
            displayName: .init(localized: "app-explore"),
            sfSymbol: "safari",
            preferredSize: .large(fixed: false),
            contentType: ExploreAppView.self
        )
        case .paint: .init(
            displayName: .init(localized: "app-paint"),
            sfSymbol: "paintpalette",
            preferredSize: .medium(fixed: false),
            contentType: PaintAppView.self
        )
        case .taskManager: .init(
            displayName: .init(localized: "app-taskmanager"),
            sfSymbol: "macwindow.on.rectangle",
            preferredSize: .medium(fixed: true),
            contentType: TaskManagerAppView.self
        )
        case .settings: .init(
            displayName: .init(localized: "app-settings"),
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
