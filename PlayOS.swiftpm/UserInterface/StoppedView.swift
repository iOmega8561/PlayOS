//
//  StoppedView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct StoppedView: View {
    
    @Environment(\.setMode) private var setMode
    
    var body: some View {
        
        VStack(spacing: 120) {
            
            HStack {
                Text("Welcome to")
                
                Text("PlayOS")
                    .fontWeight(.bold)
                    .fontWidth(.expanded)
            }
            .font(.largeTitle)
            
            Button { setMode(.poweringOn) } label: {
                VStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color.red)
                        .overlay {
                            Image(systemName: "power.circle")
                                .resizable()
                                .scaledToFill()
                                .padding()
                                .foregroundStyle(.white)
                        }
                        .frame(width: 100, height: 100)
                }
            }
            
            Label("Press the power button to boot the system up!", systemImage: "info.circle")
                .labelStyle(.titleAndIcon)
                .imageScale(.large)
                .font(.headline)
                .padding(4)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: .init(lineWidth: 3.0))
                        .fill(Color.secondary)
                }
        }
    }
}
