import SwiftUI

struct InputNameView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var vm: OnboardingViewModel
    @FocusState private var nameFieldFocused: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // App Logo
                LogoView()
                    .padding(.bottom, 32)


                // Greeting
                VStack(spacing: 6) {
                    Text("Hello there!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.chillText)
                    Text("What should we call you?")
                        .font(.system(size: 16))
                        .foregroundColor(.chillSubtext)
                }
                .padding(.bottom, 24)

                // Name input
                TextField("Your name goes here", text: $vm.nameText)
                    .font(.system(size: 16))
                    .foregroundColor(.chillText)
                    .tint(.chillGreen)
                    .padding(.horizontal, 18)
                    .frame(height: 52)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .focused($nameFieldFocused)
                    .padding(.horizontal, ChillDesign.horizontalPad)
                    .padding(.bottom, 20)

                ChillButton(
                    title: "Continue",
                    isDisabled: vm.nameText.trimmingCharacters(in: .whitespaces).isEmpty
                ) {
                    vm.saveName()
                    router.navigate(to: .personalizedQuestions)
                }
                .padding(.horizontal, ChillDesign.horizontalPad)

                Spacer()
            }
        }
        .sheet(isPresented: $vm.showImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { vm.profileImage },
                set: { if let img = $0 { vm.saveProfileImage(img) } }
            ))
        }
        .onTapGesture { nameFieldFocused = false }
    }
}
