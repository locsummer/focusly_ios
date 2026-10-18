import Foundation

public struct DailyStats: Identifiable, Codable {
    public var id: UUID
    public var date: Date
    public var totalScreenTimeMinutes: Int
    public var totalFocusTimeMinutes: Int
    public var completedFocusSessions: Int
    public var appBlocksTriggered: Int
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        totalScreenTimeMinutes: Int = 0,
        totalFocusTimeMinutes: Int = 0,
        completedFocusSessions: Int = 0,
        appBlocksTriggered: Int = 0
    ) {
        self.id = id
        self.date = date
        self.totalScreenTimeMinutes = totalScreenTimeMinutes
        self.totalFocusTimeMinutes = totalFocusTimeMinutes
        self.completedFocusSessions = completedFocusSessions
        self.appBlocksTriggered = appBlocksTriggered
    }
}
