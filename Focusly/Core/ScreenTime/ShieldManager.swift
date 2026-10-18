import Foundation
import ManagedSettings
import FamilyControls

public final class ShieldManager {
    public static let shared = ShieldManager()
    
    // Named store allows extensions and main app to share or isolate shields
    private let store = ManagedSettingsStore()
    
    private init() {}
    
    /// Apply shield to the given selection of apps and categories
    public func shield(selection: FamilyActivitySelection) {
        let appTokens = selection.applicationTokens
        let categoryTokens = selection.categoryTokens
        
        if !appTokens.isEmpty {
            store.shield.applications = appTokens
        } else {
            store.shield.applications = nil
        }
        
        if !categoryTokens.isEmpty {
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens)
        } else {
            store.shield.applicationCategories = nil
        }
    }
    
    /// Unshield all applications and categories
    public func unshieldAll() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    /// Restrict settings tampering (e.g. prevent changing device date/time to bypass screen limits)
    public func lockSystemSettings(_ lock: Bool) {
        store.dateAndTime.requireAutomaticDateAndTime = lock
        store.account.lockAccounts = lock
    }
}
