//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
//
//  GreeterView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct GreeterView: View {
        
    @EnvironmentObject private var playOSModel: PlayOSModel
        
    var body: some View {
        
        GeometryReader { containerGeometry in
            
            Image(playOSModel.backgroundImage.description)
                .resizable()
                .scaledToFill()
                .blur(radius: 25, opaque: true)
                .opacity(0.8)
                .frame(width: containerGeometry.size.width,
                       height: containerGeometry.size.height)
                .clipped()
            
            VStack {
                
                Image(playOSModel.profilePicture.description)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(Circle())
                    .shadow(radius: 5.0)
                
                HStack {
                    Text(verbatim: "PlayOS")
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                    
                    Text("default-user")
                }
                .font(.title)
                .foregroundStyle(.white)
                
                HStack {
                    Button("action-halt", systemImage: "power") {
                        playOSModel.setPhase(.poweringOff)
                    }
                    .tint(.red.opacity(0.9))
                    
                    Button("action-unlock", systemImage: "lock.open.fill") {
                        playOSModel.setPhase(.desktop)
                    }
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.bold)
            }
            .frame(width: containerGeometry.size.width,
                   height: containerGeometry.size.height)
            .overlay {
                if playOSModel.greeterTutorial {
                    Tutorial(isPresented: $playOSModel.greeterTutorial)
                        .frame(width: containerGeometry.size.width,
                               height: containerGeometry.size.height)
                        .transition(.opacity)
                }
            }
        }
    }
}
