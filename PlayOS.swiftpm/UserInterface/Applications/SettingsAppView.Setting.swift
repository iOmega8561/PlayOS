//
//  SettingsAppView.Setting.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension SettingsAppView {
    
    struct Setting: View {
        
        let imgPath: String
        
        @Binding var setting: String
        
        var body: some View {
            
            ScrollView(.horizontal) {
                
                HStack {
                    ForEach(1..<5) { index in
                        
                        Button { setting = imgPath + "/\(index)" } label: {
                            
                            Image(imgPath + "/\(index)")
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing) {
                                    
                                    if setting == imgPath + "/\(index)" {
                                        
                                        Group {
                                            Circle()
                                                .fill(.background)
                                                .frame(width: 25)
                                            
                                            Image(systemName: "checkmark.circle.fill")
                                                .renderingMode(.template)
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.accentColor)
                                                .frame(width: 20)
                                        }
                                        .padding()
                                    }
                                }
                                .overlay {
                                    
                                    if setting == imgPath + "/\(index)" {
                                        
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.accentColor, lineWidth: 5)
                                    }
                                }
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.never)
        }
    }
}
