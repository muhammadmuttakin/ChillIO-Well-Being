//
//  HomeView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @StateObject private var vm = HomeViewModel()
    @State private var showPlayer = false
    @State private var selectedAudio: AudioItem?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Forest banner with greeting
                    ZStack(alignment: .bottomLeading) {
                        ForestBannerView(height: 180)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(onboardingVM.greetingText())
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                            Text("Hi, \(onboardingVM.userName)")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                    }
                    
                    // Tailored For You section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tailored For You")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.chillText)
                        
                        // Category chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                CategoryChip(title: "All", isSelected: vm.selectedCategory == nil) {
                                    vm.selectedCategory = nil
                                }
                                ForEach(AudioCategory.allCases, id: \.self) { cat in
                                    CategoryChip(title: cat.rawValue, isSelected: vm.selectedCategory == cat) {
                                        vm.selectedCategory = cat
                                    }
                                }
                            }
                        }
                        
                        // Audio list
                        VStack(spacing: 10) {
                            ForEach(vm.filteredAudio.prefix(4)) { item in
                                AudioRowCard(item: item) {
                                    selectedAudio = item
                                    showPlayer = true
                                }
                            }
                        }
                        
                        // See More
                        HStack {
                            Spacer()
                            Button("See More") {}
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.chillGreen)
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, ChillDesign.horizontalPad)
                    .padding(.top, 24)
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
