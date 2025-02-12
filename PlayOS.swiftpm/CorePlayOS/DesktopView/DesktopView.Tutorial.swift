//
//  Desktop.Tutorial.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 11/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct Tutorial: View {
        
        @Binding var isPresented: Bool
        
        var body: some View {
            
            GeometryReader { geometry in
                
                ZStack(alignment: .center) {
                    
                    Color.black.opacity(0.7)
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            Text("stopped-greeting")
                            
                            Text(verbatim: "PlayOS")
                                .fontWeight(.bold)
                                .fontWidth(.expanded)
                            
                            Text("desktop")
                        }
                        .font(.title2)
                        
                        Text("Here you can explore different apps, learn about how operating systems work and challenge youself on your knowledge about computers. Have fun!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            Text("Explore the available apps by tapping")
                                .font(.title3)
                            
                            Label("Menu", systemImage: "cursorarrow.rays")
                                .foregroundStyle(.white)
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(7)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                        HStack(spacing: -10) {
                            Text("Or start quickly by tapping an icon on the desktop")
                                .font(.title3)
                            
                            VStack(alignment: .center, spacing: 3) {
                                Image(systemName: "chevron.left.slash.chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 64, height: 64)
                                    
                                Text("Learn Coding")
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 140)
                            .padding(3)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "link")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                    .padding(3)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .padding([.bottom, .trailing], 24)
                            }
                            .scaleEffect(0.75)
                        }
                    }
                    .frame(width: 650, height: 350)
                    .background(.regularMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor, lineWidth: 3)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button("All clear, let's get going!") {
                        withAnimation {
                            isPresented = false
                        }
                    }
                    .tint(.green)
                    .fontWeight(.bold)
                    .buttonStyle(.borderedProminent)
                    .padding([.bottom], 172)
                    .frame(height: geometry.size.height,
                           alignment: .bottomTrailing)
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
            }
        }
    }
}
