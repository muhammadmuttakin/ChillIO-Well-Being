//
//  ProfileView.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: OnboardingViewModel
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header with white bg
                    VStack(spacing: 16) {
                        // Avatar
                        ZStack(alignment: .bottomTrailing) {
                            ProfileAvatar(
                                image: vm.profileImage,
                                initials: vm.initials,
                                size: 88
                            )
                            
                            Button { showImagePicker = true } label: {
                                Circle()
                                    .fill(Color.chillText)
                                    .frame(width: 26, height: 26)
                                    .overlay(
                                        Image(systemName: "pencil")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            .offset(x: 2, y: 2)
                        }
                        
                        // Name
                        HStack(spacing: 6) {
                            Text(vm.userProfile.name.isEmpty ? "Your Name" : vm.userProfile.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.chillText)
                            Image(systemName: "pencil")
                                .font(.system(size: 13))
                                .foregroundColor(.chillSubtext)
                        }
                        
                        Text("Member since \(vm.userProfile.memberSince)")
                            .font(.system(size: 13))
                            .foregroundColor(.chillSubtext)
                        
                        // Tags
                        HStack(spacing: 8) {
                            if let goal = vm.userProfile.goal {
                                TagBadge(title: goal.tag)
                            } else {
                                TagBadge(title: "Stress")
                                TagBadge(title: "Anxious")
                            }
                        }
                    }
                    .padding(.top, 36)
                    .padding(.bottom, 28)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    
                    // Streak
                    VStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.orange)
                        Text("\(vm.userProfile.dayStreak)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.chillText)
                        Text("Day Streak")
                            .font(.system(size: 13))
                            .foregroundColor(.chillSubtext)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.chillBG)
                    
                    // Menu items
                    VStack(spacing: 10) {
                        ProfileMenuItem(
                            icon: "questionmark.circle",
                            title: "Help & Support"
                        ) {}
                        ProfileMenuItem(
                            icon: "lock.shield",
                            title: "Privacy"
                        ) {}
                        ProfileMenuItem(
                            icon: "info.circle",
                            title: "About the App"
                        ) {}
                    }
                    .padding(.horizontal, ChillDesign.horizontalPad)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                }
            }
            .background(Color.chillBG)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { vm.profileImage },
                set: { if let img = $0 { vm.saveProfileImage(img) } }
            ))
        }
    }
}

struct TagBadge: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.chillText)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .overlay(Capsule().stroke(Color.gray.opacity(0.3), lineWidth: 1))
            .clipShape(Capsule())
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundColor(.chillGreen)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.chillText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal, 18)
            .frame(height: 56)
            .background(Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
