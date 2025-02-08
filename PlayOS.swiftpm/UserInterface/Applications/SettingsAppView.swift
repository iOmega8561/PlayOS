//
//  SettingsAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct SettingsAppView: View {
    
    @EnvironmentObject private var appModel: AppModel
        
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
                
                Setting(settingKey: $appModel.backgroundImage)
                
                VStack(spacing: 5) {
                    HStack {
                        Text("User picture")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    Divider()
                }
                
                Setting(settingKey: $appModel.profilePicture)
            }
            .padding()
        }
        .contentShape(Rectangle())
        .background(.thinMaterial)
    }
}
