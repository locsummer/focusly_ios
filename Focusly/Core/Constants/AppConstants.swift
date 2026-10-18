import Foundation
import DeviceActivity

public enum AppConstants {
    public static let appGroupName = "group.com.focusly.app"
    public static let appBundleId = "com.focusly.app"
    
    public enum ActivityNames {
        public static let dailyLimits = DeviceActivityName("com.focusly.app.dailyLimits")
        public static let scheduleBlocking = DeviceActivityName("com.focusly.app.scheduleBlocking")
        public static let focusSession = DeviceActivityName("com.focusly.app.focusSession")
    }
    
    public enum EventNames {
        public static let thresholdReached = DeviceActivityEvent.Name("com.focusly.app.thresholdReached")
        public static let warningThreshold = DeviceActivityEvent.Name("com.focusly.app.warningThreshold")
    }
    
    public enum UserDefaultsKeys {
        public static let appLimits = "focusly_app_limits"
        public static let blockSchedules = "focusly_block_schedules"
        public static let focusSessions = "focusly_focus_sessions"
        public static let isFocusActive = "focusly_is_focus_active"
        public static let activeFocusEndTime = "focusly_active_focus_end_time"
        public static let dailyGoalMinutes = "focusly_daily_goal_minutes"
        public static let selectedShieldApps = "focusly_selected_shield_apps"
        public static let hasCompletedOnboarding = "focusly_has_completed_onboarding"
    }
}
