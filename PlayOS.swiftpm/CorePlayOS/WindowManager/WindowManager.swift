//
//  WindowManager.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 09/02/25.
//

import SwiftUI

struct WindowManager: View {
    
    let desktopGeometry: GeometryProxy
    
    @EnvironmentObject private var playOSModel: PlayOSModel
    
    var body: some View {
        
        ZStack {
            ForEach(playOSModel.windowModels) { windowModel in
                
                let index = playOSModel.windowModels.firstIndex(of: windowModel)
                
                if let index, !windowModel.isMinimized {
                    
                    Window(
                        desktopGeometry: desktopGeometry,
                        windowModel: $playOSModel.windowModels[index]
                    )
                    .offset(windowModel.offset)
                    .onTapGesture {
                        playOSModel.windowToFront(windowAt: index)
                    }
                    .transition(.opacity)
                }
            }
        }
        .frame(width: desktopGeometry.size.width,
               height: desktopGeometry.size.height)
    }
}
