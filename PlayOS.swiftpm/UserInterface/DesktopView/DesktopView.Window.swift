//
//  DesktopView.Window.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

/*struct AppWrapper: View {
    
    @Binding private var windowModel: WindowModel
    
    private let stateObject: AnyObject
    
    private let contentType: any StatefulAppView
    
    var body: some View {
        
        AnyView(contentType.init(
            windowModel: windowModel,
            appModel: stateObject as! App.Model
        ))
        
    }
    
    init<App: StatefulAppView>(windowModel: Binding<WindowModel>, contentType: App.Type) {
        
        _windowModel = windowModel
        
        self.stateObject = NSObject()
        
        self.contentType = contentType
    }
}*/

extension DesktopView {
    
    struct Window: View {
        
        let desktopGeometry: GeometryProxy
        
        @Binding var windowModel: WindowModel
        
        @EnvironmentObject private var appModel: AppModel
        
        @State private var dragOffset: CGSize = .zero
        
        var body: some View {
   
            VStack(spacing: 0) {
                
                HStack(alignment: .bottom) {
                    
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            appModel.windowModels.removeAll(
                                where: { $0.id == windowModel.id }
                            )
                        } label: { Circle().fill(Color.red) }
                            .frame(width: 25, height: 25)
                        
                        Button {
                            windowModel.isMinimized = true
                        } label: { Circle().fill(Color.yellow) }
                            .frame(width: 25, height: 25)
                        
                        if windowModel.isResizable {
                            
                            Button {
                                if windowModel.isExpanded {
                                    windowModel.expand()
                                    
                                } else { windowModel.expand(in: desktopGeometry) }
                            } label: {
                                Circle()
                                    .fill(.green.opacity(windowModel.isExpanded ? 0.5:1))
                            }
                            .frame(width: 25, height: 25)
                        }
                        
                        Spacer()
                    }
                    .buttonStyle(.plain)
                    .frame(width: 100)
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text(windowModel.application.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Spacer().frame(width: 100)
                }
                .contentShape(Rectangle())
                .frame(width: windowModel.currentSize.width, height: 40)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            windowModel.move(
                                computing: gesture.translation,
                                in: desktopGeometry
                            )
                        }
                )
                
                ApplicationContainer(windowModel: $windowModel)
                    .frame(width: windowModel.currentSize.width,
                           height: windowModel.currentSize.height - 40)
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3.0)
        }
    }
}
