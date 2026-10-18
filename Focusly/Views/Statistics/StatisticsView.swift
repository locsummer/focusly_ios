import SwiftUI

public struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Timeframe", selection: $viewModel.selectedTimeFrame) {
                        Text("Day").tag(0)
                        Text("Week").tag(1)
                        Text("Month").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    // High-level Metrics Cards
                    HStack(spacing: 12) {
                        metricCard(title: "Total Screen Time", value: "\(viewModel.weeklyTotalHours)h", subtitle: "+12% vs last week", color: .blue)
                        metricCard(title: "Daily Average", value: "\(viewModel.dailyAverageHours)h", subtitle: "Goal: 2.0h", color: .green)
                        metricCard(title: "Pickups", value: "\(viewModel.phonePickupsCount)", subtitle: "times / day", color: .orange)
                    }
                    
                    // Category Breakdown
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Top Usage Categories")
                            .font(.headline)
                        
                        ForEach(viewModel.categoryBreakdown) { item in
                            VStack(spacing: 6) {
                                HStack {
                                    Text(item.categoryName)
                                        .font(.subheadline.weight(.medium))
                                    Spacer()
                                    Text("\(item.minutes) mins")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                ProgressView(value: item.percentage)
                                    .accentColor(colorForCategory(item.categoryName))
                            }
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                    // Weekly Insights Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                            Text("Focusly Smart Insights")
                                .font(.headline)
                        }
                        Text("You saved 1h 45m this week by adhering to your Social Media limits! Your focus sessions were most productive on Tuesday mornings.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Reports & Insights")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
    
    private func metricCard(title: String, value: String, subtitle: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(subtitle)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Social Media": return .red
        case "Productivity": return .blue
        case "Entertainment": return .purple
        default: return .gray
        }
    }
}
