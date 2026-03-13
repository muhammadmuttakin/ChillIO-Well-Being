//
//  AudioPlayerViewModel.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI
import Combine
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 600
    @Published var currentAudio: AudioItem?
    @Published var recommendations: [AudioItem] = Array(AudioItem.allAudio.prefix(3))

    private var timer: AnyCancellable?
    private var player: AVPlayer?
    private var timeObserver: Any?
    private let timeObserverInterval = CMTime(seconds: 0.5, preferredTimescale: 600)

    var progress: Double {
        guard duration > 0 else { return 0 }
        return min(currentTime / duration, 1)
    }

    var currentTimeString: String { formatTime(currentTime) }
    var durationString: String { formatTime(duration) }

    func load(_ audio: AudioItem) {
        stopPlayback()
        currentAudio = audio
        currentTime = 0
        isPlaying = false
        recommendations = AudioItem.allAudio.filter { $0.id != audio.id }

        if let path = audio.bundlePath, let url = AudioItem.urlInBundle(for: path) {
            configureAudioSession()
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            duration = audio.duration > 0 ? audio.duration : 600

            Task { @MainActor in
                guard let loadedDuration = try? await playerItem.asset.load(.duration) else { return }
                let dur = CMTimeGetSeconds(loadedDuration)
                guard dur.isFinite, dur > 0 else { return }
                self.duration = dur
            }

            addTimeObserver()
            objectWillChange.send()
        } else {
            duration = audio.duration > 0 ? audio.duration : 600
        }
    }

    func togglePlay() {
        guard let p = player else {
            isPlaying = false
            return
        }
        if isPlaying {
            p.pause()
            stopTimer()
        } else {
            p.play()
            startTimer()
        }
        isPlaying.toggle()
    }

    func skipForward() {
        guard player != nil else { return }
        let newTime = min(currentTime + 15, duration)
        seekTo(seconds: newTime)
    }

    func skipBackward() {
        guard player != nil else { return }
        let newTime = max(currentTime - 15, 0)
        seekTo(seconds: newTime)
    }

    func seek(to value: Double) {
        let seconds = value * duration
        seekTo(seconds: seconds)
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Ignore; playback may still work
        }
    }

    private func addTimeObserver() {
        removeTimeObserver()
        guard let p = player else { return }
        timeObserver = p.addPeriodicTimeObserver(forInterval: timeObserverInterval, queue: .main) { [weak self] time in
            guard let self else { return }
            let sec = CMTimeGetSeconds(time)
            guard sec.isFinite else { return }
            self.currentTime = sec
            if sec >= self.duration - 0.5 {
                self.isPlaying = false
                self.stopTimer()
                self.player?.pause()
            }
        }
    }

    private func removeTimeObserver() {
        guard let p = player, let obs = timeObserver else { return }
        p.removeTimeObserver(obs)
        timeObserver = nil
    }

    private func seekTo(seconds: Double) {
        guard let p = player else { return }
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        p.seek(to: time) { [weak self] _ in
            DispatchQueue.main.async {
                self?.currentTime = seconds
            }
        }
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if let p = self.player {
                    self.currentTime = CMTimeGetSeconds(p.currentTime())
                }
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func stopPlayback() {
        stopTimer()
        removeTimeObserver()
        player?.pause()
        player = nil
    }

    private func formatTime(_ seconds: Double) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%d:%02d", m, s)
    }

    deinit {
        stopPlayback()
    }
}
