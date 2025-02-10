//
//  WindowManager.Window.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension WindowManager {
    
    struct Window: View {
        
        let desktopGeometry: GeometryProxy
        
        @Binding var windowModel: WindowModel
        
        @EnvironmentObject private var playOSModel: PlayOSModel
        
        @State private var dragOffset: CGSize = .zero
        
        var body: some View {
   
            VStack(spacing: 0) {
                
                HStack(alignment: .bottom) {
                    
                    Controls(
                        desktopGeometry: desktopGeometry,
                        windowModel: $windowModel
                    )
                    .frame(width: 100)
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text(windowModel.application.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Spacer().frame(width: 100)
                }
                .contentShape(Rectangle())
                .frame(width: windowModel.currentSize.width, height: 40)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            windowModel.move(
                                computing: gesture.translation,
                                in: desktopGeometry
                            )
                        }
                )
                
                Content(windowModel: $windowModel)
                    .frame(width: windowModel.currentSize.width,
                           height: windowModel.currentSize.height - 40)
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3.0)
        }
    }
}
