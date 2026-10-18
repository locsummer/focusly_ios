import SwiftUI
import FamilyControls

@main
struct FocuslyApp: App {
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    
    init() {
        // Enforce anti-tampering by default
        ShieldManager.shared.lockSystemSettings(true)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .task {
                    // Check authorization on launch
                    screenTimeManager.updateAuthorizationStatus()
                }
        }
    }
}
