//
//  AnyStatefulAppViewFactory.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 09/02/25.
//

import SwiftUI

struct ApplicationContainer: View {
    
    @Binding var windowModel: WindowModel
    
    private let stateObject: any StatefulAppModel
    
    private var application: Application {
        windowModel.application
    }
    
    private let appFactory: AnyStatefulAppViewFactory
    
    var body: some View {
        
        appFactory.build(
            windowModel: windowModel, appModel: stateObject
        )
        .task(priority: .userInitiated) { @MainActor in
            windowModel.stateObject = stateObject
        }
    }
    
    init(windowModel: Binding<WindowModel>) {
        
        let wrappedValue = windowModel.wrappedValue
        
        _windowModel = windowModel
        
        self.appFactory = AnyStatefulAppViewFactory.make(
            for: wrappedValue.application
        )
        
        self.stateObject = wrappedValue.stateObject ?? appFactory.makeModel()
    }
}


@MainActor struct AnyStatefulAppViewFactory {
    
    static func make(for application: Application) -> AnyStatefulAppViewFactory {
        return .init(application.contentType)
    }
    
    private let _build: (WindowModel, any StatefulAppModel) -> AnyView

    let makeModel: () -> any StatefulAppModel

    private init<Content: StatefulAppView>(_ contentType: Content.Type) {

        self.makeModel = { Content.Model() }
        
        _build = { windowModel, appModel in
            
            guard let typedModel = appModel as? Content.Model else {
                fatalError("Invalid appModel type provided for \(Content.self)")
            }
            
            return AnyView(Content(windowModel: windowModel, appModel: typedModel))
        }
    }
    
    func build(windowModel: WindowModel, appModel: any StatefulAppModel) -> AnyView {
        return _build(windowModel, appModel)
    }
}
