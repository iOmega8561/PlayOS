//
//  TaskManagerAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 10/02/25.
//

import SwiftUI

struct TaskManagerAppView: Application.Content {
    
    final class Model: Application.Model { init() {} }
    
    private struct UsageGraphView: View {
        let title: String
        let sfSymbol: String
        let usage: Double
        let color: Color

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {

                Label(title, systemImage: sfSymbol)
                    .font(.headline)
                    .foregroundColor(color)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .frame(width: geometry.size.width * CGFloat(usage / 100))
                            .animation(.easeInOut, value: usage)
                    }
                }
                .frame(height: 20)
                
                HStack {
                    Spacer()
                    Text("\(Int(usage))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    @EnvironmentObject var playOSModel: PlayOSModel
    
    var cpuUsage: Double {
        min(Double(playOSModel.windowModels.count * 4), 100)
    }
    
    var memoryUsage: Double {
        min(max(Double(playOSModel.windowModels.count * 6), 1), 100)
    }
    
    var body: some View {
        
        VStack {
        
            HStack(spacing: 16) {
                UsageGraphView(
                    title: "CPU Usage",
                    sfSymbol: "cpu",
                    usage: cpuUsage,
                    color: .blue
                )
                UsageGraphView(
                    title: "Memory Usage",
                    sfSymbol: "memorychip",
                    usage: memoryUsage,
                    color: .pink
                )
            }
            
            HStack(alignment: .center, spacing: 16) {
                
                Text("Name")
                    .frame(width: 130, alignment: .leading)
                
                Text("Identifier")
                
                Spacer()
            }
            .padding([.top, .horizontal])
            
            ScrollView {
                
                ForEach(playOSModel.windowModels) { windowModel in
                    
                    HStack(alignment: .center, spacing: 16) {
                        
                       Text(windowModel.application.title)
                           .fontWeight(.semibold)
                           .lineLimit(1)
                           .frame(width: 130, alignment: .leading)
                        
                        Text(windowModel.id.uuidString)
                            .font(.caption)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button("Terminate", systemImage: "xmark") {
                            playOSModel.destroyWindow(id: windowModel.id)
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
    }
    
    init(appModel: Model) {}
}
