//
//  StatefulApp.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 09/02/25.
//

import SwiftUI

protocol StatefulAppModel: ObservableObject {
    
    init()
}


protocol StatefulAppView: View {
    
    associatedtype Model: StatefulAppModel
    
    init(windowModel: WindowModel, appModel: Model)
}
