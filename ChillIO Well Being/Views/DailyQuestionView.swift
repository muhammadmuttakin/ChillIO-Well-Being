import SwiftUI

struct DailyQuestionView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var vm: OnboardingViewModel
    @State private var selected: OnboardingGoal? = nil

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("What brings you here,\n\(vm.userName)?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.chillText)

                    Text("Choose one that apply — we'll personalize\nyour experience")
                        .font(.system(size: 14))
                        .foregroundColor(.chillSubtext)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.top, 64)
                .padding(.bottom, 32)

                VStack(spacing: 12) {
                    ForEach(OnboardingGoal.allCases) { goal in
                        GoalRow(goal: goal, isSelected: selected == goal) {
                            selected = goal
                        }
                    }
                }
                .padding(.horizontal, ChillDesign.horizontalPad)

                Spacer()

                VStack(spacing: 12) {
                    ChillButton(
                        title: "Continue",
                        isDisabled: selected == nil
                    ) {
                        guard let goal = selected else { return }
                        // Simpan goal dulu
                        vm.selectedGoal = goal
                        vm.saveGoal()

                        if goal == .reduceStress {
                            // Lanjut ke daily stress type, belum mark shown
                            router.navigate(to: .dailyStressType)
                        } else {
                            // Selesai, tandai sudah ditanya hari ini
                            vm.updateDailyGoal(goal)
                            router.navigate(to: .mainTab)
                        }
                    }

                    Button("Skip for today") {
                        UserDefaultsManager.shared.markDailyQuestionShown()
                        router.navigate(to: .mainTab)
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.chillSubtext)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            selected = vm.selectedGoal
        }
    }
}
