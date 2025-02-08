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
        
        GeometryReader { containerGeometry in
            
            Image(appModel.backgroundImage)
                .resizable()
                .scaledToFill()
                .frame(width: containerGeometry.size.width,
                       height: containerGeometry.size.height)
                .onTapGesture { menuIsPresented = false }
            
            VStack(alignment: .leading, spacing: 0) {
                
                GeometryReader { desktopGeometry in
                    ZStack {
                        
                        ForEach(appModel.windows.indices, id: \.self) { windowIdx in
                            if !appModel.windows[windowIdx].isMinimized {
                                
                                Window(desktopGeometry: desktopGeometry,
                                       window: $appModel.windows[windowIdx])
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
                    }
                    .frame(width: desktopGeometry.size.width,
                           height: desktopGeometry.size.height)
                    .onTapGesture { menuIsPresented = false }
                }
                .frame(width: containerGeometry.size.width,
                       height: containerGeometry.size.height - 60)
                
                HStack {
                    Toggle("Menu", systemImage: "cursorarrow.rays", isOn: $menuIsPresented)
                        .toggleStyle(.button)
                        .fontWeight(.bold)
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        .overlay {
                            if menuIsPresented {
                                StartMenu(isPresented: $menuIsPresented)
                                    .offset(x: 75, y: -245)
                                    .onTapGesture { }
                            }
                        }
                    
                    TaskBar()
                    
                    Spacer()
                    
                    Text(Date.now.formatted(date: .abbreviated, time: .shortened))
                        .padding(10)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing)
                }
                .frame(width: containerGeometry.size.width, height: 60)
                .background(.ultraThinMaterial)
                .onTapGesture { menuIsPresented = false }
            }
            .frame(width: containerGeometry.size.width,
                   height: containerGeometry.size.height)
        }
    }
}
