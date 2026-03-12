//
//  DiscoverView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var vm = DiscoverViewModel()
    @State private var showPlayer = false
    @State private var selectedAudio: AudioItem?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Banner with Hiragino Font
                    ForestBannerView(height: 160, title: "Discover")
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Category filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                CategoryChip(title: "All", isSelected: vm.selectedCategory == nil) {
                                    vm.selectedCategory = nil
                                }
                                ForEach(vm.categories, id: \.self) { cat in
                                    CategoryChip(
                                        title: cat,
                                        iconName: AudioCategory(rawValue: cat)?.iconName,
                                        isSelected: vm.selectedCategory == cat
                                    ) {
                                        vm.selectedCategory = cat
                                    }
                                }
                            }
                        }
                        
                        // Audio list
                        VStack(spacing: 10) {
                            ForEach(vm.filteredAudio) { item in
                                AudioRowCard(item: item) {
                                    selectedAudio = item
                                    showPlayer = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, ChillDesign.horizontalPad)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                }
            }
            .background(Color.chillBG)
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showPlayer) {
            if let audio = selectedAudio {
                AudioPlayerView(audio: audio)
            }
        }
    }
}
