//
//  LoginView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct LoginView: View {
        
    @EnvironmentObject private var appModel: AppModel
    
    var body: some View {
        
        GeometryReader { proxy in
            
            Image(appModel.backgroundImage.description)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .blur(radius: 25, opaque: true)
                .opacity(0.8)
            
            VStack {
                
                Image(appModel.profilePicture.description)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(Circle())
                    .shadow(radius: 5.0)
                
                HStack {
                    Text("PlayOS")
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                    
                    Text("User")
                }
                .font(.title)
                .foregroundStyle(.white)
                
                HStack {
                    Button("Shutdown") {
                        appModel.setMode(.poweringOff)
                    }
                    
                    Button("Log In") {
                        appModel.setMode(.desktop)
                    }
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.bold)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}
