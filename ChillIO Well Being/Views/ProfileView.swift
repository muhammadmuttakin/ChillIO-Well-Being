import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: OnboardingViewModel
    @State private var showImagePicker = false
    @State private var isEditingName = false
    @State private var editedName = ""
    @FocusState private var isNameFocused: Bool
    @State private var showHelpSupport = false
    @State private var showPrivacy = false
    @State private var showAboutApp = false
    
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
                            if isEditingName {
                                TextField("Your Name", text: $editedName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.chillText)
                                    .multilineTextAlignment(.center)
                                    .focused($isNameFocused)
                                    .fixedSize()
                                    .onSubmit {
                                        vm.nameText = editedName
                                        vm.saveName()
                                        isEditingName = false
                                    }
                            } else {
                                Text(vm.userProfile.name.isEmpty ? "Your Name" : vm.userProfile.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.chillText)
                            }
                            
                            Button {
                                if isEditingName {
                                    vm.nameText = editedName
                                    vm.saveName()
                                    isEditingName = false
                                    isNameFocused = false
                                } else {
                                    editedName = vm.userProfile.name
                                    isEditingName = true
                                    isNameFocused = true
                                }
                            } label: {
                                Image(systemName: isEditingName ? "checkmark.circle.fill" : "pencil.line")
                                    .font(.system(size: 15))
                                    .foregroundColor(isEditingName ? .chillGreen : .chillSubtext)
                            }
                        }
                        
                        Text("Member since \(vm.userProfile.memberSince)")
                            .font(.system(size: 13))
                            .foregroundColor(.chillSubtext)
                        
                        // Tags
                        HStack(spacing: 8) {
                            if let goal = vm.userProfile.goal {
                                TagBadge(title: goal.tag, iconName: goal.iconName)
                            } else {
                                TagBadge(title: "Stress", iconName: "apple.meditate")
                                TagBadge(title: "Anxious", iconName: "figure.mind.and.body.circle")
                            }
                        }
                    }
                    .padding(.top, 36)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    
                    // Streak
                    VStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.orange)
                        Text("\(vm.streakCount)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.chillText)
                        Text("Day Streak")
                            .font(.system(size: 13))
                            .foregroundColor(.chillSubtext)
                    }
                    .frame(width: 120, height: 120)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    // Menu items
                    VStack(spacing: 10) {
                        Button { showHelpSupport = true } label: {
                            ProfileMenuItem(
                                icon: "questionmark.circle",
                                title: "Help & Support"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button { showPrivacy = true } label: {
                            ProfileMenuItem(
                                icon: "lock.shield",
                                title: "Privacy"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button { showAboutApp = true } label: {
                            ProfileMenuItem(
                                icon: "info.circle",
                                title: "About the App"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
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
        .fullScreenCover(isPresented: $showHelpSupport) {
            HelpSupportView()
        }
        .fullScreenCover(isPresented: $showPrivacy) {
            PrivacyView()
        }
        .fullScreenCover(isPresented: $showAboutApp) {
            AboutAppView()
        }
    }
}

struct TagBadge: View {
    let title: String
    var iconName: String? = nil
    var body: some View {
        HStack(spacing: 4) {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.system(size: 11, weight: .medium))
            }
            Text(title)
                .font(.system(size: 12, weight: .medium))
        }
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
    
    var body: some View {
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
}
