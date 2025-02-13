//
//  DesktopView.Icons.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 12/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct Icons: View {
        
        @EnvironmentObject private var playOSModel: PlayOSModel
        
        let desktopGeometry: GeometryProxy
                
        var body: some View {
            
            VStack(alignment: .leading, spacing: 25) {
                
                ForEach(Application.DesktopIcon.allCases, id: \.self) { desktopIcon in
                    
                    Button {
                        playOSModel.createWindow(using: .init(
                            for: desktopIcon.application,
                            expandIn: desktopGeometry,
                            withInitialState: desktopIcon.initialState
                        ))
                    } label: {
                        VStack(alignment: .center, spacing: 3) {
                            Image(systemName: desktopIcon.sfSymbol)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                
                            Text(desktopIcon.title)
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
                        .shadow(radius: 3.0)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding([.top, .leading], 32)
            .frame(width: desktopGeometry.size.width,
                   height: desktopGeometry.size.height,
                   alignment: .topLeading)
        }
    }
}
