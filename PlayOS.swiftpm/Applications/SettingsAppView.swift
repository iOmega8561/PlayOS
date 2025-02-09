//
//  SettingsAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct SettingsAppView: Application.Content {
    
    final class Model: Application.Model {
        init() {}
    }
    
    init(appModel: Model) {
        
    }
    
    @EnvironmentObject private var playOSModel: PlayOSModel
        
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Wallpaper")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    Divider()
                }
                
                Setting(settingKey: $playOSModel.backgroundImage)
                
                VStack(spacing: 5) {
                    HStack {
                        Text("User picture")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    Divider()
                }
                
                Setting(settingKey: $playOSModel.profilePicture)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .background(.thinMaterial)
    }
}
