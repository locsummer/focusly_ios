import Foundation
import FamilyControls

public final class UserPreferences {
    public static let shared = UserPreferences()
    
    private let defaults: UserDefaults
    
    private init() {
        if let sharedDefaults = UserDefaults(suiteName: AppConstants.appGroupName) {
            self.defaults = sharedDefaults
        } else {
            self.defaults = .standard
        }
    }
    
    // MARK: - App Limits
    public func saveAppLimits(_ limits: [AppLimit]) {
        if let data = try? JSONEncoder().encode(limits) {
            defaults.set(data, forKey: AppConstants.UserDefaultsKeys.appLimits)
        }
    }
    
    public func loadAppLimits() -> [AppLimit] {
        guard let data = defaults.data(forKey: AppConstants.UserDefaultsKeys.appLimits),
              let limits = try? JSONDecoder().decode([AppLimit].self, from: data) else {
            return []
        }
        return limits
    }
    
    // MARK: - Block Schedules
    public func saveBlockSchedules(_ schedules: [BlockSchedule]) {
        if let data = try? JSONEncoder().encode(schedules) {
            defaults.set(data, forKey: AppConstants.UserDefaultsKeys.blockSchedules)
        }
    }
    
    public func loadBlockSchedules() -> [BlockSchedule] {
        guard let data = defaults.data(forKey: AppConstants.UserDefaultsKeys.blockSchedules),
              let schedules = try? JSONDecoder().decode([BlockSchedule].self, from: data) else {
            return []
        }
        return schedules
    }
    
    // MARK: - Shield Applications Selection
    public func saveShieldSelection(_ selection: FamilyActivitySelection) {
        if let data = try? JSONEncoder().encode(selection) {
            defaults.set(data, forKey: AppConstants.UserDefaultsKeys.selectedShieldApps)
        }
    }
    
    public func loadShieldSelection() -> FamilyActivitySelection {
        guard let data = defaults.data(forKey: AppConstants.UserDefaultsKeys.selectedShieldApps),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) else {
            return FamilyActivitySelection()
        }
        return selection
    }
    
    // MARK: - Focus State
    public var isFocusActive: Bool {
        get { defaults.bool(forKey: AppConstants.UserDefaultsKeys.isFocusActive) }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.isFocusActive) }
    }
    
    public var activeFocusEndTime: Date? {
        get { defaults.object(forKey: AppConstants.UserDefaultsKeys.activeFocusEndTime) as? Date }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.activeFocusEndTime) }
    }
    
    public var dailyGoalMinutes: Int {
        get {
            let val = defaults.integer(forKey: AppConstants.UserDefaultsKeys.dailyGoalMinutes)
            return val == 0 ? 120 : val
        }
        set { defaults.set(newValue, forKey: AppConstants.UserDefaultsKeys.dailyGoalMinutes) }
    }
    
    // MARK: - Focus Sessions
    public func saveFocusSessions(_ sessions: [FocusSession]) {
        if let data = try? JSONEncoder().encode(sessions) {
            defaults.set(data, forKey: AppConstants.UserDefaultsKeys.focusSessions)
        }
    }
    
    public func loadFocusSessions() -> [FocusSession] {
        guard let data = defaults.data(forKey: AppConstants.UserDefaultsKeys.focusSessions),
              let sessions = try? JSONDecoder().decode([FocusSession].self, from: data) else {
            return []
        }
        return sessions
    }
    
    // MARK: - Real-time Statistics Helpers
    public func getTodayFocusMinutes() -> Int {
        let sessions = loadFocusSessions()
        let calendar = Calendar.current
        return sessions
            .filter { session in
                guard session.isCompleted, let endTime = session.endTime ?? Optional(session.startTime) else { return false }
                return calendar.isDateInToday(endTime)
            }
            .reduce(0) { $0 + $1.durationMinutes }
    }
    
    public func getWeeklyTotalFocusMinutes() -> Int {
        let sessions = loadFocusSessions()
        let calendar = Calendar.current
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        return sessions
            .filter { session in
                guard session.isCompleted, let endTime = session.endTime ?? Optional(session.startTime) else { return false }
                return endTime >= sevenDaysAgo
            }
            .reduce(0) { $0 + $1.durationMinutes }
    }
    
    public func calculateStreakDays() -> Int {
        let sessions = loadFocusSessions().filter { $0.isCompleted }
        guard !sessions.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        var streak = 0
        var checkDate = Date()
        
        let todayHasSession = sessions.contains { session in
            let date = session.endTime ?? session.startTime
            return calendar.isDateInToday(date)
        }
        if !todayHasSession {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { return 0 }
            let yesterdayHasSession = sessions.contains { session in
                let date = session.endTime ?? session.startTime
                return calendar.isDate(date, inSameDayAs: yesterday)
            }
            if !yesterdayHasSession {
                return 0
            }
            checkDate = yesterday
        }
        
        while true {
            let hasSession = sessions.contains { session in
                let date = session.endTime ?? session.startTime
                return calendar.isDate(date, inSameDayAs: checkDate)
            }
            if hasSession {
                streak += 1
                guard let prevDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = prevDay
            } else {
                break
            }
        }
        return streak
    }
    
    public func getSessionsBreakdown() -> [(name: String, minutes: Int, percentage: Double)] {
        let sessions = loadFocusSessions().filter { $0.isCompleted }
        let total = sessions.reduce(0) { $0 + $1.durationMinutes }
        guard total > 0 else { return [] }
        
        var categoryMap: [String: Int] = [:]
        for s in sessions {
            let key = s.sessionType.rawValue.capitalized
            categoryMap[key, default: 0] += s.durationMinutes
        }
        
        return categoryMap.map { (key, mins) in
            (name: key, minutes: mins, percentage: Double(mins) / Double(total))
        }.sorted { $0.minutes > $1.minutes }
    }
}
