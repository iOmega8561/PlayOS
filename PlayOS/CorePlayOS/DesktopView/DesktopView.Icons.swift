//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
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
                
                ForEach(DesktopLink.allCases, id: \.self) { desktopLink in
                    
                    Button {
                        playOSModel.createWindow(using: .init(
                            for: desktopLink.application,
                            expandIn: desktopGeometry,
                            withInitialState: desktopLink.initialState
                        ))
                    } label: {
                        VStack(alignment: .center, spacing: 3) {
                            Image(systemName: desktopLink.sfSymbol)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                
                            Text(desktopLink.displayName)
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
