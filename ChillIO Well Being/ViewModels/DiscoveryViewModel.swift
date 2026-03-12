//
//  DiscoveryViewModel.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI
import Combine

class DiscoverViewModel: ObservableObject {
    @Published var selectedCategory: String? = nil
    @Published var allAudio: [AudioItem] = AudioItem.sampleList
    
    var categories: [String] { AudioCategory.allCases.map { $0.rawValue } }
    
    var filteredAudio: [AudioItem] {
        guard let cat = selectedCategory,
              let category = AudioCategory(rawValue: cat) else {
            return allAudio
        }
        return allAudio.filter { $0.category == category }
    }
}
