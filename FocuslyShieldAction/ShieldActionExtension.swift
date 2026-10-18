import ManagedSettings
import Foundation

// Handles actions taken when user interacts with the shield buttons
class ShieldActionExtension: ShieldActionDelegate {
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            // Close or dismiss
            completionHandler(.close)
        case .secondaryButtonPressed:
            // Defer shield temporarily or grant emergency minutes if allowed
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }
}
