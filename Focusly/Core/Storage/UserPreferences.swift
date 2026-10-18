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
}
