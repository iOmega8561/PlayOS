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
    
    @State private var menuIsPresented: Bool = false
    
    var body: some View {
        
        GeometryReader { proxy in
            
            Image(appModel.backgroundImage)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onTapGesture { menuIsPresented = false }
            
            VStack(alignment: .leading) {
                
                ZStack {
                    
                    // TO-DO
                    
                    ForEach(appModel.windows.indices, id: \.self) { windowIdx in
                        
                        Window(window: $appModel.windows[windowIdx])
                            .frame(width: 550, height: 430)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .offset(appModel.windows[windowIdx].offset)
                            .onTapGesture {
                                appModel.windows.move(
                                    fromOffsets: IndexSet(integer: windowIdx),
                                    toOffset: appModel.windows.count
                                )
                                menuIsPresented = false
                            }
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height - 60)
                .onTapGesture { menuIsPresented = false }
                
                HStack {
                    Toggle("Menu", systemImage: "cursorarrow.rays", isOn: $menuIsPresented)
                        .toggleStyle(.button)
                        .fontWeight(.bold)
                        .buttonStyle(.borderedProminent)
                        .padding(.leading)
                        .overlay {
                            if menuIsPresented {
                                StartMenu()
                                    .offset(x: 75, y: -245)
                                    .onTapGesture { }
                            }
                        }
                    
                    Spacer()
                    
                    Text(Date.now.formatted())
                        .padding(10)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing)
                }
                .frame(width: proxy.size.width, height: 60)
                .background(.ultraThinMaterial)
                .onTapGesture { menuIsPresented = false }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}
