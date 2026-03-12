//
//  AudioPlayerView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct AudioPlayerView: View {
    let audio: AudioItem
    @StateObject private var vm = AudioPlayerViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Forest background
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.18, blue: 0.13),
                    Color(red: 0.15, green: 0.35, blue: 0.27),
                    Color(red: 0.22, green: 0.48, blue: 0.36),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Tree silhouettes background
            VStack {
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0..<16, id: \.self) { i in
                        TreeSilhouette(height: CGFloat.random(in: 80...160))
                    }
                }
                .opacity(0.25)
                .frame(height: 180)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Back button
                    HStack {
                        Button {
                            vm.togglePlay()
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(.white.opacity(0.15))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Title
                    VStack(spacing: 8) {
                        Text(audio.title)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 32)
                    
                    // Waveform
                    WaveformView(isPlaying: vm.isPlaying)
                        .frame(height: 60)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    
                    // Progress slider
                    VStack(spacing: 6) {
                        Slider(value: Binding(
                            get: { vm.progress },
                            set: { vm.seek(to: $0) }
                        ))
                        .accentColor(.white)
                        .padding(.horizontal, 24)
                        
                        HStack {
                            Text(vm.currentTimeString)
                            Spacer()
                            Text(vm.durationString)
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.65))
                        .padding(.horizontal, 28)
                    }
                    .padding(.bottom, 28)
                    
                    // Controls
                    HStack(spacing: 52) {
                        Button { vm.skipBackward() } label: {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        
                        Button { vm.togglePlay() } label: {
                            Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color(red: 0.06, green: 0.18, blue: 0.13))
                                .frame(width: 64, height: 64)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
                        }
                        
                        Button { vm.skipForward() } label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 40)
                    
                    // Recommendations
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommendations")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 10) {
                            ForEach(vm.recommendations.prefix(3)) { item in
                                AudioRowCard(item: item, isDark: true) {
                                    vm.load(item)
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear { vm.load(audio) }
    }
}
