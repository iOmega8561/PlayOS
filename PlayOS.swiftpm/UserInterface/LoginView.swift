//
//  LoginView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.setMode) private var setMode
    
    @EnvironmentObject private var appModel: AppModel
    
    var body: some View {
        
        Image(appModel.backgroundImage)
            .blur(radius: 25, opaque: true)
            .opacity(0.8)
        
        VStack {
            
            Image(appModel.profilePicture)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .clipShape(Circle())
                .shadow(radius: 3.0)
            
            HStack {
                Text("PlayOS")
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
                
                Text("User")
            }
            .font(.title)
            
            HStack {
                Button("Shutdown") {
                    setMode(.poweringOff)
                }
                
                Button("Log In") {
                    setMode(.desktop)
                }
            }
            .buttonStyle(.borderedProminent)
            .fontWeight(.bold)
        }
    }
}
