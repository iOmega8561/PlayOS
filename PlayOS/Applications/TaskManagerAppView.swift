//
//  Copyright (c) 2025 Giuseppe Rocco
//  Licensed under the MIT License. See the LICENSE file for details.
//
//  -----------------------------------------------------------------
//
//  TaskManagerAppView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 10/02/25.
//

import SwiftUI

struct TaskManagerAppView: View {
    
    @EnvironmentObject private var playOSModel: PlayOSModel
    
    private var cpuUsage: Double {
        min(Double(playOSModel.windowModels.count * 4), 100)
    }
    
    private var memoryUsage: Double {
        min(max(Double(playOSModel.windowModels.count * 6), 1), 100)
    }
    
    var body: some View {
        
        VStack {
        
            HStack(spacing: 16) {
                UsageGraphView(
                    displayName: .init(localized: "taskmanager-cputitle"),
                    sfSymbol: "cpu",
                    usage: cpuUsage,
                    color: .blue
                )
                UsageGraphView(
                    displayName: .init(localized: "taskmanager-ramtitle"),
                    sfSymbol: "memorychip",
                    usage: memoryUsage,
                    color: .pink
                )
            }
            
            HStack(alignment: .center, spacing: 16) {
                
                Text("taskmanager-appname")
                    .frame(width: 130, alignment: .leading)
                
                Text("taskmanager-appuuid")
                
                Spacer()
            }
            .padding([.top, .horizontal])
            
            ScrollView {
                
                ForEach(playOSModel.windowModels.reversed()) { windowModel in
                    
                    HStack(alignment: .center, spacing: 16) {
                        
                       Text(windowModel.application.displayName)
                           .fontWeight(.semibold)
                           .lineLimit(1)
                           .frame(width: 130, alignment: .leading)
                        
                        Text(windowModel.id.uuidString)
                            .font(.caption)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button("taskmanager-terminate", systemImage: "xmark") {
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
}

// MARK: - Supporting nested types

private extension TaskManagerAppView {
    
    /// A view that displays a usage graph for task management metrics.
    ///
    /// `UsageGraphView` presents a title with an accompanying SF Symbol icon,
    /// a progress bar representing usage (as a percentage), and a caption displaying the exact usage percentage.
    /// The progress bar animates its fill width in response to changes in the usage value.
    struct UsageGraphView: View {
        
        /// The title text displayed above the usage bar.
        let displayName: String
        
        /// The SF Symbol name used as an icon alongside the title.
        let sfSymbol: String
        
        /// The usage value represented as a percentage (from 0 to 100).
        let usage: Double
        
        /// The color used for the title text and the progress bar.
        let color: Color

        /// The body of the view.
        ///
        /// This view consists of a vertically stacked layout that includes:
        /// - A labeled title with an icon.
        /// - A progress bar that visually indicates the usage percentage.
        /// - A text caption showing the numerical percentage value.
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                
                Label(displayName, systemImage: sfSymbol)
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
}

// MARK: - Application Protocol Conformances

/// Conformance of `TaskManagerAppView` to the `Application.Content` protocol.
extension TaskManagerAppView: Application.Content {
    
    /// A dummy view model that doesn't actually hold any state
    /// Required in order to achieve conformation to the `Application.Content` protocol.
    final class Model: Application.Model { }
    
    /// Initializes the Task Manager view with the provided model.
    /// Since the view does not use any StateObject this init does effectively nothing
    ///
    /// - Parameter appModel: An instance of `TaskManagerAppView.Model` that holds the state for the view.
    init(appModel: Model) { }
}
