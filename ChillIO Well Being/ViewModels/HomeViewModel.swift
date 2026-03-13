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
    @Published var audioList: [AudioItem] = []

    init() {
        audioList = AudioItem.allAudio
    }

    @Published var selectedAudio: AudioItem? = nil
    @Published var showAudioPlayer: Bool = false

    /// Reload list from bundle (call on appear so real files are shown).
    func refresh() {
        audioList = AudioItem.allAudio
    }

    var filteredAudio: [AudioItem] {
        guard let cat = selectedCategory else { return audioList }
        return audioList.filter { $0.category == cat }
    }
    
    var categories: [String] { AudioCategory.allCases.map { $0.rawValue } }
    
    func selectAudio(_ item: AudioItem) {
        selectedAudio = item
        showAudioPlayer = true
    }
}
