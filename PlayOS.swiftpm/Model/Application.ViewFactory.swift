//
//  Application.ViewFactory.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 09/02/25.
//

import SwiftUI

extension Application {
    
    // MARK: - Supporting Application Protocols
    
    /// A protocol that represents the model for an application.
    ///
    /// Conforming types must be observable and provide a default initializer.
    protocol Model: ObservableObject {
        
        /// Initializes a new instance of the model.
        init()
    }
    
    /// A protocol that represents the content view for an application.
    ///
    /// Conforming types must be a SwiftUI `View` and be initializable with an associated app model.
    protocol Content: View {
        
        /// The model type associated with the content view.
        associatedtype AppModel: Model
        
        /// Initializes a new instance of the content view with the provided app model.
        ///
        /// - Parameter appModel: The model instance to bind to the view.
        init(appModel: AppModel)
    }
    
    // MARK: - Factory
    
    /// A factory for constructing the SwiftUI view and model for an application.
    ///
    /// The `ViewFactory` is responsible for creating a model instance and building the corresponding view for a given application.
    /// This approach is necessary because each application stores its view type (which conforms to `Application.Content`) in its metadata.
    /// Instantiating these views programmatically would normally require the use of generics, but to avoid propagating generic types through
    /// our application infrastructure, we use type erasure (via `AnyView`) along with this factory pattern.
    ///
    /// By encapsulating the view and model creation logic in `ViewFactory`, adding a new application requires only minimal changes:
    /// simply storing the new view type in the application's metadata. The factory then handles the rest, ensuring that the correct
    /// model and view are created and reducing the need for repetitive boilerplate code.
    @MainActor struct ViewFactory {
        
        /// Creates a view factory for the specified application.
        ///
        /// - Parameter application: The application for which to create the view factory.
        /// - Returns: An instance of `ViewFactory` configured for the application.
        static func make(for application: Application) -> Self {
            return .init(application.contentType)
        }
        
        /// A closure that creates a new instance of the application's model.
        let makeModel: () -> any Model
        
        /// A closure that builds a type-erased SwiftUI view (`AnyView`) given an app model.
        private let _build: (any Model) -> AnyView
        
        /// Builds the SwiftUI view for the application using the provided app model.
        ///
        /// - Parameter appModel: The model instance for the application.
        /// - Returns: An `AnyView` representing the constructed application view.
        func build(appModel: any Model) -> AnyView {
            return _build(appModel)
        }
        
        /// Private initializer that configures the factory for a specific content view type.
        ///
        /// This initializer sets up the closures to create the model and build the view
        /// based on the provided content type.
        ///
        /// - Parameter contentType: The content view type conforming to `Application.Content`.
        private init<Content: Application.Content>(_ contentType: Content.Type) {
            self.makeModel = { Content.AppModel() }
            
            _build = { appModel in
                guard let typedModel = appModel as? Content.AppModel else {
                    fatalError("Invalid appModel type provided for \(Content.self)")
                }
                return AnyView(Content(appModel: typedModel))
            }
        }
    }
}
