//
//  PaintAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 07/02/25.
//

import SwiftUI

struct PaintAppView: Application.Content {
    
    fileprivate struct Stroke: Identifiable {
        let id = UUID()
        var points: [CGPoint] = []
        var color: Color = .black
    }
    
    final class Model: Application.Model {
        
        @Published fileprivate var strokes: [Stroke] = []
        
        @Published fileprivate var selectedColor: Color = .black
        
        init() {}
    }

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
    
    init(appModel: Model) {
        _appModel = .init(wrappedValue: appModel)
    }
}
