//
//  StoppedView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct StoppedView: View {
    
    @EnvironmentObject private var playOSModel: PlayOSModel
    
    var body: some View {
        
        VStack(spacing: 120) {
            
            VStack {
                HStack {
                    Text("Welcome to")
                    
                    Text("PlayOS")
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                }
                .font(.largeTitle)
                
                Text("Press the power button to start the system up!")
                    .font(.headline)
            }
            
            Button { playOSModel.setPhase(.poweringOn) } label: {
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
        }
        .foregroundStyle(.white)
    }
}
