import SwiftUI

struct AudioPlayerView: View {
    let audio: AudioItem
    var source: AudioPlayerSource = .discover
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @StateObject private var vm = AudioPlayerViewModel()
    @Environment(\.dismiss) var dismiss

    /// The category of the currently playing audio (reactive — updates when recommendation is tapped).
    private var currentCategory: AudioCategory {
        vm.currentAudio?.category ?? audio.category
    }

   /// Goal label derived from the currently playing audio's category.
   /// E.g. anxious → "Reduce Anxiety", sleep → "Better Sleep".
    private var goalTitle: String {
        let matched = OnboardingGoal.allCases.first { $0.audioCategory == currentCategory }
        return matched?.rawValue ?? currentCategory.rawValue
    }

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("AudioPlayerBg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
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

                    // Background title from onboarding goal
                    VStack(spacing: 6) {
                        Text(goalTitle)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                        Text(vm.currentAudio?.title.localizedCapitalized ?? audio.title.localizedCapitalized)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)
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
                    
                    // Controls — gobackward.15 / play / goforward.15
                    HStack(spacing: 52) {
                        Button { vm.skipBackward() } label: {
                            Image(systemName: "gobackward.15")
                                .font(.system(size: 28))
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
                            Image(systemName: "goforward.15")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 40)
                    
                    // Recommendations
                    if !vm.recommendations.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recommendations")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 10) {
                                ForEach(vm.recommendations) { item in
                                    AudioRowCard(item: item, isDark: true) {
                                        vm.load(item, source: source)
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear { vm.load(audio, source: source) }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    // 1. Siapkan Mock Data untuk AudioItem
    // Sesuaikan parameter init dengan model AudioItem milik Anda
    let mockAudio = AudioItem(
        id: "1",
        type: "stress",
        title: "Deep Forest Relaxation",
        description: "A soothing audio track for deep forest relaxation.",
        duration: 300,
        category: .stress, // Sesuaikan dengan enum Category Anda
    )
    
    // 2. Siapkan Mock ViewModel untuk EnvironmentObject
    let mockOnboarding = OnboardingViewModel()
    // Opsional: Atur state tertentu jika ingin melihat tampilan yang berbeda
    // mockOnboarding.selectedGoal = .reduceStress

    AudioPlayerView(audio: mockAudio)
        .environmentObject(mockOnboarding)
}
