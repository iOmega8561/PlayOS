//
//  SettingsAppView.Setting.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

extension SettingsAppView {
    
    struct Setting<ValueType: Hashable>: View {
        
        @Binding var settingKey: SettingKey<ValueType>
        
        var body: some View {
            
            ScrollView(.horizontal) {
                
                HStack {
                    ForEach(settingKey.possibleValues, id: \.self) { value in
                        
                        Button { settingKey.value = value } label: {
                            
                            Image(settingKey.description(for: value))
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing) {
                                    
                                    if settingKey.value == value {
                                        
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
                                    
                                    if settingKey.value == value {
                                        
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
