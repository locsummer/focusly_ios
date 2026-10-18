import DeviceActivity
import SwiftUI

public struct TotalActivityReport: DeviceActivityReportScene {
    // The context defines which report scene is being generated
    public let context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    
    // Configuration closure produces the view from report data
    public let content: (String) -> TotalActivityView
    
    public init(content: @escaping (String) -> TotalActivityView) {
        self.content = content
    }
    
    public func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
        // Formatter calculates aggregated screen time safely within sandbox
        let totalDuration = await data.flatMap { $0.activitySegments }.reduce(0) { $0 + $1.totalActivityDuration }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: totalDuration) ?? "0m"
    }
}

public struct TotalActivityView: View {
    let totalActivity: String
    
    public var body: some View {
        VStack(spacing: 4) {
            Text(totalActivity)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("Total Screen Time")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
