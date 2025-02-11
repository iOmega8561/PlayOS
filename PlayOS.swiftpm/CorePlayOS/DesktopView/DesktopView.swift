//
//  DesktopView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

struct DesktopView: View {
        
    @EnvironmentObject private var playOSModel: PlayOSModel
        
    @State private var calendarPopoverIsShown: Bool = false
    
    var body: some View {
        
        GeometryReader { containerGeometry in
            
            Image(playOSModel.backgroundImage.description)
                .resizable()
                .scaledToFill()
                .onTapGesture { playOSModel.openCloseMenu(false) }
            
            VStack(alignment: .leading, spacing: 0) {
                
                GeometryReader { desktopGeometry in
                    WindowManager(desktopGeometry: desktopGeometry)
                        .onTapGesture { playOSModel.openCloseMenu(false) }
                }
                .frame(width: containerGeometry.size.width,
                       height: containerGeometry.size.height - 60)
                
                HStack {
                    Button("action-menu", systemImage: "cursorarrow.rays") {
                        playOSModel.openCloseMenu()
                    }
                    .fontWeight(.bold)
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    .overlay {
                        if playOSModel.menuIsPresented {
                            StartMenu()
                                .offset(x: 75, y: -245)
                                .onTapGesture { }
                                .transition(.move(edge: .bottom))
                        }
                    }
                    
                    TaskBar()
                    
                    Spacer()
                    
                    Button { calendarPopoverIsShown.toggle() } label: {
                        Text(Date.now.formatted(date: .abbreviated, time: .shortened))
                            .padding(10)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing)
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $calendarPopoverIsShown) {
                        DatePicker(selection: .constant(.now), displayedComponents: .date) {}
                            .datePickerStyle(.graphical)
                            .frame(width: 350)
                            .padding(.horizontal)
                    }
                }
                .frame(width: containerGeometry.size.width, height: 60)
                .background(.ultraThinMaterial)
                .onTapGesture { playOSModel.openCloseMenu(false) }
            }
            .frame(width: containerGeometry.size.width,
                   height: containerGeometry.size.height)
        }
    }
}
