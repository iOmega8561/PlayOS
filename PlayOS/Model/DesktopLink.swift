//
//  DesktopLink.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 13/02/25.
//
    
import Foundation

/// An enumeration representing desktop links that serve as shortcuts to various learning resources within the system.
/// Each desktop link encapsulates metadata such as the associated application, localized display name,
/// SF Symbol icon, and the initial state for the application model.
@dynamicMemberLookup
enum DesktopLink: CaseIterable, Hashable {
    
    /// A structure that encapsulates metadata for a desktop link.
    /// It contains the associated application, display name, SF Symbol, and the initial state of the application model.
    struct MetaData {
        /// The application associated with this desktop link.
        let application: Application
        /// The localized display name for the desktop link.
        let displayName: String
        /// The SF Symbol representing the icon for the desktop link.
        let sfSymbol: String
        /// The initial state of the application model for this desktop link.
        let initialState: any Application.Model
    }
    
    /// Desktop link for accessing coding learning resources.
    case learnCoding
    /// Desktop link for accessing computer learning resources.
    case learnComputers
    
    /// A computed property that returns the metadata for each desktop link.
    /// This metadata includes the associated application, display name, SF Symbol, and the initial model state.
    private var metaData: MetaData {
        switch self {
        case .learnCoding: .init(
            application: .explore,
            displayName: .init(localized: "desktoplink-learncoding"),
            sfSymbol: "chevron.left.slash.chevron.right",
            initialState: ExploreAppView.Model(
                currentApp: .codingChallenge
            )
        )
        case .learnComputers: .init(
            application: .explore,
            displayName: .init(localized: "desktoplink-learncomputers"),
            sfSymbol: "laptopcomputer.and.ipad",
            initialState: ExploreAppView.Model(
                currentApp: .computerQuiz
            )
        )
        }
    }
    
    /// Provides dynamic member lookup access to the underlying metadata.
    /// This subscript allows direct access to the properties of `MetaData` using dot syntax.
    /// - Parameter keyPath: A key path to a specific property of the `MetaData` structure.
    /// - Returns: The value of the requested metadata property.
    subscript<T>(dynamicMember keyPath: KeyPath<MetaData, T>) -> T {
        self.metaData[keyPath: keyPath]
    }
}
