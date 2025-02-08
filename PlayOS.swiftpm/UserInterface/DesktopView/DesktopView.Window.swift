//
//  DesktopView.Window.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct Window: View {
        
        @EnvironmentObject private var appModel: AppModel
        
        @State private var dragOffset: CGSize = .zero
        
        let desktopGeometry: GeometryProxy
        
        @Binding var window: WindowModel
        
        var body: some View {
   
            VStack(spacing: 0) {
                
                HStack(alignment: .center) {
                    
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
                                switch window.currentSize {
                                case .large: window.resize()
                                default: window.resize(to: .large(fixed: false))
                                }
                            } label: {
                                Circle()
                                    .fill(Color.green.opacity(window.currentSize == .large(fixed: false) ? 0.5:1))
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
                            window.offset.width += gesture.translation.width
                            window.offset.height += gesture.translation.height
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
