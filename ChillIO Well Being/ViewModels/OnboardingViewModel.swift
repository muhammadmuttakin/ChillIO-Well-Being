import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var userProfile      = UserProfile()
    @Published var nameText:        String = ""
    @Published var selectedGoal:    OnboardingGoal?
    @Published var selectedStressType: StressType?
    @Published var profileImage:    UIImage?
    @Published var showImagePicker: Bool = false
    @Published var streakCount:     Int = 0

    @Published var didStreakIncrease: Bool = false

    private let ud = UserDefaultsManager.shared

    init() { load() }

    var userName: String {
        userProfile.name.isEmpty ? "Friend" : userProfile.name
    }

    var initials: String {
        let parts = userProfile.name.split(separator: " ")
        return String(parts.prefix(2).compactMap { $0.first }).uppercased()
    }

    func load() {
        userProfile.name        = ud.userName
        userProfile.memberSince = ud.memberSince
        userProfile.dayStreak   = ud.streakCount
        streakCount             = ud.streakCount

        if let raw = ud.goalRawValue {
            selectedGoal        = OnboardingGoal(rawValue: raw)
            userProfile.goal    = selectedGoal
        }
        if let raw = ud.stressRawValue {
            selectedStressType     = StressType(rawValue: raw)
            userProfile.stressType = selectedStressType
        }
        if let data = ud.profileImageData, let img = UIImage(data: data) {
            profileImage             = img
            userProfile.profileImage = img
        }
        nameText = userProfile.name
    }

    func saveName() {
        let trimmed      = nameText.trimmingCharacters(in: .whitespaces)
        userProfile.name = trimmed
        ud.userName      = trimmed
    }

    func saveGoal() {
        userProfile.goal = selectedGoal
        ud.goalRawValue  = selectedGoal?.rawValue
    }

    func saveStressType() {
        userProfile.stressType = selectedStressType
        ud.stressRawValue      = selectedStressType?.rawValue
    }

    func saveProfileImage(_ image: UIImage) {
        profileImage             = image
        userProfile.profileImage = image
        ud.profileImageData      = image.jpegData(compressionQuality: 0.8)
    }

    /// Selesaikan onboarding — simpan flag + tandai daily question hari ini
    func completeOnboarding() {
        ud.completeOnboarding()
    }

    func handleAppOpen() {
        let result            = ud.handleAppOpen()
        streakCount           = result.count
        userProfile.dayStreak = result.count
        didStreakIncrease     = result.didIncrease
    }

    /// Update goal dari daily question, tandai sudah ditanya hari ini
    func updateDailyGoal(_ goal: OnboardingGoal) {
        selectedGoal     = goal
        userProfile.goal = goal
        ud.goalRawValue  = goal.rawValue
        ud.markDailyQuestionShown()
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
