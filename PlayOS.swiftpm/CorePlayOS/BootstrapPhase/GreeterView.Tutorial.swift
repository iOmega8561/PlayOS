//
//  GreeterView.Tutorial.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 11/02/25.
//

import SwiftUI

extension GreeterView {
    
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
                        }
                        .font(.title2)
                        
                        Text("You are in the lock screen")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical)
                        
                        HStack {
                            Text("Start using the system by tapping")
                                .font(.title3)
                            
                            Label("Unlock", systemImage: "lock.open.fill")
                                .foregroundStyle(.white)
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(7)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                        HStack {
                            Text("Get back to the first screen by tapping")
                                .font(.title3)
                            
                            Label("Halt", systemImage: "power")
                                .foregroundStyle(.white)
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(7)
                                .background(Color.red.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                    .frame(width: 500, height: 300)
                    .background(.regularMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor, lineWidth: 3)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        Button("All clear, let's get going!") {
                            withAnimation {
                                isPresented = false
                            }
                        }
                        .tint(.green)
                        .fontWeight(.bold)
                        .buttonStyle(.borderedProminent)
                        .offset(y: 200)
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
            }
        }
    }
}
