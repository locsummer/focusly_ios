import ManagedSettings
import ManagedSettingsUI
import UIKit

// Customizes the appearance of the blocking shield overlay displayed over blocked apps
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterialDark,
            backgroundColor: UIColor(red: 0.08, green: 0.12, blue: 0.16, alpha: 0.95),
            icon: UIImage(systemName: "hourglass.badge.plus"),
            title: ShieldConfiguration.Label(
                text: "Focusly: Time's Up!",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "You have reached your screen time limit for this app. Take a deep breath and stay focused on what matters.",
                color: UIColor(white: 0.85, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Back to Focus",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0),
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Quick 5m Break",
                color: UIColor(white: 0.75, alpha: 1.0)
            )
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterialDark,
            backgroundColor: UIColor(red: 0.08, green: 0.12, blue: 0.16, alpha: 0.95),
            icon: UIImage(systemName: "safari.fill"),
            title: ShieldConfiguration.Label(
                text: "Website Blocked",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "This site is currently blocked by your Focusly schedule.",
                color: UIColor(white: 0.85, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "OK",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0)
        )
    }
}
