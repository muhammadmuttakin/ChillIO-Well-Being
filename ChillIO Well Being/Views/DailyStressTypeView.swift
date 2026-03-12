//
//  DailyStressTypeView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct DailyStressTypeView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var vm: OnboardingViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    BackButton { router.goBack() }
                    Spacer()
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.top, 16)
                .padding(.bottom, 32)

                VStack(alignment: .leading, spacing: 10) {
                    Text("What type of **Stress** are\nyou struggling with right\nnow?")
                        .font(.system(size: 26, weight: .regular))
                        .foregroundColor(.chillText)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.bottom, 32)

                VStack(spacing: 12) {
                    ForEach(StressType.allCases) { stress in
                        StressTypeRow(
                            stress: stress,
                            isSelected: vm.selectedStressType == stress
                        ) {
                            vm.selectedStressType = stress
                        }
                    }
                }
                .padding(.horizontal, ChillDesign.horizontalPad)

                Spacer()

                ChillButton(
                    title: "Let's Go",
                    isDisabled: vm.selectedStressType == nil
                ) {
                    vm.saveStressType()
                    // Tandai daily question sudah ditampilkan hari ini
                    UserDefaultsManager.shared.markDailyQuestionShown()
                    router.navigate(to: .mainTab)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            // Reset stress type supaya user pilih ulang setiap hari
            vm.selectedStressType = nil
        }
    }
}
