import Foundation
import Combine
import FamilyControls

@MainActor
public final class AppLimitsViewModel: ObservableObject {
    @Published public var appLimits: [AppLimit] = []
    @Published public var blockSchedules: [BlockSchedule] = []
    @Published public var quickShieldSelection: FamilyActivitySelection = FamilyActivitySelection()
    @Published public var isShowingAppPicker: Bool = false
    @Published public var isShowingAddLimitSheet: Bool = false
    @Published public var isShowingAddScheduleSheet: Bool = false
    
    private let preferences = UserPreferences.shared
    private let shieldManager = ShieldManager.shared
    private let activityManager = DeviceActivityManager.shared
    
    public init() {
        loadData()
    }
    
    public func loadData() {
        self.appLimits = preferences.loadAppLimits()
        self.blockSchedules = preferences.loadBlockSchedules()
        self.quickShieldSelection = preferences.loadShieldSelection()
        
        // Sync monitoring state with active limits and schedules
        activityManager.syncAllActiveMonitoring(limits: appLimits, schedules: blockSchedules)
    }
    
    public func addLimit(_ limit: AppLimit) {
        appLimits.append(limit)
        saveLimits()
        if limit.isEnabled {
            activityManager.startLimitMonitoring(limit: limit)
        }
    }
    
    public func toggleLimit(_ limit: AppLimit) {
        if let index = appLimits.firstIndex(where: { $0.id == limit.id }) {
            appLimits[index].isEnabled.toggle()
            saveLimits()
            if appLimits[index].isEnabled {
                activityManager.startLimitMonitoring(limit: appLimits[index])
            } else {
                activityManager.stopLimitMonitoring(limit: appLimits[index])
            }
        }
    }
    
    public func deleteLimit(at offsets: IndexSet) {
        for index in offsets {
            guard index < appLimits.count else { continue }
            activityManager.stopLimitMonitoring(limit: appLimits[index])
        }
        appLimits.remove(atOffsets: offsets)
        saveLimits()
    }
    
    public func addSchedule(_ schedule: BlockSchedule) {
        blockSchedules.append(schedule)
        saveSchedules()
        if schedule.isEnabled {
            activityManager.startScheduleMonitoring(schedule: schedule)
        }
    }
    
    public func toggleSchedule(_ schedule: BlockSchedule) {
        if let index = blockSchedules.firstIndex(where: { $0.id == schedule.id }) {
            blockSchedules[index].isEnabled.toggle()
            saveSchedules()
            if blockSchedules[index].isEnabled {
                activityManager.startScheduleMonitoring(schedule: blockSchedules[index])
            } else {
                activityManager.stopScheduleMonitoring(schedule: blockSchedules[index])
            }
        }
    }
    
    public func deleteSchedule(at offsets: IndexSet) {
        for index in offsets {
            guard index < blockSchedules.count else { continue }
            activityManager.stopScheduleMonitoring(schedule: blockSchedules[index])
        }
        blockSchedules.remove(atOffsets: offsets)
        saveSchedules()
    }
    
    public func updateQuickShieldSelection(_ selection: FamilyActivitySelection) {
        self.quickShieldSelection = selection
        preferences.saveShieldSelection(selection)
    }
    
    private func saveLimits() {
        preferences.saveAppLimits(appLimits)
    }
    
    private func saveSchedules() {
        preferences.saveBlockSchedules(blockSchedules)
    }
}
