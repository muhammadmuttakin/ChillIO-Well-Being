import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject var onboardingVM = OnboardingViewModel()

    var body: some View {
        Group {
            switch router.currentScreen {
            case .splash:
                SplashViewContainer()
                    .environmentObject(onboardingVM)
            case .splashAction:
                SplashActionView()
            case .inputName:
                InputNameView()
                    .environmentObject(onboardingVM)
            case .personalizedQuestions:
                PersonalizedQuestionsView()
                    .environmentObject(onboardingVM)
            case .stressType:
                StressTypeView()
                    .environmentObject(onboardingVM)
            case .dailyQuestion:
                DailyQuestionView()
                    .environmentObject(onboardingVM)
            case .dailyStressType:
                DailyStressTypeView()
                    .environmentObject(onboardingVM)
            case .streak:
                StreakScreenView()
                    .environmentObject(onboardingVM)
            case .mainTab:
                MainTabView()
                    .environmentObject(onboardingVM)
            }
        }
        .transition(.opacity)
    }
}
