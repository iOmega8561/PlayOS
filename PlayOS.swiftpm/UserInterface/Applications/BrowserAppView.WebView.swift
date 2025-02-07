//
//  BrowserAppView.WebView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

import WebKit

extension BrowserAppView {
    
    struct WebView: UIViewRepresentable {
                
        let url: URL?

        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            
            webView.navigationDelegate = context.coordinator
            webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
            
            if let url = url {
                webView.load(URLRequest(url: url))
            }
            
            return webView
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {

            if let url = url, uiView.url != url {
                uiView.load(URLRequest(url: url))
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: WebView
            
            init(_ parent: WebView) {
                self.parent = parent
            }
        }
    }
}
