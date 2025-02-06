//
//  DesktopView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct DesktopView: View {
    
    @Environment(\.setMode) private var setMode
    
    @EnvironmentObject private var appModel: AppModel
    
    var body: some View {
        
        GeometryReader { proxy in
            
            Image(appModel.backgroundImage)
                .resizable()
                .scaledToFill()
                .frame(height: proxy.size.height)
            
            VStack {
                
                ZStack {
                    // TO-DO
                }
                .frame(width: proxy.size.width, height: proxy.size.height - 60)
                
                HStack {
                    
                    Button("Menu", systemImage: "cursorarrow.rays") {
                        // TO-DO
                    }
                    .fontWeight(.bold)
                    .buttonStyle(.borderedProminent)
                    .padding(.leading)
                    
                    Spacer()
                    
                    Spacer()
                    
                    Text(Date.now.formatted())
                        .padding(10)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing)
                    
                }
                .frame(width: proxy.size.width, height: 60)
                .background(.ultraThinMaterial)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}
