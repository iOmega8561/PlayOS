//
//  DesktopView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct DesktopView: View {
        
    @EnvironmentObject private var appModel: AppModel
    
    @State private var menuIsPresented: Bool = false
    
    var body: some View {
        
        GeometryReader { containerGeometry in
            
            Image(appModel.backgroundImage.description)
                .resizable()
                .scaledToFill()
                .onTapGesture { menuIsPresented = false }
            
            VStack(alignment: .leading, spacing: 0) {
                
                GeometryReader { desktopGeometry in
                    ZStack {
                        
                        ForEach(appModel.windowModels) { windowModel in
                            
                            let index = appModel.windowModels.firstIndex(of: windowModel)
                            
                            if let index, !windowModel.isMinimized {
                                
                                Window(
                                    desktopGeometry: desktopGeometry,
                                    windowModel: $appModel.windowModels[index]
                                )
                                .offset(windowModel.offset)
                                .onTapGesture {
                                    appModel.windowModels.move(
                                        fromOffsets: IndexSet(integer: index),
                                        toOffset: appModel.windowModels.count
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
