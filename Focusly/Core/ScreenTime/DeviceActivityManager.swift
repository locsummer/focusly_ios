import Foundation
import DeviceActivity
import FamilyControls

public final class DeviceActivityManager {
    public static let shared = DeviceActivityManager()
    
    private let center = DeviceActivityCenter()
    
    private init() {}
    
    /// Starts monitoring scheduled block intervals (e.g. Work hours, Bedtime)
    public func startScheduleMonitoring(schedule: BlockSchedule) {
        let scheduleActivity = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: schedule.startHour, minute: schedule.startMinute),
            intervalEnd: DateComponents(hour: schedule.endHour, minute: schedule.endMinute),
            repeats: true
        )
        
        do {
            try center.startMonitoring(
                AppConstants.ActivityNames.scheduleBlocking,
                during: scheduleActivity
            )
            print("Successfully started monitoring schedule: \(schedule.title)")
        } catch {
            print("Failed to start monitoring schedule: \(error)")
        }
    }
    
    /// Starts monitoring usage thresholds for app limits (e.g. 30 mins Instagram limit)
    public func startLimitMonitoring(limit: AppLimit) {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        let thresholdEvent = DeviceActivityEvent(
            applications: limit.selectedApplications.applicationTokens,
            categories: limit.selectedApplications.categoryTokens,
            threshold: DateComponents(minute: limit.limitMinutes)
        )
        
        // 5-minute warning before reaching full limit
        let warningThresholdMinutes = max(1, limit.limitMinutes - 5)
        let warningEvent = DeviceActivityEvent(
            applications: limit.selectedApplications.applicationTokens,
            categories: limit.selectedApplications.categoryTokens,
            threshold: DateComponents(minute: warningThresholdMinutes)
        )
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            AppConstants.EventNames.thresholdReached: thresholdEvent,
            AppConstants.EventNames.warningThreshold: warningEvent
        ]
        
        do {
            try center.startMonitoring(
                AppConstants.ActivityNames.dailyLimits,
                during: schedule,
                events: events
            )
            print("Successfully started monitoring daily limit: \(limit.name)")
        } catch {
            print("Failed to start monitoring daily limit: \(error)")
        }
    }
    
    /// Stops all activity monitoring
    public func stopAllMonitoring() {
        center.stopMonitoring([
            AppConstants.ActivityNames.dailyLimits,
            AppConstants.ActivityNames.scheduleBlocking,
            AppConstants.ActivityNames.focusSession
        ])
    }
}
