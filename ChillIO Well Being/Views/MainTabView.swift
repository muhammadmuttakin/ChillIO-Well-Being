import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var router: AppRouter
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(onSeeMore: { selectedTab = 1 })
                .environmentObject(onboardingVM)
                .environmentObject(router)
                .tabItem {
                    Label("Audio", systemImage: "waveform")
                }
                .tag(0)
            
            DiscoverView()
                .environmentObject(onboardingVM)
                .tabItem {
                    Label("Discover", systemImage: "safari")
                }
                .tag(1)
            
            ProfileView()
                .environmentObject(onboardingVM)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .accentColor(.chillGreen)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(Color.chillGreen.opacity(0.80))
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

