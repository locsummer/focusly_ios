import Foundation
import Combine
import FamilyControls

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public var todayScreenTimeMinutes: Int = 145
    @Published public var todayFocusMinutes: Int = 50
    @Published public var dailyGoalMinutes: Int = 120
    @Published public var streakDays: Int = 4
    @Published public var isQuickBlockActive: Bool = false
    @Published public var activeSchedulesCount: Int = 0
    @Published public var activeLimitsCount: Int = 0
    
    private let preferences = UserPreferences.shared
    private let shieldManager = ShieldManager.shared
    
    public init() {
        loadData()
    }
    
    public func loadData() {
        self.dailyGoalMinutes = preferences.dailyGoalMinutes
        let limits = preferences.loadAppLimits()
        let schedules = preferences.loadBlockSchedules()
        
        self.activeLimitsCount = limits.filter { $0.isEnabled }.count
        self.activeSchedulesCount = schedules.filter { $0.isEnabled }.count
        self.isQuickBlockActive = preferences.isFocusActive
    }
    
    public func toggleQuickBlock() {
        isQuickBlockActive.toggle()
        preferences.isFocusActive = isQuickBlockActive
        
        let selection = preferences.loadShieldSelection()
        if isQuickBlockActive {
            shieldManager.shield(selection: selection)
        } else {
            shieldManager.unshieldAll()
        }
    }
    
    public var progressPercentage: Double {
        guard dailyGoalMinutes > 0 else { return 0 }
        return min(Double(todayFocusMinutes) / Double(dailyGoalMinutes), 1.0)
    }
}
