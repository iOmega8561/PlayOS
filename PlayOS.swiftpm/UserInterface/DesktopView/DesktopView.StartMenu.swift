//
//  DesktopView.StartMenu.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct StartMenu: View {
        
        @Environment(\.setMode) private var setMode
        
        var body: some View {
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("PlayOS")
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                    
                    Text("Menu")
                }
                .font(.title)
                
                Divider()
                
                Spacer()
                
                Divider()
                
                HStack {
                    Button("Shutdown") {
                        setMode(.poweringOff)
                    }
                    
                    Button("Log Out") {
                        setMode(.login)
                    }
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.bold)
            }
            .frame(width: 230, height: 400)
            .padding(10)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5.0)
        }
    }
}
