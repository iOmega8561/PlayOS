//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
//
//  DesktopView.TaskBar.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct TaskBar: View {
        
        @EnvironmentObject private var playOSModel: PlayOSModel
        
        var body: some View {
            
            ScrollView(.horizontal) {
                
                HStack(alignment: .center) {
                    
                    ForEach(playOSModel.windowModels) { windowModel in
                        
                        let index = playOSModel.windowModels.firstIndex(of: windowModel)
                        
                        if let index, windowModel.isMinimized {
                            
                            Button {
                                withAnimation {
                                    playOSModel.windowModels[index].isMinimized.toggle()
                                }
                            } label: {
                                
                                HStack {
                                    Image(systemName: windowModel.application.sfSymbol)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                    
                                    Text(windowModel.application.displayName)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .fontWeight(.bold)
                                .frame(height: 40)
                                .contentShape(RoundedRectangle(cornerRadius: 7))
                                .background(.thickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
