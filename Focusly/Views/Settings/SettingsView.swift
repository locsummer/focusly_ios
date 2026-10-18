import SwiftUI

public struct SettingsView: View {
    @AppStorage("notifications_enabled") private var notificationsEnabled = true
    @AppStorage("limit_warning_reminders") private var limitWarningReminders = true
    @AppStorage("daily_summary_time") private var dailySummaryHour = 20
    @ObservedObject private var screenTimeManager = ScreenTimeManager.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Screen Time Authorization")) {
                    HStack {
                        Text("FamilyControls Status")
                        Spacer()
                        Text(screenTimeManager.isAuthorized ? "Approved" : "Not Approved")
                            .foregroundColor(screenTimeManager.isAuthorized ? .green : .red)
                    }
                    
                    if !screenTimeManager.isAuthorized {
                        Button("Re-request Authorization") {
                            Task {
                                await screenTimeManager.requestAuthorization()
                            }
                        }
                    }
                }
                
                Section(header: Text("Smart Reminders & Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Warning 5m Before Limit", isOn: $limitWarningReminders)
                }
                
                Section(header: Text("Security & Anti-Tamper")) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Prevent Clock Manipulation")
                                .font(.body)
                            Text("Enforces automatic network time so limits cannot be bypassed by resetting device clock.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Section(header: Text("About Focusly")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0 (Build 1)")
                            .foregroundColor(.secondary)
                    }
                    Link("Privacy Policy", destination: URL(string: "https://posixpath.com/screen/privacy")!)
                    Link("Terms of Service", destination: URL(string: "https://posixpath.com/screen/terms")!)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
