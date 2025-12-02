//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
//
//  PaintAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct PaintAppView: View {

    @StateObject private var appModel: Model
    
    @State private var currentStroke = Stroke(points: [], color: .black)
    
    private let palette: [Color] = [.black, .red, .green, .blue, .yellow]
    
    var body: some View {
        VStack(spacing: 0) {

            HStack {
                
                Button { appModel.strokes.removeAll() } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                }
            
                Spacer()
                
                ForEach(palette, id: \.self) { color in
                    
                    Button { appModel.selectedColor = color } label: {
                        Circle()
                            .fill(color)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .stroke(Color.accentColor, lineWidth: color == appModel.selectedColor ? 4 : 0)
                            )
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                Spacer().frame(width: 44, height: 44)
            }
            .padding()
            
            Divider()
            
            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    ForEach(appModel.strokes) { stroke in
                        Path { path in
                            guard let firstPoint = stroke.points.first else { return }
                            path.move(to: firstPoint)
                            for point in stroke.points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(stroke.color, lineWidth: 3)
                    }
                    
                    Path { path in
                        guard let firstPoint = currentStroke.points.first else { return }
                        path.move(to: firstPoint)
                        for point in currentStroke.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(appModel.selectedColor, lineWidth: 3)
                }
                .gesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged { value in
                            let newPoint = value.location
                            if newPoint.x >= 0 && newPoint.x <= geometry.size.width &&
                               newPoint.y >= 0 && newPoint.y <= geometry.size.height {
                                currentStroke.points.append(newPoint)
                                currentStroke.color = appModel.selectedColor
                            }
                        }
                        .onEnded { value in
                            appModel.strokes.append(currentStroke)
                            currentStroke = Stroke(points: [], color: appModel.selectedColor)
                        }
                )
            }
            .background(Color.gray.opacity(0.2))
        }
    }
    
}

// MARK: - Supporting nested types

extension PaintAppView {
    
    /// A struct representing a single drawn stroke on the canvas.
    ///
    /// This struct conforms to `Identifiable` to allow SwiftUI to differentiate between
    /// individual strokes. It stores the unique identifier, the points that make up the stroke,
    /// and the color used for drawing.
    fileprivate struct Stroke: Identifiable {
        /// A unique identifier for the stroke.
        let id = UUID()
        
        /// An array of `CGPoint` values that form the stroke.
        var points: [CGPoint] = []
        
        /// The color of the stroke.
        var color: Color = .black
    }
    
    /// The view model for the Paint application.
    ///
    /// This model manages the state of the painting interface, including the strokes drawn on the canvas
    /// and the currently selected drawing color. It conforms to `ObservableObject` so that changes
    /// are published to the SwiftUI view.
    final class Model: ObservableObject {
        
        /// An array of strokes drawn on the canvas.
        ///
        /// This property is marked with `@Published` so that the view updates when new strokes are added
        /// or existing strokes are modified.
        @Published fileprivate var strokes: [Stroke] = []
        
        /// The currently selected color for drawing.
        ///
        /// Changes to this property are published to update the UI accordingly.
        @Published fileprivate var selectedColor: Color = .black
    }
}

// MARK: - Application Protocol Conformances

/// Conformance of `PaintAppView.Model` to the `Application.Model` protocol.
extension PaintAppView.Model: Application.Model {}

/// Conformance of `PaintAppView` to the `Application.Content` protocol.
extension PaintAppView: Application.Content {
    
    /// Initializes the Paint view with the provided model.
    ///
    /// - Parameter appModel: An instance of `PaintAppView.Model` that holds the state for the view.
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}

