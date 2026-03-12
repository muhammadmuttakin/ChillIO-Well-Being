//
//  SplashView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            Color.chillBG.ignoresSafeArea()
            
            VStack {
                Spacer()
                LogoView()
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                router.navigate(to: .splashAction)
            }
        }
    }
}

struct LogoView: View {
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.chillGreen)
                .frame(width: 110, height: 110)
                .overlay(
                    Text("chill.io")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                )
                .shadow(color: Color.chillGreen.opacity(0.4), radius: 20, x: 0, y: 8)
        }
    }
}
