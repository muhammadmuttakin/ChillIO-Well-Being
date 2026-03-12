import Foundation
import UIKit

private enum UDKey {
    static let userName               = "ud_userName"
    static let profileImageData       = "ud_profileImageData"
    static let goalRawValue           = "ud_goalRawValue"
    static let stressRawValue         = "ud_stressRawValue"
    static let memberSince            = "ud_memberSince"
    static let hasCompletedOnboarding = "ud_hasCompletedOnboarding"
    static let streakCount            = "ud_streakCount"
    static let lastOpenDate           = "ud_lastOpenDate"
    static let lastDailyQuestion      = "ud_lastDailyQuestion"
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let ud = UserDefaults.standard
    private init() {}

    // MARK: - Onboarding
    var hasCompletedOnboarding: Bool {
        get { ud.bool(forKey: UDKey.hasCompletedOnboarding) }
        set { ud.set(newValue, forKey: UDKey.hasCompletedOnboarding) }
    }

    var userName: String {
        get { ud.string(forKey: UDKey.userName) ?? "" }
        set { ud.set(newValue, forKey: UDKey.userName) }
    }

    var goalRawValue: String? {
        get { ud.string(forKey: UDKey.goalRawValue) }
        set { ud.set(newValue, forKey: UDKey.goalRawValue) }
    }

    var stressRawValue: String? {
        get { ud.string(forKey: UDKey.stressRawValue) }
        set { ud.set(newValue, forKey: UDKey.stressRawValue) }
    }

    var memberSince: String {
        if let saved = ud.string(forKey: UDKey.memberSince) { return saved }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let value = formatter.string(from: Date())
        ud.set(value, forKey: UDKey.memberSince)
        return value
    }

    var profileImageData: Data? {
        get { ud.data(forKey: UDKey.profileImageData) }
        set { ud.set(newValue, forKey: UDKey.profileImageData) }
    }

    // MARK: - Streak
    var streakCount: Int {
        get { ud.integer(forKey: UDKey.streakCount) }
        set { ud.set(newValue, forKey: UDKey.streakCount) }
    }

    private var lastOpenDate: Date? {
        get { ud.object(forKey: UDKey.lastOpenDate) as? Date }
        set { ud.set(newValue, forKey: UDKey.lastOpenDate) }
    }

    @discardableResult
    func handleAppOpen() -> Int {
        let cal   = Calendar.current
        let today = cal.startOfDay(for: Date())
        if let last = lastOpenDate {
            let lastDay = cal.startOfDay(for: last)
            if cal.isDate(lastDay, inSameDayAs: today) { return streakCount }
            let diff = cal.dateComponents([.day], from: lastDay, to: today).day ?? 0
            streakCount = diff == 1 ? streakCount + 1 : 1
        } else {
            streakCount = 1
        }
        lastOpenDate = today
        return streakCount
    }

    // MARK: - Daily Question
    /// Dipanggil saat onboarding selesai.
    /// Tandai hari ini sudah ditanya → daily question baru muncul BESOK.
    func completeOnboarding() {
        hasCompletedOnboarding = true
        markDailyQuestionShown()
    }

    var shouldShowDailyQuestion: Bool {
        guard hasCompletedOnboarding else { return false }
        let cal   = Calendar.current
        let today = cal.startOfDay(for: Date())
        if let last = ud.object(forKey: UDKey.lastDailyQuestion) as? Date {
            return !cal.isDate(cal.startOfDay(for: last), inSameDayAs: today)
        }
        return true
    }

    func markDailyQuestionShown() {
        ud.set(Date(), forKey: UDKey.lastDailyQuestion)
    }
}
