import Foundation
import Combine

public struct UsageCategoryItem: Identifiable {
    public let id = UUID()
    public let categoryName: String
    public let minutes: Int
    public let percentage: Double
}

@MainActor
public final class StatisticsViewModel: ObservableObject {
    @Published public var weeklyTotalHours: Double = 0.0
    @Published public var dailyAverageHours: Double = 0.0
    @Published public var phonePickupsCount: Int = 0
    @Published public var categoryBreakdown: [UsageCategoryItem] = []
    @Published public var selectedTimeFrame: Int = 0 // 0: Day, 1: Week, 2: Month
    @Published public var smartInsights: String = "Complete focus sessions and set daily app limits to view your weekly progress."
    
    private let preferences = UserPreferences.shared
    
    public init() {
        loadStats()
    }
    
    public func loadStats() {
        let weeklyMins = preferences.getWeeklyTotalFocusMinutes()
        let weeklyHours = Double(weeklyMins) / 60.0
        let avgHours = (Double(weeklyMins) / 7.0) / 60.0
        
        self.weeklyTotalHours = (weeklyHours * 10).rounded() / 10.0
        self.dailyAverageHours = (avgHours * 10).rounded() / 10.0
        
        let breakdown = preferences.getSessionsBreakdown()
        if !breakdown.isEmpty {
            self.categoryBreakdown = breakdown.map {
                UsageCategoryItem(categoryName: $0.name, minutes: $0.minutes, percentage: $0.percentage)
            }
        } else {
            self.categoryBreakdown = []
        }
        
        if weeklyMins > 0 {
            self.smartInsights = "You logged \(weeklyMins) minutes of productive focus this week! Maintaining consistency builds long-term productivity habits."
        } else {
            self.smartInsights = "No focus sessions logged yet. Tap the Focus tab to start your first Pomodoro session!"
        }
    }
}
