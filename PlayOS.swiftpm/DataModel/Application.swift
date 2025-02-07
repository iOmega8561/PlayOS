//
//  Application.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

enum Application: CaseIterable {
    
    case test
    
    var content: some View {
        switch self {
        case .test: Color.black
        }
    }
    
    var title: String {
        switch self {
        case .test: "Test"
        }
    }
}
