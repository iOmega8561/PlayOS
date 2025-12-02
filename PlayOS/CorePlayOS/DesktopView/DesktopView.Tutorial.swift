//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
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
                            
                            Text(verbatim: "desktop")
                        }
                        .font(.title2)
                        
                        Text("tutorial-desktop-message")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Divider()
                        
                        HStack {
                            Text("tutorial-desktop-hint1")
                                .font(.title3)
                            
                            Label("action-menu", systemImage: "cursorarrow.rays")
                                .foregroundStyle(.white)
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(7)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                        Divider()
                        
                        HStack(spacing: -10) {
                            Text("tutorial-desktop-hint2")
                                .font(.title3)
                            
                            VStack(alignment: .center, spacing: 3) {
                                Image(systemName: DesktopLink.learnCoding.sfSymbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 64, height: 64)
                                    
                                Text(DesktopLink.learnCoding.displayName)
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
                        
                        Divider()
                        
                        VStack(spacing: 0) {
                            Text("tutorial-desktop-hint3")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            
                            HStack(alignment: .center) {
                                HStack(alignment: .center, spacing: 10) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 25, height: 25)
                                    
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 25, height: 25)
                                    
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 25, height: 25)
                                }
                                .frame(width: 100)
                                .padding(.leading)
                                
                                Spacer()
                                
                                Text(verbatim: Application.calculator.displayName)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Spacer()
                                    .frame(width: 100)
                                    .padding(.trailing)
                            }
                            .frame(height: 40)
                            .background(.background)
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
                            .padding(.horizontal)
                            .scaleEffect(0.75)
                            .overlay {
                                Image(systemName: "hand.tap")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .offset(x: 120, y: 10)
                            }
                            
                        }
                        
                    }
                    .frame(width: 650, height: 420)
                    .background(.regularMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor, lineWidth: 3)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        Button("tutorial-dismiss") {
                            withAnimation {
                                isPresented = false
                            }
                        }
                        .tint(.green)
                        .fontWeight(.bold)
                        .buttonStyle(.borderedProminent)
                        .offset(y: 250)
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
            }
        }
    }
}
