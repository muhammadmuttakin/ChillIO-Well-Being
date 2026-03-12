//
//  Models.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

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
        case .reduceStress:    return "leaf.fill"
        case .reduceAnxiety:   return "plus.circle"
        case .betterSleep:     return "moon.fill"
        case .buildSelfEsteem: return "figure.walk"
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
    case focus     = "Focus"
}

// MARK: - Sample Data
extension AudioItem {
    static let sampleList: [AudioItem] = [
        AudioItem(type: "Meditation", title: "Calm Morning Breath", description: "Start your day with clarity", duration: 600, category: .stress),
        AudioItem(type: "Sound Bath",  title: "Forest Rain Therapy", description: "Let nature wash away tension", duration: 900, category: .stress),
        AudioItem(type: "Guided",      title: "Body Scan Relaxation", description: "Release tension from head to toe", duration: 720, category: .anxious),
        AudioItem(type: "Music",       title: "Deep Sleep Journey",   description: "Drift into peaceful slumber", duration: 1800, category: .sleep),
        AudioItem(type: "Meditation",  title: "Anxiety Release",      description: "Gentle techniques for anxious minds", duration: 480, category: .anxious),
        AudioItem(type: "Binaural",    title: "Focus Flow State",     description: "Enter deep concentration", duration: 1200, category: .focus),
        AudioItem(type: "Guided",      title: "Self-Compassion Walk", description: "Embrace kindness toward yourself", duration: 540, category: .stress),
        AudioItem(type: "Sound Bath",  title: "Ocean Waves Healing",  description: "Ride the calming tide", duration: 660, category: .sleep),
    ]
}
