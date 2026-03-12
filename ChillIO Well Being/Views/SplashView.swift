import SwiftUI

// MARK: - Splash (logo only, auto-redirect)
struct SplashViewContainer: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var vm: OnboardingViewModel
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 12) {
                LogoView()
                Text("daily audio to ease your mind.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.chillSubtext)
            }
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1
            }
            vm.handleAppOpen()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                let ud = UserDefaultsManager.shared
                if !ud.hasCompletedOnboarding {
                    router.navigate(to: .splashAction)
                } else if ud.shouldShowDailyQuestion {
                    router.navigate(to: .dailyQuestion)
                } else {
                    router.navigate(to: .mainTab)
                }
            }
        }
    }
}

// MARK: - Logo
struct LogoView: View {
    var body: some View {
        Image("AppLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 160)
    }
}
