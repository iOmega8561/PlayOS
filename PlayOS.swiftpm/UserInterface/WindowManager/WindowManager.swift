//
//  WindowManager.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct WindowManager: View {
    
    @EnvironmentObject private var appModel: AppModel
    
    var body: some View {
        
        ForEach(appModel.windows) { window in
            
            VStack(spacing: 0) {
                
                HStack(alignment: .center) {
                    Button {
                        appModel.windows.removeAll(
                            where: { $0.id == window.id }
                        )
                        
                    } label: { Circle().fill(Color.red) }
                        .buttonStyle(.plain)
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Text(window.application.name)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .frame(width: 550, height: 35)
                
                window.application.view
                    .frame(width: 550, height: 395)
            }
            .frame(width: 550, height: 430)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
