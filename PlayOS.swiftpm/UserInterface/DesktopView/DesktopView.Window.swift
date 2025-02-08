//
//  DesktopView.Window.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct Window: View {
        
        let desktopGeometry: GeometryProxy
        
        @Binding var window: WindowModel
        
        @EnvironmentObject private var appModel: AppModel
        
        @State private var dragOffset: CGSize = .zero
        
        var body: some View {
   
            VStack(spacing: 0) {
                
                HStack(alignment: .bottom) {
                    
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            appModel.windows.removeAll(
                                where: { $0.id == window.id }
                            )
                        } label: { Circle().fill(Color.red) }
                            .frame(width: 25, height: 25)
                        
                        Button {
                            window.isMinimized = true
                        } label: { Circle().fill(Color.yellow) }
                            .frame(width: 25, height: 25)
                        
                        if window.isResizable {
                            
                            Button {
                                if window.isExpanded {
                                    window.expand()
                                    
                                } else { window.expand(in: desktopGeometry) }
                            } label: {
                                Circle()
                                    .fill(.green.opacity(window.isExpanded ? 0.5:1))
                            }
                            .frame(width: 25, height: 25)
                        }
                        
                        Spacer()
                    }
                    .buttonStyle(.plain)
                    .frame(width: 100)
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text(window.application.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Spacer().frame(width: 100)
                }
                .contentShape(Rectangle())
                .frame(width: window.currentSize.width, height: 40)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            
                            guard !window.isExpanded else { return }
                            
                            window.move(
                                computing: gesture.translation,
                                in: desktopGeometry
                            )
                        }
                )
                
                window.application.content
                    .frame(width: window.currentSize.width,
                           height: window.currentSize.height - 40)
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3.0)
        }
    }
}
