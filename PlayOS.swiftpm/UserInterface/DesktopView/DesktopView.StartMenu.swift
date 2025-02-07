//
//  DesktopView.StartMenu.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct StartMenu: View {
        
        @Environment(\.setMode) private var setMode
        
        @EnvironmentObject private var appModel: AppModel
        
        var body: some View {
            
            VStack(alignment: .center) {
                
                HStack {
                    Text("PlayOS")
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                    
                    Text("Menu")
                }
                .font(.title)
                
                Divider()
                
                Spacer()
                
                ForEach(Application.allCases, id: \.self) { app in
                    Button {
                        appModel.windows.append(app.makeWindow())
                        
                    } label: {
                        Text(app.name)
                            .fontWeight(.bold)
                            .frame(width: 205, height: 30)
                            .contentShape(RoundedRectangle(cornerRadius: 7))
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                HStack {
                    Button("Shutdown") {
                        setMode(.poweringOff)
                    }
                    
                    Button("Log Out") {
                        setMode(.login)
                    }
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.bold)
            }
            .frame(width: 210, height: 400)
            .padding(10)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5.0)
        }
    }
}
