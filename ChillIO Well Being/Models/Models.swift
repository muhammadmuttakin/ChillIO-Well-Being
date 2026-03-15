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
    case grief        = "Stress of grief"
    
    var id: String { rawValue }

    /// Maps to the audio subcategory tag used in filenames.
    var audioSubCategory: AudioSubCategory {
        switch self {
        case .work:         return .work
        case .relationship: return .relationship
        case .financial:    return .financial
        case .grief:        return .grief
        }
    }
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
    var subCategory: AudioSubCategory
    /// Relative path in app bundle (e.g. "Audio/Anxious/file.aac") for playback
    var bundlePath: String?

    init(id: String? = nil, type: String, title: String, description: String, duration: Double, imageName: String? = nil, category: AudioCategory, subCategory: AudioSubCategory = .none, bundlePath: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.type = type
        self.title = title
        self.description = description
        self.duration = duration
        self.imageName = imageName
        self.category = category
        self.subCategory = subCategory
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

enum AudioSubCategory: String, CaseIterable {
    case none         = "none"
    case work         = "work"
    case financial    = "financial"
    case grief        = "grief"
    case relationship = "relationship"
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

            // Parse category + subcategory from filename prefix
            let filename = url.deletingPathExtension().lastPathComponent
            let parsed = parseFilenamePrefix(filename)

            let title = parsed.title
                .replacingOccurrences(of: "_", with: " ")
                .replacingOccurrences(of: "  ", with: " ")

            let item = AudioItem(
                id: bundlePath,
                type: parsed.category.rawValue,
                title: title,
                description: "Relax and unwind",
                duration: 0,
                imageName: nil,
                category: parsed.category,
                subCategory: parsed.subCategory,
                bundlePath: bundlePath
            )
            items.append(item)
        }

        return items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    /// Parses the filename prefix to extract category, subcategory, and clean title.
    ///
    /// Filename format: `category_subcategory_rest_of_title`
    /// Examples:
    ///   - `stress_work_work_home_by_fat_bunny`   → (.stress, .work, "work_home_by_fat_bunny")
    ///   - `anxious_none_drill_buzz_by_stocktune` → (.anxious, .none, "drill_buzz_by_stocktune")
    private static func parseFilenamePrefix(_ filename: String) -> (category: AudioCategory, subCategory: AudioSubCategory, title: String) {
        let parts = filename.split(separator: "_", maxSplits: 2).map(String.init)
        guard parts.count >= 3 else {
            // Fallback: can't parse prefix, treat entire filename as title
            return (.stress, .none, filename)
        }

        let catRaw = parts[0].lowercased()
        let subRaw = parts[1].lowercased()
        let title  = parts[2]

        let category: AudioCategory
        switch catRaw {
        case "stress":      category = .stress
        case "anxious":     category = .anxious
        case "bettersleep": category = .sleep
        case "selfesteem":  category = .selfEsteem
        default:            category = .stress
        }

        let subCategory: AudioSubCategory
        switch subRaw {
        case "work":         subCategory = .work
        case "financial":    subCategory = .financial
        case "grief":        subCategory = .grief
        case "relationship": subCategory = .relationship
        default:             subCategory = .none
        }

        return (category, subCategory, title)
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
