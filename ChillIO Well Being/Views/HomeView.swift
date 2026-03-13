import SwiftUI

struct HomeView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @StateObject private var vm = HomeViewModel()
    @State private var selectedAudio: AudioItem?
    var onSeeMore: (() -> Void)? = nil

    /// Audio filtered by onboarding goal only; if no goal, show all
    private var audioForGoal: [AudioItem] {
        guard let category = onboardingVM.selectedGoal?.audioCategory else { return vm.audioList }
        return vm.audioList.filter { $0.category == category }
    }

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
                        
                        // Audio list — only matching onboarding goal, no filter pills
                        VStack(spacing: 10) {
                            ForEach(audioForGoal.prefix(4)) { item in
                                AudioRowCard(item: item) {
                                    selectedAudio = item
                                }
                            }
                        }
                        
                        // See More → navigate to Discover tab
                        HStack {
                            Spacer()
                            Button("See More") {
                                onSeeMore?()
                            }
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
        .onAppear { vm.refresh() }
        .fullScreenCover(item: $selectedAudio) { audio in
            AudioPlayerView(audio: audio)
                .environmentObject(onboardingVM)
        }
    }
}
