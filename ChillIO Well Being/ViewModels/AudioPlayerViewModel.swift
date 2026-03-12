//
//  AudioPlayerViewModel.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI
import Combine

class AudioPlayerViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 600
    @Published var currentAudio: AudioItem?
    @Published var recommendations: [AudioItem] = Array(AudioItem.sampleList.prefix(3))
    
    private var timer: AnyCancellable?
    
    var progress: Double {
        duration > 0 ? currentTime / duration : 0
    }
    
    var currentTimeString: String { formatTime(currentTime) }
    var durationString: String { formatTime(duration) }
    
    func load(_ audio: AudioItem) {
        currentAudio = audio
        duration = audio.duration
        currentTime = 0
        isPlaying = false
        recommendations = AudioItem.sampleList.filter { $0.id != audio.id }
    }
    
    func togglePlay() {
        isPlaying.toggle()
        if isPlaying {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func skipForward() {
        currentTime = min(currentTime + 15, duration)
    }
    
    func skipBackward() {
        currentTime = max(currentTime - 15, 0)
    }
    
    func seek(to value: Double) {
        currentTime = value * duration
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.currentTime < self.duration {
                    self.currentTime += 1
                } else {
                    self.isPlaying = false
                    self.stopTimer()
                }
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%d:%02d", m, s)
    }
}
