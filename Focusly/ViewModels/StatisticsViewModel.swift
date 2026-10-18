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
    @Published public var weeklyTotalHours: Double = 14.2
    @Published public var dailyAverageHours: Double = 2.0
    @Published public var phonePickupsCount: Int = 42
    @Published public var categoryBreakdown: [UsageCategoryItem] = []
    @Published public var selectedTimeFrame: Int = 0 // 0: Day, 1: Week, 2: Month
    
    public init() {
        loadStats()
    }
    
    public func loadStats() {
        self.categoryBreakdown = [
            UsageCategoryItem(categoryName: "Social Media", minutes: 95, percentage: 0.45),
            UsageCategoryItem(categoryName: "Productivity", minutes: 55, percentage: 0.25),
            UsageCategoryItem(categoryName: "Entertainment", minutes: 35, percentage: 0.18),
            UsageCategoryItem(categoryName: "Others", minutes: 25, percentage: 0.12)
        ]
    }
}
