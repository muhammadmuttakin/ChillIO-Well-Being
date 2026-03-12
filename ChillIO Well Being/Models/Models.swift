import Foundation
import UIKit

// MARK: - User Profile
struct UserProfile {
    var name: String = ""
    var goal: OnboardingGoal?
    var stressType: StressType?
    var profileImage: UIImage?
    var memberSince: String = "March 2026"
    var dayStreak: Int = 0
}

// MARK: - Onboarding Goal
enum OnboardingGoal: String, CaseIterable, Identifiable {
    case reduceStress   = "Reduce Stress"
    case reduceAnxiety  = "Reduce Anxiety"
    case betterSleep    = "Better Sleep"
    case buildSelfEsteem = "Build Self-Esteem"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .reduceStress:    return "apple.meditate"
        case .reduceAnxiety:   return "figure.mind.and.body.circle"
        case .betterSleep:     return "moon.stars"
        case .buildSelfEsteem: return "figure.stair.stepper"
        }
    }
    
    var tag: String {
        switch self {
        case .reduceStress:    return "Stress"
        case .reduceAnxiety:   return "Anxious"
        case .betterSleep:     return "Sleep"
        case .buildSelfEsteem: return "Confidence"
        }
    }
}

// MARK: - Stress Type
enum StressType: String, CaseIterable, Identifiable {
    case work         = "Stress of working"
    case relationship = "Stress of relationship"
    case financial    = "Stress of financial"
    case health       = "Stress of health"
    
    var id: String { rawValue }
}

// MARK: - Audio Item
struct AudioItem: Identifiable {
    let id: UUID = UUID()
    var type: String
    var title: String
    var description: String
    var duration: Double      // seconds
    var imageName: String?
    var category: AudioCategory
}

enum AudioCategory: String, CaseIterable {
    case stress    = "Stress"
    case anxious   = "Anxious"
    case sleep     = "Sleep"
    case esteem     = "Self Esteem"
    
    var iconName: String {
        switch self {
        case .stress:    return "apple.meditate"
        case .anxious:   return "figure.mind.and.body.circle"
        case .sleep:     return "moon.stars"
        case .esteem:    return "figure.stair.stepper"
        }
    }
}

// MARK: - Sample Data
extension AudioItem {
    static let sampleList: [AudioItem] = [
        AudioItem(type: "Meditation", title: "Calm Morning Breath",   description: "Start your day with clarity",             duration: 600,  imageName: "audio_meditation_1",  category: .stress),
        AudioItem(type: "Sound Bath",  title: "Forest Rain Therapy",  description: "Let nature wash away tension",            duration: 900,  imageName: "audio_soundbath_1",   category: .stress),
        AudioItem(type: "Guided",      title: "Body Scan Relaxation", description: "Release tension from head to toe",        duration: 720,  imageName: "audio_guided_1",      category: .anxious),
        AudioItem(type: "Music",       title: "Deep Sleep Journey",   description: "Drift into peaceful slumber",             duration: 1800, imageName: "audio_sleep_1",       category: .sleep),
        AudioItem(type: "Meditation",  title: "Anxiety Release",      description: "Gentle techniques for anxious minds",    duration: 480,  imageName: "audio_meditation_2",  category: .anxious),
        AudioItem(type: "Binaural",    title: "Improving Self-Esteem",     description: "Enter deep concentration",               duration: 1200, imageName: "audio_binaural_1",    category: .esteem),
        AudioItem(type: "Guided",      title: "Self-Compassion Walk", description: "Embrace kindness toward yourself",       duration: 540,  imageName: "audio_guided_2",      category: .stress),
        AudioItem(type: "Sound Bath",  title: "Ocean Waves Healing",  description: "Ride the calming tide",                  duration: 660,  imageName: "audio_soundbath_2",   category: .sleep),
    ]
}
