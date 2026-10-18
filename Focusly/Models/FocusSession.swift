import Foundation

public enum FocusSessionType: String, Codable, CaseIterable {
    case pomodoro = "Pomodoro"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
    case deepWork = "Deep Work"
    
    public var defaultMinutes: Int {
        switch self {
        case .pomodoro: return 25
        case .shortBreak: return 5
        case .longBreak: return 15
        case .deepWork: return 60
        }
    }
}

public struct FocusSession: Identifiable, Codable, Equatable {
    public var id: UUID
    public var sessionType: FocusSessionType
    public var durationMinutes: Int
    public var startTime: Date
    public var endTime: Date?
    public var isCompleted: Bool
    
    public init(
        id: UUID = UUID(),
        sessionType: FocusSessionType = .pomodoro,
        durationMinutes: Int = 25,
        startTime: Date = Date(),
        endTime: Date? = nil,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.sessionType = sessionType
        self.durationMinutes = durationMinutes
        self.startTime = startTime
        self.endTime = endTime
        self.isCompleted = isCompleted
    }
}
