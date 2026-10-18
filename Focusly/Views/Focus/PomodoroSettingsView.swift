import SwiftUI

public struct PomodoroSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("pomodoro_work_duration") private var workDuration: Int = 25
    @AppStorage("pomodoro_short_break") private var shortBreak: Int = 5
    @AppStorage("pomodoro_long_break") private var longBreak: Int = 15
    @AppStorage("pomodoro_strict_mode") private var strictMode: Bool = true
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Interval Durations")) {
                    Stepper("Focus Interval: \(workDuration) min", value: $workDuration, in: 5...90, step: 5)
                    Stepper("Short Break: \(shortBreak) min", value: $shortBreak, in: 1...30, step: 1)
                    Stepper("Long Break: \(longBreak) min", value: $longBreak, in: 5...60, step: 5)
                }
                
                Section(header: Text("Distraction Free Mode"), footer: Text("Strict Mode automatically shields distracting apps during the countdown.")) {
                    Toggle("Strict Mode Blocking", isOn: $strictMode)
                }
            }
            .navigationTitle("Timer Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
