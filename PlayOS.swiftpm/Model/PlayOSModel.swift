//
//  PlayOSModel.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

/// A model representing the state of the PlayOS operating system simulation.
/// This class is the central state container responsible for managing tutorials, user settings,
/// open windows, menu presentation, and the current phase of the system.
/// All UI updates are published and executed on the main actor.
@MainActor final class PlayOSModel: ObservableObject {
    
    /// Indicates whether the desktop tutorial is active.
    @Published var desktopTutorial: Bool = true
    
    /// Indicates whether the greeter (login) tutorial is active.
    @Published var greeterTutorial: Bool = true
    
    /// The user's selected profile picture setting.
    /// Uses a `SettingKey` with an `Int` value representing the chosen profile picture.
    @Published var profilePicture: SettingKey<Int> = .init(
        namespace: "ProfilePics",
        default: 1,
        possibleValues: [1, 2, 3, 4]
    )
    
    /// The user's selected background image setting.
    /// Uses a `SettingKey` with an `Int` value representing the chosen background image.
    @Published var backgroundImage: SettingKey<Int> = .init(
        namespace: "Backgrounds",
        default: 1,
        possibleValues: [1, 2, 3, 4]
    )
    
    /// An array of models representing open windows in the system.
    @Published var windowModels: [WindowModel] = []
    
    /// Indicates whether the system menu is currently presented.
    /// This property is read-only from outside the class.
    @Published private(set) var menuIsPresented: Bool = false
    
    /// The current phase of the PlayOS operating system.
    /// Phases include states such as stopped, powering on, powering off, login, or desktop.
    @Published private(set) var currentPhase: PlayOSPhase = .stopped
    
    /// Sets the current phase of the operating system with an animation.
    /// If the phase is set to powering off, it clears all window models and hides the menu.
    ///
    /// - Parameter mode: The new phase to set.
    func setPhase(_ mode: PlayOSPhase) {
        withAnimation {
            currentPhase = mode
            
            if mode == .poweringOff {
                windowModels = []
                menuIsPresented = false
            }
        }
    }
    
    /// Opens or closes the system menu with an animation.
    /// If a value is provided, it sets the menu's state accordingly;
    /// otherwise, it toggles the current state.
    ///
    /// - Parameter open: An optional Boolean value indicating whether to open (`true`) or close (`false`) the menu.
    func openCloseMenu(_ open: Bool? = nil) {
        withAnimation {
            menuIsPresented = open ?? !menuIsPresented
        }
    }
    
    /// Creates a new window using the provided window model and adds it to the list of open windows.
    /// After adding the new window, the system menu is closed.
    ///
    /// - Parameter windowModel: The `WindowModel` representing the new window.
    func createWindow(using windowModel: WindowModel) {
        windowModels.append(windowModel)
        openCloseMenu(false)
    }
    
    /// Creates a new window for a specified application.
    /// This method initializes a new `WindowModel` for the given application and then creates the window.
    ///
    /// - Parameter application: The application for which to create the window.
    func createWindow(for application: Application) {
        createWindow(using: .init(for: application))
    }
    
    /// Destroys the window with the specified unique identifier.
    ///
    /// - Parameter uuid: The unique identifier of the window to remove.
    func destroyWindow(id uuid: UUID) {
        windowModels.removeAll { $0.id == uuid }
    }
    
    /// Brings the window at the specified index to the front of the window stack.
    /// This is done by moving the window to the end of the `windowModels` array.
    /// After reordering, the system menu is closed.
    ///
    /// - Parameter index: The index of the window to bring to the front.
    func windowToFront(windowAt index: Int) {
        windowModels.move(
            fromOffsets: IndexSet(integer: index),
            toOffset: windowModels.count
        )
        openCloseMenu(false)
    }
}
