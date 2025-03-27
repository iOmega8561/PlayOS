//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI


/// An enumeration representing the different applications available in the system.
///
/// Each application is associated with metadata, including a display name, an SF Symbol,
/// a preferred window size, and a content view type. The enum is marked with `@dynamicMemberLookup`
/// so that properties of the underlying metadata can be accessed directly using dot syntax.
@dynamicMemberLookup
enum Application: CaseIterable, Hashable {
    
    // MARK: - MetaData
        
    /// A structure encapsulating metadata for an application.
    ///
    /// This metadata includes:
    /// - A localized display name.
    /// - An SF Symbol name for the application's icon.
    /// - A preferred window size.
    /// - A content type conforming to the `Content` protocol for building the application's view.
    struct MetaData {
        /// The localized display name of the application.
        let displayName: String
        /// The SF Symbol associated with the application.
        let sfSymbol: String
        /// The preferred window size for the application.
        let preferredSize: WindowSize
        /// The content view type for the application.
        let contentType: any Content.Type
    }
    
    // MARK: - Application Cases
        
    /// Terminal application.
    case terminal
    /// Calculator application.
    case calculator
    /// Explore (web browsing) application.
    case explore
    /// Paint (drawing) application.
    case paint
    /// Task Manager application.
    case taskManager
    /// Settings application.
    case settings
    
    // MARK: - MetaData Access
    
    /// Retrieves the metadata associated with each application case.
    ///
    /// The metadata is defined for each case using localized display names, SF Symbols,
    /// preferred window sizes, and content view types.
    private var metaData: MetaData {
        switch self {
        case .terminal: .init(
            displayName: .init(localized: "terminal-title"),
            sfSymbol: "command",
            preferredSize: .medium(fixed: false),
            contentType: TerminalEmulatorAppView.self
        )
        case .calculator: .init(
            displayName: .init(localized: "calculator-title"),
            sfSymbol: "plus.forwardslash.minus",
            preferredSize: .small(fixed: true),
            contentType: CalculatorAppView.self
        )
        case .explore: .init(
            displayName: .init(localized: "explore-title"),
            sfSymbol: "safari",
            preferredSize: .large(fixed: false),
            contentType: ExploreAppView.self
        )
        case .paint: .init(
            displayName: .init(localized: "paint-title"),
            sfSymbol: "paintpalette",
            preferredSize: .medium(fixed: false),
            contentType: PaintAppView.self
        )
        case .taskManager: .init(
            displayName: .init(localized: "taskmanager-title"),
            sfSymbol: "macwindow.on.rectangle",
            preferredSize: .medium(fixed: true),
            contentType: TaskManagerAppView.self
        )
        case .settings: .init(
            displayName: .init(localized: "settings-title"),
            sfSymbol: "gearshape",
            preferredSize: .medium(fixed: true),
            contentType: SettingsAppView.self
        )
        }
    }
    
    /// Provides dynamic member lookup access to the underlying metadata.
    ///
    /// This subscript allows you to access properties of the `MetaData` directly from an
    /// `Application` instance using dot syntax.
    ///
    /// - Parameter keyPath: A key path to a specific property of `MetaData`.
    /// - Returns: The value of the requested property.
    subscript<T>(dynamicMember keyPath: KeyPath<MetaData, T>) -> T {
        self.metaData[keyPath: keyPath]
    }
}
