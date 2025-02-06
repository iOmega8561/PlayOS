//
//  AppModel.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

@MainActor class AppModel: ObservableObject {
    
    @Published var profilePicture: String = "ProfilePics/1"
    
    @Published var backgroundImage: String = "Backgrounds/1"
    
}
