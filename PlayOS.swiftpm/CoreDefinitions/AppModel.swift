//
//  AppModel.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

@MainActor class AppModel: ObservableObject {
    
    @Published var profilePicture: SettingKey<Int> = .init(
        namespace: "ProfilePics",
        default: 1,
        possibleValues: [1, 2, 3, 4]
    )
    
    @Published var backgroundImage: SettingKey<Int> = .init(
        namespace: "Backgrounds",
        default: 1,
        possibleValues: [1, 2, 3, 4]
    )
    
    @Published var windows: [WindowModel] = []
}
