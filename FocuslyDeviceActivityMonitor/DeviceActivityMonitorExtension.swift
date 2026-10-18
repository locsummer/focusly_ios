import DeviceActivity
import ManagedSettings
import Foundation

// The DeviceActivityMonitor runs in background when scheduled intervals start/stop
// or when threshold events are reached.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        if activity == AppConstants.ActivityNames.scheduleBlocking {
            // Apply shields for scheduled block interval
            let selection = UserPreferences.shared.loadShieldSelection()
            if !selection.applicationTokens.isEmpty {
                store.shield.applications = selection.applicationTokens
            }
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        if activity == AppConstants.ActivityNames.scheduleBlocking {
            // Remove shields when interval ends
            store.shield.applications = nil
            store.shield.applicationCategories = nil
        }
    }
    
    override func eventDidReachThreshold(for activity: DeviceActivityName, event: DeviceActivityEvent.Name) {
        super.eventDidReachThreshold(for: activity, event: event)
        
        if event == AppConstants.EventNames.thresholdReached {
            // App limit reached: Shield the restricted applications
            let selection = UserPreferences.shared.loadShieldSelection()
            store.shield.applications = selection.applicationTokens
        }
    }
    
    override func eventWillReachThresholdWarning(for activity: DeviceActivityName, event: DeviceActivityEvent.Name) {
        super.eventWillReachThresholdWarning(for: activity, event: event)
        // 5-minute pre-limit warning trigger
    }
}
