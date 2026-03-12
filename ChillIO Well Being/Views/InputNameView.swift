//
//  InputNameView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct InputNameView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var vm: OnboardingViewModel
    @FocusState private var nameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.chillBG.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Profile Image Picker (replaces chill.io logo)
                ZStack(alignment: .bottomTrailing) {
                    if let img = vm.profileImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color.chillGreen.opacity(0.3), radius: 16, x: 0, y: 6)
                    } else {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.chillGreen.opacity(0.2))
                            .frame(width: 110, height: 110)
                            .overlay(
                                VStack(spacing: 6) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(.chillGreen)
                                    Text("Add Photo")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.chillGreen)
                                }
                            )
                    }
                    
                    // Edit badge
                    Button {
                        vm.showImagePicker = true
                    } label: {
                        Circle()
                            .fill(Color.chillGreen)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "pencil")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .shadow(radius: 4)
                    }
                    .offset(x: 4, y: 4)
                }
                .onTapGesture { vm.showImagePicker = true }
                .padding(.bottom, 36)
                
                // Greeting text
                VStack(spacing: 6) {
                    Text("Hello there!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.chillText)
                    Text("What should we call you?")
                        .font(.system(size: 16))
                        .foregroundColor(.chillSubtext)
                }
                .padding(.bottom, 28)
                
                // Name input
                TextField("Your name goes here", text: $vm.nameText)
                    .font(.system(size: 16))
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
                    .padding(.bottom, 24)
                
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
