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
struct AudioItem: Identifiable, Equatable {
    let id: String
    var type: String
    var title: String
    var description: String
    var duration: Double      // seconds
    var imageName: String?
    var category: AudioCategory
    /// Relative path in app bundle (e.g. "Audio/Anxious/file.aac") for playback
    var bundlePath: String?

    init(id: String? = nil, type: String, title: String, description: String, duration: Double, imageName: String? = nil, category: AudioCategory, bundlePath: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.type = type
        self.title = title
        self.description = description
        self.duration = duration
        self.imageName = imageName
        self.category = category
        self.bundlePath = bundlePath
    }

    static func == (lhs: AudioItem, rhs: AudioItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum AudioCategory: String, CaseIterable {
    case stress    = "Stress"
    case anxious   = "Anxious"
    case sleep     = "Sleep"
    case selfEsteem = "Self Esteem"
    
    /// SF Symbol name for list/player icon per category
    var iconName: String {
        switch self {
        case .stress:     return "leaf.fill"
        case .anxious:    return "brain.head.profile"
        case .sleep:      return "moon.fill"
        case .selfEsteem: return "heart.fill"
        }
    }
}

// MARK: - Onboarding Goal → Audio Category (for Home filtering)
extension OnboardingGoal {
    var audioCategory: AudioCategory? {
        switch self {
        case .reduceStress:    return .stress
        case .reduceAnxiety:   return .anxious
        case .betterSleep:     return .sleep
        case .buildSelfEsteem: return .selfEsteem
        }
    }
}

// MARK: - Bundle Loader (audio from bundle — works with any Copy Bundle Resources layout)
extension AudioItem {
    private static let audioExtensions = ["aac", "m4a", "mp3"]

    /// Loads all audio files from the app bundle by scanning the entire bundle recursively.
    /// Works whether Xcode copies files under "Audio/", "ChillIO Well Being/Audio/", or flat.
    static func loadFromBundle() -> [AudioItem] {
        let fileManager = FileManager.default
        let bundleRoot = Bundle.main.bundleURL
        let bundleRootPath = bundleRoot.path
        let normalizedRoot = bundleRootPath.hasSuffix("/") ? bundleRootPath : bundleRootPath + "/"

        var items: [AudioItem] = []

        guard let enumerator = fileManager.enumerator(
            at: bundleRoot,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        while let url = enumerator.nextObject() as? URL {
            let ext = url.pathExtension.lowercased()
            guard Self.audioExtensions.contains(ext) else { continue }

            var isRegular = false
            (try? url.resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile.map { isRegular = $0 }
            if !isRegular { continue }

            let fullPath = url.path
            let bundlePath = fullPath.hasPrefix(normalizedRoot)
                ? String(fullPath.dropFirst(normalizedRoot.count))
                : url.lastPathComponent

            let category = categoryFromPath(bundlePath)

            let rawTitle = url.deletingPathExtension().lastPathComponent
            let title = rawTitle
                .replacingOccurrences(of: "_", with: " ")
                .replacingOccurrences(of: "  ", with: " ")

            let item = AudioItem(
                id: bundlePath,
                type: category.rawValue,
                title: title,
                description: "Relax and unwind",
                duration: 0,
                imageName: nil,
                category: category,
                bundlePath: bundlePath
            )
            items.append(item)
        }

        return items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    /// Infers category from path (e.g. "Audio/Anxious/file.aac" → .anxious).
    private static func categoryFromPath(_ path: String) -> AudioCategory {
        let lower = path.lowercased()
        if lower.contains("anxious") { return .anxious }
        if lower.contains("bettersleep") { return .sleep }
        if lower.contains("selfesteem") { return .selfEsteem }
        if lower.contains("stress") || lower.contains("financial") || lower.contains("grief")
            || lower.contains("relationship") || lower.contains("/work") || lower.contains("work/") { return .stress }
        return .stress
    }

    /// Resolves bundle path to a file URL for playback (supports paths with subfolders).
    static func urlInBundle(for bundlePath: String) -> URL? {
        let fileManager = FileManager.default
        let base = Bundle.main.bundleURL
        let trimmed = bundlePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        var built = base
        for component in trimmed.split(separator: "/") {
            built = built.appendingPathComponent(String(component))
        }
        return fileManager.fileExists(atPath: built.path) ? built : nil
    }

    /// All audio from bundle (any layout).
    static var allAudio: [AudioItem] {
        loadFromBundle()
    }
}
