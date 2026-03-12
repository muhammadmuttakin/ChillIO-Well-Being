import SwiftUI
import Combine

struct PersonalizedQuestionsView: View {
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
                    Text("What brings you here,\n\(vm.userName)?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.chillText)

                    Text("Choose one that apply — we'll personalize\nyour experience")
                        .font(.system(size: 14))
                        .foregroundColor(.chillSubtext)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.bottom, 32)

                VStack(spacing: 12) {
                    ForEach(OnboardingGoal.allCases) { goal in
                        GoalRow(goal: goal, isSelected: vm.selectedGoal == goal) {
                            vm.selectedGoal = goal
                        }
                    }
                }
                .padding(.horizontal, ChillDesign.horizontalPad)

                Spacer()

                ChillButton(
                    title: "Continue",
                    isDisabled: vm.selectedGoal == nil
                ) {
                    vm.saveGoal()
                    if vm.selectedGoal == .reduceStress {
                        router.navigate(to: .stressType)
                    } else {
                        vm.completeOnboarding()
                        router.navigate(to: .mainTab)
                    }
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.bottom, 48)
            }
        }
    }
}

struct GoalRow: View {
    let goal: OnboardingGoal
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: goal.iconName)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .white : .chillGreen)
                    .frame(width: 28)

                Text(goal.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .chillText)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 56)
            .background(isSelected ? Color.chillGreen : Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
