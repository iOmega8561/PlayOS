//
//  Application.ViewFactory.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 09/02/25.
//

import SwiftUI

extension Application {
    
    //MARK: - Supporting application protocols
    
    protocol Model: ObservableObject {
    
        init()
    }

    protocol Content: View {
        
        associatedtype AppModel: Model
        
        init(windowModel: WindowModel, appModel: AppModel)
    }
    
    // MARK: - Factory
    
    @MainActor struct ViewFactory {
        
        static func make(for application: Application) -> Self {
            return .init(application.contentType)
        }
        
        private let _build: (WindowModel, any Model) -> AnyView

        let makeModel: () -> any Model

        private init<Content: Application.Content>(_ contentType: Content.Type) {

            self.makeModel = { Content.AppModel() }
            
            _build = { windowModel, appModel in
                
                guard let typedModel = appModel as? Content.AppModel else {
                    fatalError("Invalid appModel type provided for \(Content.self)")
                }
                
                return AnyView(Content(windowModel: windowModel, appModel: typedModel))
            }
        }
        
        func build(windowModel: WindowModel, appModel: any Model) -> AnyView {
            return _build(windowModel, appModel)
        }
    }

}
