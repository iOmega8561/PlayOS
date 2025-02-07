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
}
