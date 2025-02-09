//
//  PaintAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct PaintAppView: Application.Content {
    
    final class Model: Application.Model {
        init() {}
    }
    
    init(windowModel: WindowModel, appModel: Model) {
        
    }
    
    private struct Stroke: Identifiable {
        let id = UUID()
        var points: [CGPoint] = []
        var color: Color = .black
    }
    
    @State private var strokes: [Stroke] = []

    @State private var currentStroke = Stroke(points: [], color: .black)

    @State private var selectedColor: Color = .black
    
    private let palette: [Color] = [.black, .red, .green, .blue, .yellow]
    
    var body: some View {
        VStack(spacing: 0) {

            HStack {
                ForEach(palette, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(Color.accentColor, lineWidth: color == selectedColor ? 4 : 0)
                        )
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            
            Divider()
            
            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    ForEach(strokes) { stroke in
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
                    .stroke(selectedColor, lineWidth: 3)
                }
                .gesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged { value in
                            let newPoint = value.location
                            if newPoint.x >= 0 && newPoint.x <= geometry.size.width &&
                               newPoint.y >= 0 && newPoint.y <= geometry.size.height {
                                currentStroke.points.append(newPoint)
                                currentStroke.color = selectedColor
                            }
                        }
                        .onEnded { value in
                            strokes.append(currentStroke)
                            currentStroke = Stroke(points: [], color: selectedColor)
                        }
                )
            }
            .background(Color.gray.opacity(0.2))
        }
    }
}
