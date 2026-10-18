import Foundation
import FamilyControls

public struct AppLimit: Identifiable, Codable, Equatable {
    public var id: UUID
    public var name: String
    public var limitMinutes: Int
    public var isEnabled: Bool
    public var selectedApplications: FamilyActivitySelection
    public var daysOfWeek: [Int] // 1: Sunday, 2: Monday, ..., 7: Saturday
    
    public init(
        id: UUID = UUID(),
        name: String,
        limitMinutes: Int,
        isEnabled: Bool = true,
        selectedApplications: FamilyActivitySelection = FamilyActivitySelection(),
        daysOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7]
    ) {
        self.id = id
        self.name = name
        self.limitMinutes = limitMinutes
        self.isEnabled = isEnabled
        self.selectedApplications = selectedApplications
        self.daysOfWeek = daysOfWeek
    }
}
