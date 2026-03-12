//
//  AppRouter.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI
import Combine
enum AppScreen {
    case splash
    case splashAction
    case inputName
    case personalizedQuestions
    case stressType
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
        case .splashAction:   navigate(to: .splash)
        case .inputName:      navigate(to: .splashAction)
        case .personalizedQuestions: navigate(to: .inputName)
        case .stressType:     navigate(to: .personalizedQuestions)
        default: break
        }
    }
}
