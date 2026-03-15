import SwiftUI

struct StreakScreenView: View {
    @EnvironmentObject var vm: OnboardingViewModel
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Fire Emoji with Glow
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                    
                    Text("🔥")
                        .font(.system(size: 80))
                        .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                VStack(spacing: 8) {
                    Text("\(vm.streakCount) Day Streak")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.chillText)
                    
                    Text("You're doing great! Keep it up.")
                        .font(.system(size: 16))
                        .foregroundColor(.chillSubtext)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                Button(action: {
                    let ud = UserDefaultsManager.shared
                    if ud.shouldShowDailyQuestion {
                        router.navigate(to: .dailyQuestion)
                    } else {
                        router.navigate(to: .mainTab)
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.chillGreen)
                        .cornerRadius(16)
                        .shadow(color: Color.chillGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    StreakScreenView()
        .environmentObject(OnboardingViewModel())
        .environmentObject(AppRouter())
}
