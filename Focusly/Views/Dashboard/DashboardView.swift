import SwiftUI
import FamilyControls

public struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @ObservedObject private var screenTimeManager = ScreenTimeManager.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Authorization Banner if not authorized
                    if !screenTimeManager.isAuthorized {
                        authorizationBanner
                    }
                    
                    // Daily Screen Time & Goal Card
                    dailyProgressCard
                    
                    // Quick Action: Block Apps Now
                    quickBlockCard
                    
                    // Active Protection Summary Cards
                    protectionSummaryGrid
                }
                .padding()
            }
            .navigationTitle("Focusly")
            .background(Color(uiColor: .systemGroupedBackground))
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    private var authorizationBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "exclamationmark.shield.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Screen Time Access Required")
                    .font(.headline)
            }
            Text("Focusly needs permission to monitor screen time and block distracting apps during your focus sessions.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button {
                Task {
                    await screenTimeManager.requestAuthorization()
                }
            } label: {
                Text("Grant Permission")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
    
    private var dailyProgressCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY'S SCREEN TIME")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    let hours = viewModel.todayScreenTimeMinutes / 60
                    let mins = viewModel.todayScreenTimeMinutes % 60
                    Text("\(hours)h \(mins)m")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                }
                Spacer()
                
                ZStack {
                    CircularProgressView(
                        progress: viewModel.progressPercentage,
                        lineWidth: 10,
                        primaryColor: .green
                    )
                    .frame(width: 70, height: 70)
                    
                    VStack(spacing: 0) {
                        Text("\(Int(viewModel.progressPercentage * 100))%")
                            .font(.system(size: 14, weight: .bold))
                        Text("Goal")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Divider()
            
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(viewModel.streakDays) Day Streak")
                        .font(.subheadline.weight(.medium))
                }
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "hourglass")
                        .foregroundColor(.purple)
                    Text("Focus: \(viewModel.todayFocusMinutes) mins")
                        .font(.subheadline.weight(.medium))
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
    
    private var quickBlockCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(viewModel.isQuickBlockActive ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: viewModel.isQuickBlockActive ? "lock.shield.fill" : "lock.open.fill")
                    .font(.title2)
                    .foregroundColor(viewModel.isQuickBlockActive ? .red : .green)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.isQuickBlockActive ? "Distractions Blocked" : "Distractions Allowed")
                    .font(.headline)
                Text(viewModel.isQuickBlockActive ? "Shield is actively blocking apps" : "Tap to immediately shield apps")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { viewModel.isQuickBlockActive },
                set: { _ in viewModel.toggleQuickBlock() }
            ))
            .labelsHidden()
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
    
    private var protectionSummaryGrid: some View {
        HStack(spacing: 14) {
            NavigationLink(destination: AppLimitsView()) {
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "timer")
                        .font(.title)
                        .foregroundColor(.blue)
                    Text("\(viewModel.activeLimitsCount) Active Limits")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("App Limits configured")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(14)
            }
            
            NavigationLink(destination: AppLimitsView()) {
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.title)
                        .foregroundColor(.indigo)
                    Text("\(viewModel.activeSchedulesCount) Schedules")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Blocking routines active")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(14)
            }
        }
    }
}
