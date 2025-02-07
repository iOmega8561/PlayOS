//
//  SettingsAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct SettingsAppView: View {
    
    @EnvironmentObject private var appModel: AppModel
    
    private let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ScrollView {
            Group {
                VStack(spacing: 5) {
                    HStack {
                        Text("Wallpaper")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    Divider()
                }
                
                LazyVGrid(columns: gridItemLayout, spacing: 10) {
                    ForEach(1..<5) { index in
                        Button {
                            appModel.backgroundImage = "Backgrounds/\(index)"
                        } label: {
                            Image("Backgrounds/\(index)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                VStack(spacing: 5) {
                    HStack {
                        Text("User picture")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    Divider()
                }
                
                HStack(spacing: 10) {
                    ForEach(1..<5) { index in
                        Button {
                            appModel.profilePicture = "ProfilePics/\(index)"
                        } label: {
                            Image("ProfilePics/\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
        }
        .contentShape(Rectangle())
        .background(.thinMaterial)
    }
}
