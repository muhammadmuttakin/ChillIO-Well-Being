//
//  SplashActionView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct SplashActionView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            Color.chillBG.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                LogoView()
                
                Spacer()
                
                ChillButton(title: "Begin your journey") {
                    router.navigate(to: .inputName)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.bottom, 48)
            }
        }
    }
}
