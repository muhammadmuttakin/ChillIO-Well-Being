//
//  OnboardingViewModel.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI
import PhotosUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var userProfile = UserProfile()
    @Published var nameText: String = ""
    @Published var selectedGoal: OnboardingGoal?
    @Published var selectedStressType: StressType?
    @Published var profileImage: UIImage?
    @Published var showImagePicker: Bool = false
    @Published var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    
    var userName: String {
        userProfile.name.isEmpty ? "Friend" : userProfile.name
    }
    
    var initials: String {
        let parts = userProfile.name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }
    
    func saveName() {
        userProfile.name = nameText.trimmingCharacters(in: .whitespaces)
    }
    
    func saveGoal() {
        userProfile.goal = selectedGoal
    }
    
    func saveStressType() {
        userProfile.stressType = selectedStressType
    }
    
    func saveProfileImage(_ image: UIImage) {
        profileImage = image
        userProfile.profileImage = image
    }
    
    func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default:      return "Good Night"
        }
    }
}
