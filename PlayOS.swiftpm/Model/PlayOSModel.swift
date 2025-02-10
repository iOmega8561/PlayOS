//
//  PlayOSModel.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

@MainActor final class PlayOSModel: ObservableObject {
    
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
    
    @Published var windowModels: [WindowModel] = []
    
    @Published private(set) var menuIsPresented: Bool = false
    
    @Published private(set) var currentPhase: PlayOSPhase = .stopped
    
    func setPhase(_ mode: PlayOSPhase) {
        withAnimation {
            currentPhase = mode
        }
    }
    
    func openCloseMenu(_ open: Bool? = nil) {
        withAnimation {
            menuIsPresented = open ?? !menuIsPresented
        }
    }
    
    func createWindow(for app: Application) {
        windowModels.append(
            .init(application: app)
        )
        
        openCloseMenu(false)
    }
    
    func destroyWindow(id uuid: UUID) {
        windowModels.removeAll(
            where: { $0.id == uuid }
        )
    }
    
    func windowToFront(windowAt index: Int) {
        windowModels.move(
            fromOffsets: IndexSet(integer: index),
            toOffset: windowModels.count
        )
       
        openCloseMenu(false)
    }
}
