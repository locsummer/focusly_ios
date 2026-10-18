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
        
        if appLimits.isEmpty && blockSchedules.isEmpty {
            setupSampleData()
        }
    }
    
    private func setupSampleData() {
        let sampleLimit = AppLimit(name: "Social Media Limit", limitMinutes: 45)
        let sampleSchedule = BlockSchedule(
            title: "Work Deep Focus",
            startHour: 9,
            startMinute: 0,
            endHour: 17,
            endMinute: 0,
            daysOfWeek: [2, 3, 4, 5, 6]
        )
        self.appLimits = [sampleLimit]
        self.blockSchedules = [sampleSchedule]
        saveLimits()
        saveSchedules()
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
            }
        }
    }
    
    public func deleteLimit(at offsets: IndexSet) {
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
            }
        }
    }
    
    public func deleteSchedule(at offsets: IndexSet) {
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
