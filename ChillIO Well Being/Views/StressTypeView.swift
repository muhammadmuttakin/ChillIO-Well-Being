import SwiftUI

struct StressTypeView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var vm: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color.chillBG.ignoresSafeArea()
            
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
                    title: "Let's Get Started",
                    isDisabled: vm.selectedStressType == nil
                ) {
                    vm.saveStressType()
                    router.navigate(to: .mainTab)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)
                .padding(.bottom, 48)
            }
        }
    }
}

struct StressTypeRow: View {
    let stress: StressType
    var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(stress.rawValue)
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
