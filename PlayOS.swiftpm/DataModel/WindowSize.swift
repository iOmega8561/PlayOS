//
//  WindowSize.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 08/02/25.
//

import Foundation

enum WindowSize: Equatable, Hashable {
    
    case small(fixed: Bool)
    case medium(fixed: Bool)
    case large(fixed: Bool)
    case custom(size: CGSize, fixed: Bool)
    
    var width: CGFloat {
        switch self {
        case .small: 400
        case .medium: 650
        case .large: 950
        case .custom(let size, _): size.width
        }
    }
    
    var height: CGFloat {
        switch self {
        case .small: 450
        case .medium: 500
        case .large: 700
        case .custom(let size, _): size.height
        }
    }
    
    var isFixed: Bool {
        switch self {
        case .small(let fixed),
             .medium(let fixed),
             .large(let fixed),
             .custom(_, let fixed): fixed
        }
    }
}
