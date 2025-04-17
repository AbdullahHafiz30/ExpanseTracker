//
//  UIDManager.swift
//  ExpanseTracker
//
//  Created by Rawan on 17/10/1446 AH.
//
import Foundation

/// `UIDManager` is a utility class that handles saving, loading, and clearing the user UID from `UserDefaults`.
struct UIDManager {
    
    //MARK: - Variables
    
    private static let uidKey = "userUID"
    private static let userDefaults = UserDefaults.standard
    
    // MARK: - Functions
    
    /// Save the user UID to `UserDefaults`
    /// - Parameter uid: The UID to be saved.
    static func saveUID(_ uid: String) {
        UserDefaults.standard.set(uid, forKey: uidKey)
        print("✅ UID saved to UserDefaults.\(uid)")
    }
    
    /// Load the user UID from `UserDefaults`
    /// - Returns: The UID string if it exists, or `nil` if no UID is found.
    static func loadUID() -> String? {
        return UserDefaults.standard.string(forKey: uidKey)
    }
    
    /// Clear the user UID from `UserDefaults`
    static func clearUID() {
        UserDefaults.standard.removeObject(forKey: uidKey)
        print("✅ UID cleared from UserDefaults")
    }
}
