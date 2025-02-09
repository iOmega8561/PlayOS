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
                    
                    ForEach(appModel.windowModels) { windowModel in
                        
                        let index = appModel.windowModels.firstIndex(of: windowModel)
                        
                        if let index, windowModel.isMinimized {
                            
                            Button { appModel.windowModels[index].isMinimized = false } label: {
                                
                                HStack {
                                    Image(systemName: windowModel.application.sfSymbol)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                    
                                    Text(windowModel.application.title)
                                    
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
