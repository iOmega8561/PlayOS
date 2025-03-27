//
//  WindowSize.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 08/02/25.
//

import Foundation

/// Represents the size of a window with preset or custom dimensions.
///
/// This enum provides several options for window sizes:
/// - **small**: A preset small window size.
/// - **medium**: A preset medium window size.
/// - **large**: A preset large window size.
/// - **custom**: A custom window size where dimensions are provided via a `CGSize`.
///
/// Each case includes an associated Boolean (`fixed`) indicating whether the window size should be fixed.
enum WindowSize: Hashable {
    
    /// A small window size.
    /// - Parameter fixed: A Boolean indicating whether the window size is fixed.
    case small(fixed: Bool)
    
    /// A medium window size.
    /// - Parameter fixed: A Boolean indicating whether the window size is fixed.
    case medium(fixed: Bool)
    
    /// A large window size.
    /// - Parameter fixed: A Boolean indicating whether the window size is fixed.
    case large(fixed: Bool)
    
    /// A custom window size.
    /// - Parameters:
    ///   - size: A `CGSize` representing the custom dimensions (width and height).
    ///   - fixed: A Boolean indicating whether the window size is fixed.
    case custom(size: CGSize, fixed: Bool)
    
    /// The width of the window.
    ///
    /// For preset sizes, this property returns the default width:
    /// - `small`: 350
    /// - `medium`: 650
    /// - `large`: 750
    ///
    /// For the `custom` case, it returns the width from the provided `CGSize`.
    var width: CGFloat {
        switch self {
        case .small:      return 350
        case .medium:     return 650
        case .large:      return 750
        case .custom(let size, _): return size.width
        }
    }
    
    /// The height of the window.
    ///
    /// For preset sizes, this property returns the default height:
    /// - `small`: 450
    /// - `medium`: 500
    /// - `large`: 600
    ///
    /// For the `custom` case, it returns the height from the provided `CGSize`.
    var height: CGFloat {
        switch self {
        case .small:      return 450
        case .medium:     return 500
        case .large:      return 600
        case .custom(let size, _): return size.height
        }
    }
    
    /// Indicates whether the window size is fixed.
    ///
    /// This property reflects the `fixed` flag associated with each case.
    var isFixed: Bool {
        switch self {
        case .small(let fixed),
             .medium(let fixed),
             .large(let fixed),
             .custom(_, let fixed):
            return fixed
        }
    }
}
