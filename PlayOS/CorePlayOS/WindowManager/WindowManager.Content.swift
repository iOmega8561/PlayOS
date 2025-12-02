//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
//
//  WindowManager.Container.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 09/02/25.
//

import SwiftUI

extension WindowManager {
    
    struct Content: View {
        
        @Binding var windowModel: WindowModel
        
        private let stateObject: any Application.Model
        
        private var application: Application {
            windowModel.application
        }
        
        private let appFactory: Application.ViewFactory
        
        var body: some View {
            
            appFactory.build(
                appModel: stateObject
            )
            .task(priority: .userInitiated) { @MainActor in
                windowModel.stateObject = stateObject
            }
        }
        
        init(windowModel: Binding<WindowModel>) {
            
            let wrappedValue = windowModel.wrappedValue
            
            _windowModel = windowModel
            
            self.appFactory = Application.ViewFactory.make(
                for: wrappedValue.application
            )
            
            self.stateObject = wrappedValue.stateObject ?? appFactory.makeModel()
        }
    }
}
