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
        
        GeometryReader { proxy in
            
            Image(playOSModel.backgroundImage.description)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .blur(radius: 25, opaque: true)
                .opacity(0.8)
            
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
                    Button("action-shutdown") {
                        playOSModel.setPhase(.poweringOff)
                    }
                    
                    Button("action-login") {
                        playOSModel.setPhase(.desktop)
                    }
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.bold)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}
