import SwiftUI
import FamilyControls

public struct ScheduleConfigView: View {
    @Environment(\.dismiss) private var dismiss
    var onSave: (BlockSchedule) -> Void
    
    @State private var title: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Calendar.current.date(byAdding: .hour, value: 8, to: Date()) ?? Date()
    @State private var selection: FamilyActivitySelection = FamilyActivitySelection()
    @State private var isShowingPicker = false
    
    public init(onSave: @escaping (BlockSchedule) -> Void) {
        self.onSave = onSave
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Schedule Details")) {
                    TextField("Schedule Title (e.g. Work Hours, Bedtime)", text: $title)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Apps to Block")) {
                    HStack {
                        Text("Selected Apps")
                        Spacer()
                        Text("\(selection.applicationTokens.count) apps, \(selection.categoryTokens.count) categories")
                            .foregroundColor(.secondary)
                    }
                    Button("Choose Apps & Categories") {
                        isShowingPicker = true
                    }
                }
            }
            .navigationTitle("New Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingPicker) {
                AppPickerSheet(selection: $selection)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let cal = Calendar.current
                        let startH = cal.component(.hour, from: startTime)
                        let startM = cal.component(.minute, from: startTime)
                        let endH = cal.component(.hour, from: endTime)
                        let endM = cal.component(.minute, from: endTime)
                        
                        let newSchedule = BlockSchedule(
                            title: title.isEmpty ? "Focus Schedule" : title,
                            startHour: startH,
                            startMinute: startM,
                            endHour: endH,
                            endMinute: endM,
                            selectedApplications: selection
                        )
                        onSave(newSchedule)
                        dismiss()
                    }
                }
            }
        }
    }
}
