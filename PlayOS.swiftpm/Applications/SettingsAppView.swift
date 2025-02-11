//
//  SettingsAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct SettingsAppView: View {
    
    @EnvironmentObject private var playOSModel: PlayOSModel
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
                VStack(spacing: 5) {
                    HStack {
                        Text("app-settings-wallpaper")
                            .font(.headline)
                        
                        Spacer()
                    }
                    Divider()
                }
                Setting(settingKey: $playOSModel.backgroundImage)
                
                VStack(spacing: 5) {
                    HStack {
                        Text("app-settings-userpic")
                            .font(.headline)
                        
                        Spacer()
                    }
                    Divider()
                }
                Setting(settingKey: $playOSModel.profilePicture)
            }
            .padding()
        }
    }
}

// MARK: - Supporting nested types

private extension SettingsAppView {
    
    /// A view representing a single setting option within the settings screen.
    ///
    /// The `Setting` view displays a horizontally scrollable list of possible values
    /// for a given setting. It allows users to select a value by tapping on its corresponding image.
    /// The currently selected value is visually highlighted with overlay effects.
    ///
    /// - Parameter ValueType: The type of the setting value, which must conform to `Hashable`.
    struct Setting<ValueType: Hashable>: View {
        
        /// A binding to the key representing the current setting.
        ///
        /// The `SettingKey` encapsulates the current value, a list of possible values,
        /// and provides a description for each value used to generate the corresponding image.
        @Binding var settingKey: SettingKey<ValueType>
        
        /// The content and behavior of the view.
        ///
        /// This computed property builds the view hierarchy, which consists of a horizontal scroll view
        /// containing a series of buttons for each possible value. When a button is tapped, the corresponding
        /// value is assigned to the setting. The selected value is visually indicated by a checkmark overlay and a border.
        var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(settingKey.possibleValues, id: \.self) { value in
                        
                        Button { settingKey.value = value } label: {
                            
                            Image(settingKey.description(for: value))
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing) {
                                    if settingKey.value == value {
                                        Group {
                                            Circle()
                                                .fill(.background)
                                                .frame(width: 25)
                                            
                                            Image(systemName: "checkmark.circle.fill")
                                                .renderingMode(.template)
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.accentColor)
                                                .frame(width: 20)
                                        }
                                        .padding()
                                    }
                                }
                                .overlay {
                                    if settingKey.value == value {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.accentColor, lineWidth: 5)
                                    }
                                }
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.never)
        }
    }
}

// MARK: - Application Protocol Conformances

/// Conformance of `SettingsAppView` to the `Application.Content` protocol.
extension SettingsAppView: Application.Content {
    
    /// A dummy view model that doesn't actually hold any state
    /// Required in order to achieve conformation to the `Application.Content` protocol.
    final class Model: Application.Model { }
    
    /// Initializes the Settings view with the provided model.
    /// Since the view does not use any StateObject this init does effectively nothing
    ///
    /// - Parameter appModel: An instance of `SettingsAppView.Model` that holds the state for the view.
    init(appModel: Model) { }
}

