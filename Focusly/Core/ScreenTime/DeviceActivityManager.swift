import Foundation
import DeviceActivity
import FamilyControls

public final class DeviceActivityManager {
    public static let shared = DeviceActivityManager()
    
    private let center = DeviceActivityCenter()
    
    private init() {}
    
    private func activityName(for limit: AppLimit) -> DeviceActivityName {
        return DeviceActivityName("com.focusly.app.limit.\(limit.id.uuidString)")
    }
    
    private func activityName(for schedule: BlockSchedule) -> DeviceActivityName {
        return DeviceActivityName("com.focusly.app.schedule.\(schedule.id.uuidString)")
    }
    
    /// Starts monitoring scheduled block intervals (e.g. Work hours, Bedtime)
    public func startScheduleMonitoring(schedule: BlockSchedule) {
        let scheduleActivity = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: schedule.startHour, minute: schedule.startMinute),
            intervalEnd: DateComponents(hour: schedule.endHour, minute: schedule.endMinute),
            repeats: true
        )
        
        let name = activityName(for: schedule)
        do {
            try center.startMonitoring(name, during: scheduleActivity)
            print("Successfully started monitoring schedule: \(schedule.title)")
        } catch {
            print("Failed to start monitoring schedule: \(error)")
        }
    }
    
    /// Stops monitoring a specific schedule
    public func stopScheduleMonitoring(schedule: BlockSchedule) {
        let name = activityName(for: schedule)
        center.stopMonitoring([name])
        print("Stopped monitoring schedule: \(schedule.title)")
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
        
        let name = activityName(for: limit)
        do {
            try center.startMonitoring(name, during: schedule, events: events)
            print("Successfully started monitoring daily limit: \(limit.name)")
        } catch {
            print("Failed to start monitoring daily limit: \(error)")
        }
    }
    
    /// Stops monitoring a specific daily limit
    public func stopLimitMonitoring(limit: AppLimit) {
        let name = activityName(for: limit)
        center.stopMonitoring([name])
        print("Stopped monitoring limit: \(limit.name)")
    }
    
    /// Synchronizes all enabled limits and schedules with DeviceActivityCenter
    public func syncAllActiveMonitoring(limits: [AppLimit], schedules: [BlockSchedule]) {
        for limit in limits {
            if limit.isEnabled {
                startLimitMonitoring(limit: limit)
            } else {
                stopLimitMonitoring(limit: limit)
            }
        }
        for schedule in schedules {
            if schedule.isEnabled {
                startScheduleMonitoring(schedule: schedule)
            } else {
                stopScheduleMonitoring(schedule: schedule)
            }
        }
    }
    
    /// Stops all activity monitoring
    public func stopAllMonitoring() {
        center.stopMonitoring()
    }
}
