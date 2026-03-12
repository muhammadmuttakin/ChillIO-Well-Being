//
//  RootView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject var onboardingVM = OnboardingViewModel()
    
    var body: some View {
        Group {
            switch router.currentScreen {
            case .splash:
                SplashView()
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
            case .mainTab:
                MainTabView()
                    .environmentObject(onboardingVM)
            }
        }
        .transition(.opacity)
    }
}
