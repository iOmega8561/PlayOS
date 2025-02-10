//
//  WindowManager.Controls.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 09/02/25.
//

import SwiftUI

extension WindowManager {
    
    struct Controls: View {
        
        let desktopGeometry: GeometryProxy
        
        @Binding var windowModel: WindowModel
        
        @EnvironmentObject private var playOSModel: PlayOSModel
        
        var body: some View {
            
            HStack(alignment: .center, spacing: 10) {
                
                Button { playOSModel.destroyWindow(id: windowModel.id) } label: {
                    Circle()
                        .fill(Color.red)
                }
                .frame(width: 25, height: 25)
                
                Button {
                    withAnimation {
                        windowModel.isMinimized.toggle()
                    }
                } label: {
                    Circle()
                        .fill(Color.yellow)
                }
                .frame(width: 25, height: 25)
                
                if windowModel.isResizable {
                    
                    Button {
                        withAnimation {
                            if windowModel.isExpanded {
                                windowModel.expand()
                                
                            } else { windowModel.expand(in: desktopGeometry) }
                        }
                    } label: {
                        Circle()
                            .fill(.green.opacity(windowModel.isExpanded ? 0.5:1))
                    }
                    .frame(width: 25, height: 25)
                }
                
                Spacer()
            }
            .buttonStyle(.plain)
        }
    }
}
