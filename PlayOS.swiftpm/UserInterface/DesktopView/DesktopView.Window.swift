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
        
        @Binding var window: WindowModel
        
        var body: some View {
            
            GeometryReader { proxy in
                
                VStack(spacing: 0) {
                    
                    HStack(alignment: .center) {
                        
                        HStack(alignment: .center, spacing: 10) {
                            Button {
                                appModel.windows.removeAll(
                                    where: { $0.id == window.id }
                                )
                            } label: { Circle().fill(Color.red) }
                                .frame(width: 20, height: 20)
                            
                            Button {
                                window.isMinimized = true
                            } label: { Circle().fill(Color.yellow) }
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 80)
                        
                        Spacer()
                        
                        Text(window.application.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Spacer().frame(width: 80)
                    }
                    .contentShape(Rectangle())
                    .frame(width: proxy.size.width, height: 40)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                window.offset.width += gesture.translation.width
                                window.offset.height += gesture.translation.height
                            }
                    )
                                
                    window.application.content
                        .frame(width: proxy.size.width, height: proxy.size.height - 40)
                }
            }
        }
    }
}
