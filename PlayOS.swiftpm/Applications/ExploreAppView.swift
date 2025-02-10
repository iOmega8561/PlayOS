//
//  ExploreAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

import WebKit

struct ExploreAppView: Application.Content {

    final class Model: Application.Model {
        
        @Published var currentApp: Application.WebApp = .homePage
        
        var webView: WKWebView?
        
        var currentURL: URL? {
            Bundle.main.url(
                forResource: currentApp.rawValue,
                withExtension: "html"
            )
        }
        
        init() { }
    }
    
    private struct WebView: UIViewRepresentable {
        
        @ObservedObject var appModel: Model

        func makeUIView(context: Context) -> WKWebView {
            let webView: WKWebView = appModel.webView ?? .init()
            
            if webView.url == nil, let url = appModel.currentURL {
                webView.load(URLRequest(url: url))
            }
            return webView
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {
            if let url = appModel.currentURL, uiView.url != url {
                uiView.load(URLRequest(url: url))
            }
        }

        func makeCoordinator() -> NSObject { .init() }
    }
    
    @StateObject private var appModel: Model

    var body: some View {
        
        VStack(spacing: 0) {
            HStack {

                Button("Homepage", systemImage: "house.fill") {
                    appModel.currentApp = .homePage
                }
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .padding(.leading)
                
                Spacer()
            
                Picker("Applications", systemImage: "cursorarrow.rays", selection: $appModel.currentApp) {
                    
                    ForEach(Application.WebApp.allCases, id: \.self) { webApp in
                        Text(webApp.displayName)
                            .tag(webApp)
                    }
                }
            }
            .padding(.vertical, 4)
            
            Divider()
            
            WebView(appModel: appModel)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}
