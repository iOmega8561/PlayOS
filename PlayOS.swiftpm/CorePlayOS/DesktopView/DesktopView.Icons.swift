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
        
        @Binding var exploreDefaultApp: ExploreAppView.WebApp
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 25) {
                
                Button {
                    exploreDefaultApp = .codingChallenge
                    playOSModel.createWindow(for: .explore)
                    exploreDefaultApp = .homePage
                } label: {
                    VStack(alignment: .center, spacing: 3) {
                        Image(systemName: "chevron.left.slash.chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            
                        Text("Learn Coding")
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
                
                
                Button {
                    exploreDefaultApp = .computerQuiz
                    playOSModel.createWindow(for: .explore)
                    exploreDefaultApp = .homePage
                } label: {
                    VStack(alignment: .center, spacing: 3) {
                        Image(systemName: "laptopcomputer.and.ipad")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            
                        Text("Learn Computers")
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
            .padding([.top, .leading], 32)
        }
    }
}
