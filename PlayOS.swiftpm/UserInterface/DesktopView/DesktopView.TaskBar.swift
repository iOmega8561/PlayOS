//
//  DesktopView.TaskBar.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension DesktopView {
    
    struct TaskBar: View {
        
        @EnvironmentObject private var appModel: AppModel
        
        var body: some View {
            
            ScrollView(.horizontal) {
                
                HStack(alignment: .center) {
                    
                    ForEach(appModel.windows.indices, id: \.self) { windowIdx in
                        
                        if appModel.windows[windowIdx].isMinimized {
                            
                            let app = appModel.windows[windowIdx].application
                            
                            Button {
                                appModel.windows[windowIdx].isMinimized = false
                            } label: {
                                
                                HStack {
                                    Image(systemName: app.sfSymbol)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                    
                                    Text(app.title)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .fontWeight(.bold)
                                .frame(height: 40)
                                .contentShape(RoundedRectangle(cornerRadius: 7))
                                .background(.thickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
