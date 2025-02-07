//
//  Mode.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

enum Mode: Equatable {
    
    struct Key: EnvironmentKey {
        nonisolated(unsafe) static let defaultValue: (Mode) -> Void = { _ in }
    }
    
    case stopped
    case poweringOn
    case poweringOff
    case login
    case desktop
}

extension EnvironmentValues {
    
    var setMode: Mode.Key.Value {
        get { self[Mode.Key.self] }
        set { self[Mode.Key.self] = newValue }
    }
}
