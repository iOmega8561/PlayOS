//
//  WindowModel.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct WindowModel: Identifiable {
    
    let id: UUID = UUID()
    let application: Application
    var stateObject: (any Application.Model)?
    var isMinimized: Bool = false
    
    var isResizable: Bool {
        !application.preferredSize.isFixed
    }
    
    private(set) var isExpanded: Bool = false
    private(set) var offset: CGSize = .zero
    private(set) var currentSize: WindowSize
    
    mutating func resize(to newSize: WindowSize? = nil) {
        guard isResizable else {
            return
        }
        
        currentSize = newSize ?? application.preferredSize
    }
    
    mutating func expand(in container: GeometryProxy? = nil) {
        if let container {
            resize(to: .custom(size: container.size, fixed: false))
            offset = .zero
            isExpanded = true
            
        } else { resize(); isExpanded = false }
    }
    
    mutating func move(computing translation: CGSize, in container: GeometryProxy) {
        
        guard !isExpanded else { return }
        
        let initialOrigin: CGPoint = .init(
            x: container.size.width / 2 - currentSize.width / 2,
            y: container.size.height / 2 - currentSize.height / 2
        )
        let currentOrigin: CGPoint = .init(
            x: initialOrigin.x + offset.width,
            y: initialOrigin.y + offset.height
        )
        let proposedOrigin: CGPoint = .init(
            x: currentOrigin.x + translation.width,
            y: currentOrigin.y + translation.height
        )
        
        let minX: CGFloat = -currentSize.width / 2
        let maxX = container.size.width - currentSize.width / 2
        let minY: CGFloat = 0
        let maxY = container.size.height - currentSize.height / 2
        
        let clampedOriginX = min(max(proposedOrigin.x, minX), maxX)
        let clampedOriginY = min(max(proposedOrigin.y, minY), maxY)
        
        offset = .init(width: clampedOriginX - initialOrigin.x,
                       height: clampedOriginY - initialOrigin.y)
    }
    
    init(application: Application) {
        self.application = application
        self.currentSize = application.preferredSize
    }
}

extension WindowModel: Hashable {
    
    static func == (lhs: WindowModel, rhs: WindowModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
