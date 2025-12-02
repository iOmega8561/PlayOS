//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
//
//  PlayOSPhase.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import Foundation

/// Represents the various phases of the PlayOS operating system simulation lifecycle.
/// Each phase indicates the current state of the OS.
enum PlayOSPhase: Hashable {
    
    /// The simulation is stopped.
    case stopped
    
    /// The simulation is in the process of "powering on".
    case poweringOn
    
    /// The simulation is in the process of "powering off".
    case poweringOff
    
    /// The simulation is in the "login" phase.
    case login
    
    /// The simulation is at the desktop phase.
    case desktop
}
