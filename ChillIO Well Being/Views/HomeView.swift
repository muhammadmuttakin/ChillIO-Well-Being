import SwiftUI

struct HomeView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var router: AppRouter
    @StateObject private var vm = HomeViewModel()
    @State private var selectedAudio: AudioItem?
    @State private var showChangeAlert = false
    var onSeeMore: (() -> Void)? = nil

    /// Audio filtered by onboarding goal AND stress subtype (if applicable).
    private var audioForGoal: [AudioItem] {
        guard let goal = onboardingVM.selectedGoal,
              let category = goal.audioCategory else { return vm.audioList }

        let byCategory = vm.audioList.filter { $0.category == category }

        // For stress, further filter by subcategory when a stress type is selected
        if goal == .reduceStress,
           let stressType = onboardingVM.selectedStressType {
            return byCategory.filter { $0.subCategory == stressType.audioSubCategory }
        }

        return byCategory
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
                                .font(.custom("HiraMinProN-W6", size: 26))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                    }
                    // Tailored For You section
                    VStack(alignment: .leading, spacing: 16) {
                        // Header with change-category button
                        HStack {
                            Text("Tailored For You")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.chillText)
                            
                            Spacer()
                            
                            Button {
                                showChangeAlert = true
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.chillGreen)
                                    .frame(width: 36, height: 36)
                                    .background(Color.chillGreen.opacity(0.12))
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Audio list — only matching onboarding goal, no filter pills
                        VStack(spacing: 10) {
                            ForEach(audioForGoal) { item in
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
                            .underline()
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
            AudioPlayerView(audio: audio, source: .home)
                .environmentObject(onboardingVM)
        }
        .alert("Feeling Something Different?", isPresented: $showChangeAlert) {
            Button("Yes, let me choose") {
                router.navigate(to: .dailyQuestion)
            }
            Button("No, I'm good", role: .cancel) { }
        } message: {
            Text("Would you like to change your current focus? We'll help you pick what feels right today.")
        }
    }
}

// MARK: - Xcode Previews

/// Helper that creates an OnboardingViewModel with preset goal + optional stress type.
private func previewVM(
    goal: OnboardingGoal? = nil,
    stressType: StressType? = nil
) -> OnboardingViewModel {
    let vm = OnboardingViewModel()
    vm.selectedGoal = goal
    vm.selectedStressType = stressType
    vm.userProfile.name = "Zandi"
    return vm
}

#Preview("Home — Stress: Work") {
    HomeView()
        .environmentObject(previewVM(goal: .reduceStress, stressType: .work))
        .environmentObject(AppRouter())
}

#Preview("Home — Reduce Anxiety") {
    HomeView()
        .environmentObject(previewVM(goal: .reduceAnxiety))
        .environmentObject(AppRouter())
}

#Preview("Home — Better Sleep") {
    HomeView()
        .environmentObject(previewVM(goal: .betterSleep))
        .environmentObject(AppRouter())
}

#Preview("Home — Self-Esteem") {
    HomeView()
        .environmentObject(previewVM(goal: .buildSelfEsteem))
        .environmentObject(AppRouter())
}
