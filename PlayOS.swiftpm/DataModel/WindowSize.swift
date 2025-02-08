//
//  WindowSize.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 08/02/25.
//

import Foundation

enum WindowSize {
    
    case small
    case medium
    case large
    case custom(size: CGSize)
    
    var width: CGFloat {
        switch self {
        case .small: 400
        case .medium: 650
        case .large: 950
        case .custom(let size): size.width
        }
    }
    
    var height: CGFloat {
        switch self {
        case .small: 450
        case .medium: 500
        case .large: 700
        case .custom(let size): size.height
        }
    }
}
