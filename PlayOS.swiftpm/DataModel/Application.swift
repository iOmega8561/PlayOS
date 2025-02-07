//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

enum Application: CaseIterable {
    
    case test
    
    var view: some View {
        switch self {
        case .test: Color.black
        }
    }
    
    var name: String {
        switch self {
        case .test: "Test"
        }
    }
    
    func makeWindow() -> Window {
        return .init(application: self)
    }
}
