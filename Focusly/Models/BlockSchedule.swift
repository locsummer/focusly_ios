import Foundation
import FamilyControls

public struct BlockSchedule: Identifiable, Codable, Equatable {
    public var id: UUID
    public var title: String
    public var startHour: Int
    public var startMinute: Int
    public var endHour: Int
    public var endMinute: Int
    public var daysOfWeek: [Int] // 1: Sunday, ..., 7: Saturday
    public var isEnabled: Bool
    public var selectedApplications: FamilyActivitySelection
    
    public init(
        id: UUID = UUID(),
        title: String,
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int,
        daysOfWeek: [Int] = [2, 3, 4, 5, 6], // Mon-Fri default
        isEnabled: Bool = true,
        selectedApplications: FamilyActivitySelection = FamilyActivitySelection()
    ) {
        self.id = id
        self.title = title
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.daysOfWeek = daysOfWeek
        self.isEnabled = isEnabled
        self.selectedApplications = selectedApplications
    }
    
    public var timeRangeString: String {
        let startStr = String(format: "%02d:%02d", startHour, startMinute)
        let endStr = String(format: "%02d:%02d", endHour, endMinute)
        return "\(startStr) - \(endStr)"
    }
}
