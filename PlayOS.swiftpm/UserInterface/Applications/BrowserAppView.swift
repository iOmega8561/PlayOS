//
//  BrowserAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct BrowserAppView: View {

    @State private var urlString: String = "https://apple.com"
    @State private var currentURL: URL? = URL(string: "https://apple.com")

    var body: some View {
        VStack(spacing: 0) {

            HStack {

                Button("Homapage", systemImage: "house.fill") {
                    urlString = "https://apple.com"
                    currentURL = URL(string: urlString)
                }
                .labelStyle(.iconOnly)
                .font(.title2)
                .padding(.leading)
                
                TextField("Enter URL", text: $urlString) {
                    if let url = URL(string: urlString) {
                        currentURL = url
                    }
                }
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)
                
                Button("Go") {
                    if let url = URL(string: urlString) {
                        currentURL = url
                    }
                }
                .padding(.trailing)
                .disabled(urlString.isEmpty)
            }
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemBackground))
            
            Divider()
            
            WebView(url: currentURL)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
