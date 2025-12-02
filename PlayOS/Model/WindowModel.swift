//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
//
//  WindowModel.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

/// A model representing a window in the desktop environment.
/// This structure encapsulates the state of a window including its associated application,
/// current size, position (offset), expansion status, and state object.
/// It also provides functions to resize, expand, and move the window.
struct WindowModel: Identifiable {
    
    /// A unique identifier for the window.
    let id: UUID = UUID()
    
    /// The application associated with this window.
    let application: Application
    
    /// The state object for the associated application.
    /// This allows the window to maintain or update the application's state.
    var stateObject: (any Application.Model)?
    
    /// A Boolean value indicating whether the window is minimized.
    var isMinimized: Bool = false
    
    /// A computed property that indicates if the window is resizable.
    /// A window is considered resizable if its preferred size is not fixed.
    var isResizable: Bool {
        !application.preferredSize.isFixed
    }
    
    /// A Boolean value indicating whether the window is currently expanded.
    /// This property is read-only externally.
    private(set) var isExpanded: Bool = false
    
    /// The current offset of the window relative to its initial centered position.
    /// This property is read-only externally.
    private(set) var offset: CGSize = .zero
    
    /// The current size of the window.
    /// It can be one of the predefined sizes or a custom size.
    private(set) var currentSize: WindowSize
    
    /// Resizes the window to a new size.
    /// - Parameter newSize: The new size for the window. If `nil`, the window is resized to the application's preferred size.
    mutating func resize(to newSize: WindowSize? = nil) {
        guard isResizable else {
            return
        }
        
        currentSize = newSize ?? application.preferredSize
    }
    
    /// Expands or contracts the window.
    /// When a container geometry is provided, the window expands to fill the container,
    /// resetting its offset and marking it as expanded.
    /// Otherwise, the window is resized to its preferred size and marked as not expanded.
    /// - Parameter container: An optional `GeometryProxy` representing the container's geometry.
    mutating func expand(in container: GeometryProxy? = nil) {
        if let container {
            resize(to: .custom(size: container.size, fixed: false))
            offset = .zero
            isExpanded = true
            
        } else { resize(); isExpanded = false }
    }
    
    /// Moves the window by computing a new offset based on a translation and the container's geometry.
    /// The movement is clamped to ensure that the window remains within allowed boundaries.
    /// - Parameters:
    ///   - translation: The translation vector indicating how far the window should move.
    ///   - container: A `GeometryProxy` representing the container's geometry.
    mutating func move(computing translation: CGSize, in container: GeometryProxy) {
        // Do not move the window if it is expanded.
        guard !isExpanded else { return }
        
        // Calculate the initial centered position of the window.
        let initialOrigin: CGPoint = .init(
            x: container.size.width / 2 - currentSize.width / 2,
            y: container.size.height / 2 - currentSize.height / 2
        )
        
        // Determine the current position based on the offset.
        let currentOrigin: CGPoint = .init(
            x: initialOrigin.x + offset.width,
            y: initialOrigin.y + offset.height
        )
        
        // Calculate the proposed new position by applying the translation.
        let proposedOrigin: CGPoint = .init(
            x: currentOrigin.x + translation.width,
            y: currentOrigin.y + translation.height
        )
        
        // Define the allowed boundaries for the window movement.
        let minX: CGFloat = -currentSize.width / 2
        let maxX = container.size.width - currentSize.width / 2
        let minY: CGFloat = 0
        let maxY = container.size.height - currentSize.height / 2
        
        // Clamp the proposed position within the allowed boundaries.
        let clampedOriginX = min(max(proposedOrigin.x, minX), maxX)
        let clampedOriginY = min(max(proposedOrigin.y, minY), maxY)
        
        // Update the offset based on the clamped new position.
        offset = .init(width: clampedOriginX - initialOrigin.x,
                       height: clampedOriginY - initialOrigin.y)
    }
    
    /// Initializes a new instance of `WindowModel` for a given application.
    /// If a container geometry is provided, the window is initialized with a custom size matching the container and marked as expanded.
    /// Otherwise, it is initialized with the application's preferred size.
    /// - Parameters:
    ///   - application: The application associated with the window.
    ///   - geometry: An optional `GeometryProxy` representing the container's geometry.
    ///   - stateObject: An optional initial state object for the application's model.
    init(
        for application: Application,
        expandIn geometry: GeometryProxy? = nil,
        withInitialState stateObject: (any Application.Model)? = nil
    ) {
        self.application = application
        
        if let geometry = geometry {
            self.currentSize = .custom(size: geometry.size, fixed: false)
            self.isExpanded = true
        } else {
            self.currentSize = application.preferredSize
        }
        
        self.stateObject = stateObject
    }
}

/// Extension to conform `WindowModel` to the `Hashable` protocol.
/// Equality and hashing are based solely on the unique `id` of the window.
extension WindowModel: Hashable {
    
    /// Determines if two `WindowModel` instances are equal by comparing their unique identifiers.
    /// - Parameters:
    ///   - lhs: The left-hand side `WindowModel` instance.
    ///   - rhs: The right-hand side `WindowModel` instance.
    /// - Returns: `true` if both instances have the same identifier, otherwise `false`.
    static func == (lhs: WindowModel, rhs: WindowModel) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Hashes the unique identifier of the `WindowModel` into the given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
