//
//  UIDManager.swift
//  ExpanseTracker
//
//  Created by Rawan on 17/10/1446 AH.
//
import Foundation

struct UIDManager {
    //MARK: - Variables
    private static let uidKey = "userUID"
    private static let userDefaults = UserDefaults.standard
    
    // Save UID to UserDefaults
    static func saveUID(_ uid: String) {
        UserDefaults.standard.set(uid, forKey: uidKey)
        print("✅ UID saved to UserDefaults.\(uid)")
    }
    
    // Load UID from UserDefaults
    static func loadUID() -> String? {
        return UserDefaults.standard.string(forKey: uidKey)
    }
    
    // Clear UID from UserDefaults
    static func clearUID() {
        UserDefaults.standard.removeObject(forKey: uidKey)
        print("✅ UID cleared from UserDefaults")
    }
}
