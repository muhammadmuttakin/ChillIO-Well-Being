import SwiftUI
import Combine

enum AppScreen {
    case splash
    case splashAction
    case inputName
    case personalizedQuestions
    case stressType
    case dailyQuestion
    case dailyStressType   // stress type khusus dari daily question
    case mainTab
}

class AppRouter: ObservableObject {
    @Published var currentScreen: AppScreen = .splash

    func navigate(to screen: AppScreen) {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentScreen = screen
        }
    }

    func goBack() {
        switch currentScreen {
        case .splashAction:          navigate(to: .splash)
        case .inputName:             navigate(to: .splashAction)
        case .personalizedQuestions: navigate(to: .inputName)
        case .stressType:            navigate(to: .personalizedQuestions)
        case .dailyStressType:       navigate(to: .dailyQuestion)
        default: break
        }
    }
}
