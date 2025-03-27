//
//  ExploreAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

import WebKit

struct ExploreAppView: View {
    
    @StateObject private var appModel: Model
    
    var body: some View {
        
        VStack(spacing: 0) {
          
            HStack {
                Button("explore-homepage", systemImage: "house.fill") {
                    appModel.currentApp = .homePage
                }
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .padding(.leading)
                
                Spacer()
                
                Picker(selection: $appModel.currentApp) {
                    ForEach(WebApp.allCases, id: \.self) { webApp in
                        Text(webApp.displayName)
                            .tag(webApp)
                    }
                } label: {}
            }
            .padding(.vertical, 4)
            
            Divider()
            
            WebView(appModel: appModel)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// MARK: - Supporting nested types

extension ExploreAppView {
    
    /// A SwiftUI wrapper for WKWebView that loads web content based on the model's state.
    ///
    /// This view conforms to `UIViewRepresentable` to integrate a UIKit `WKWebView` into SwiftUI.
    private struct WebView: UIViewRepresentable {
        
        /// The observed model containing the current app state.
        @ObservedObject var appModel: Model

        /// Creates the `WKWebView` instance to be used in SwiftUI.
        ///
        /// - Parameter context: The context provided by SwiftUI.
        /// - Returns: A configured `WKWebView` instance.
        func makeUIView(context: Context) -> WKWebView {
            let webView: WKWebView = appModel.webView ?? .init()
            
            // If no URL is loaded yet and a valid URL is available from the model, load it.
            if webView.url == nil, let url = appModel.currentURL {
                webView.load(URLRequest(url: url))
            }
            return webView
        }

        /// Updates the `WKWebView` when the model's state changes.
        ///
        /// If the current URL in the model differs from the one loaded in the `WKWebView`,
        /// this method loads the new URL.
        ///
        /// - Parameters:
        ///   - uiView: The existing `WKWebView` instance.
        ///   - context: The context provided by SwiftUI.
        func updateUIView(_ uiView: WKWebView, context: Context) {
            if let url = appModel.currentURL, uiView.url != url {
                uiView.load(URLRequest(url: url))
            }
        }

        /// Creates the coordinator object for the view.
        ///
        /// Currently, this returns a simple `NSObject` instance.
        ///
        /// - Returns: A new coordinator object.
        func makeCoordinator() -> NSObject { .init() }
    }
    
    /// Supported web applications for the Explore view.
    enum WebApp: String, CaseIterable {
        
        /// The home page of the Explore web application.
        case homePage = "ExploreHome"
        /// A web-based snake game.
        case snakeGame = "SnakeGame"
        /// A tic-tac-toe game.
        case ticTacToe = "TicTacToe"
        /// A coding challenge interface.
        case codingChallenge = "CodingChallenge"
        /// A computer quiz interface.
        case computerQuiz = "ComputerQuiz"
        
        /// A localized display name for the web application.
        var displayName: String {
            switch self {
            case .homePage: .init(localized: "webapp-homepage")
            case .snakeGame: .init(localized: "webapp-snakegame")
            case .ticTacToe: .init(localized: "webapp-tictactoe")
            case .codingChallenge: .init(localized: "webapp-learncoding")
            case .computerQuiz: .init(localized: "webapp-computerquiz")
            }
        }
    }
    
    /// The model that manages the state for the Explore view.
    ///
    /// This model is responsible for tracking the currently selected web application page
    /// and providing the corresponding URL from the app bundle. It also holds a reference to a
    /// `WKWebView` instance for displaying web content.
    final class Model: ObservableObject {
        
        /// The current web application page.
        ///
        /// This property determines which HTML resource is loaded from the bundle.
        @Published fileprivate var currentApp: WebApp = .homePage
        
        /// The WKWebView instance used to display web content.
        ///
        /// This view may be set externally. If not set, a new instance will be created.
        fileprivate var webView: WKWebView?
        
        /// A computed property that returns the URL for the current web page.
        ///
        /// It looks up an HTML resource in the main bundle using the raw value of `currentApp`.
        fileprivate var currentURL: URL? {
            Bundle.main.url(
                forResource: currentApp.rawValue,
                withExtension: "html"
            )
        }
        
        /// A convenience initializer that allows to set currentApp directly before
        /// initializing the view.
        /// 
        /// - Parameter currentApp: A case from the `ExploreAppView.WebApp` enum
        convenience init(currentApp: WebApp) {
            self.init()
            self.currentApp = currentApp
        }
    }
}

// MARK: - Application Protocol Conformances

/// Conformance of `ExploreAppView.Model` to the `Application.Model` protocol.
extension ExploreAppView.Model: Application.Model { }

/// Conformance of `ExploreAppView` to the `Application.Content` protocol.
extension ExploreAppView: Application.Content {
    
    /// Initializes the Explore view with the provided model.
    ///
    /// - Parameter appModel: An instance of `ExploreAppView.Model` containing the view's state.
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}
