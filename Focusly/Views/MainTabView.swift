import SwiftUI

public struct MainTabView: View {
    public init() {}
    
    public var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.pie.fill")
                }
            
            AppLimitsView()
                .tabItem {
                    Label("Blocking", systemImage: "hand.raised.fill")
                }
            
            FocusTimerView()
                .tabItem {
                    Label("Focus Timer", systemImage: "hourglass")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Insights", systemImage: "waveform.path.ecg")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
