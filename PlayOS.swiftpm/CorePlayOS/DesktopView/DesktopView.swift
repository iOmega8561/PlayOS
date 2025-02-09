//
//  DesktopView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct DesktopView: View {
        
    @EnvironmentObject private var playOSModel: PlayOSModel
        
    var body: some View {
        
        GeometryReader { containerGeometry in
            
            Image(playOSModel.backgroundImage.description)
                .resizable()
                .scaledToFill()
                .onTapGesture { playOSModel.menuIsPresented = false }
            
            VStack(alignment: .leading, spacing: 0) {
                
                GeometryReader { desktopGeometry in
                    WindowManager(desktopGeometry: desktopGeometry)
                        .onTapGesture { playOSModel.menuIsPresented = false }
                }
                .frame(width: containerGeometry.size.width,
                       height: containerGeometry.size.height - 60)
                
                HStack {
                    Toggle("Menu", systemImage: "cursorarrow.rays", isOn: $playOSModel.menuIsPresented)
                        .toggleStyle(.button)
                        .fontWeight(.bold)
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        .overlay {
                            if playOSModel.menuIsPresented {
                                StartMenu()
                                    .offset(x: 75, y: -245)
                                    .onTapGesture { }
                            }
                        }
                    
                    TaskBar()
                    
                    Spacer()
                    
                    Text(Date.now.formatted(date: .abbreviated, time: .shortened))
                        .padding(10)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing)
                }
                .frame(width: containerGeometry.size.width, height: 60)
                .background(.ultraThinMaterial)
                .onTapGesture { playOSModel.menuIsPresented = false }
            }
            .frame(width: containerGeometry.size.width,
                   height: containerGeometry.size.height)
        }
    }
}
