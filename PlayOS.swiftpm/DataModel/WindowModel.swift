//
//  WindowModel.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct WindowModel: Identifiable, Hashable {
    
    let id: UUID = UUID()
    let application: Application
    var offset: CGSize = .zero
    var isMinimized: Bool = false
    var isExpanded: Bool = false
    
    var isResizable: Bool {
        !application.preferredSize.isFixed
    }
    
    private(set) var currentSize: WindowSize
    
    mutating func resize(to newSize: WindowSize? = nil) {
        guard isResizable else { return }
        
        currentSize = newSize ?? application.preferredSize
    }
    
    init(application: Application) {
        self.application = application
        self.currentSize = application.preferredSize
    }
}
