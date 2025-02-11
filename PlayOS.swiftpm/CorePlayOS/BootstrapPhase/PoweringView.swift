//
//  PoweringView.swift
//  PlayOS
//
//  Created by Giuseppe Rocco on 06/02/25.
//

import SwiftUI

import AVKit

struct PoweringView: View {
        
    @EnvironmentObject private var playOSModel: PlayOSModel
    
    @State private var progress: Double = 0.0
    
    private let player: AVPlayer? = {
        guard let url = Bundle.main.url(
            forResource: "fake_boot",
            withExtension: "mp4"
        ) else { return nil }
        
        return AVPlayer(url: url)
    }()
    
    let isPoweringOff: Bool
    
    var body: some View {
        
        GeometryReader { proxy in
        
           VideoPlayer(player: player)
               .blur(radius: 20.0, opaque: true)
               .onAppear { player?.play() }
               .allowsHitTesting(false)
               .disabled(true)
           
           if isPoweringOff {
               Color.red
                   .blendMode(.multiply)
                   .opacity(0.9)
           }
            
            VStack {
                HStack {
                    Text(verbatim: "PlayOS")
                        .fontWeight(.bold)
                        .fontWidth(.expanded)
                    
                    Text(isPoweringOff ? "powering-down":"powering-up")
                }
                .font(.largeTitle)
                .foregroundStyle(.white)
                
                if !isPoweringOff {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                                .frame(width: proxy.size.width * 0.4 * progress)
                        }
                        .frame(width: proxy.size.width * 0.4, height: 20)
                        .padding()
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .task(priority: .userInitiated) { @MainActor in
            
            while self.progress < 1.0 {
                withAnimation(.default) {
                    progress = min((0.1 + progress * 1.2), 1.0)
                }
                try? await Task.sleep(for: .seconds(1))
            }
            
            try? await Task.sleep(for: .seconds(1))
            playOSModel.setPhase(isPoweringOff ? .stopped:.login)
        }
    }
}
