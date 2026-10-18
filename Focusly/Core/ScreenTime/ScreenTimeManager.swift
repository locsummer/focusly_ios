import Foundation
import FamilyControls
import Combine

@MainActor
public final class ScreenTimeManager: ObservableObject {
    public static let shared = ScreenTimeManager()
    
    @Published public var authorizationStatus: AuthorizationStatus = .notDetermined
    @Published public var isAuthorized: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let center = AuthorizationCenter.shared
    
    private init() {
        updateAuthorizationStatus()
    }
    
    public func requestAuthorization() async {
        do {
            try await center.requestAuthorization(for: .individual)
            updateAuthorizationStatus()
        } catch {
            self.errorMessage = "Failed to authorize Screen Time: \(error.localizedDescription)"
            self.isAuthorized = false
        }
    }
    
    public func updateAuthorizationStatus() {
        self.authorizationStatus = center.authorizationStatus
        self.isAuthorized = (center.authorizationStatus == .approved)
    }
}
