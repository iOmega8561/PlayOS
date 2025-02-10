//
//  DesktopView.StartMenu.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct StartMenu: View {
                
        @EnvironmentObject private var playOSModel: PlayOSModel
                
        var body: some View {
            
            VStack(alignment: .center) {
                
                HStack {
                    Text("PlayOS")
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                    
                    Text("Menu")
                }
                .font(.title)
                
                Divider()
                
                Spacer()
                
                ForEach(Application.allCases, id: \.self) { app in
                    Button { playOSModel.createWindow(for: app) } label: {
                        
                        HStack {
                            Image(systemName: app.sfSymbol)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            
                            Text(app.title)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .fontWeight(.bold)
                        .frame(width: 205, height: 40)
                        .contentShape(RoundedRectangle(cornerRadius: 7))
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                HStack {
                    Button("Shutdown") {
                        playOSModel.setPhase(.poweringOff)
                    }
                    
                    Button("Log Out") {
                        playOSModel.setPhase(.login)
                    }
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.bold)
            }
            .frame(width: 210, height: 400)
            .padding(10)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5.0)
        }
    }
}
