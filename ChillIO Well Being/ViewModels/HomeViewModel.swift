//
//  HomeViewModel.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var selectedCategory: AudioCategory? = nil
    @Published var audioList: [AudioItem] = AudioItem.sampleList
    @Published var selectedAudio: AudioItem? = nil
    @Published var showAudioPlayer: Bool = false
    
    var filteredAudio: [AudioItem] {
        guard let cat = selectedCategory else { return audioList }
        return audioList.filter { $0.category == cat }
    }
    
    var categories: [String] { ["Stress", "Anxious", "Sleep", "Focus"] }
    
    func selectAudio(_ item: AudioItem) {
        selectedAudio = item
        showAudioPlayer = true
    }
}
