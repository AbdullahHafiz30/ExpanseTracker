//
//  LanguageManager.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 19/10/1446 AH.
//

import Foundation

/// A singleton class responsible for managing app language settings.
class LanguageManager: ObservableObject {
    
    // Shared instance of LanguageManager.
    static let shared = LanguageManager()
    
    // The currently selected language code.
    @Published var language: String = "en"
    
    // MARK: - Language Setter

    /// Sets the application's language and updates the system preference.
    /// - Parameter languageCode: The ISO language code to switch to.
    func setLanguage(_ languageCode: String) {
        if Bundle.main.localizations.contains(languageCode) {
            // Update system preference for language
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
            language = languageCode
        }
    }
    
    // MARK: - Supported Languages
    
    /// Returns a list of supported language codes.
    var supportedLanguages: [String] {
        return ["en", "ar"]
    }
    
    // MARK: - Language Display Name
    
    /// Returns a human-readable display name for a given language code.
    /// - Parameter languageCode: The language code to convert.
    /// - Returns: A user-facing display name for the language.
    func languageDisplayName(_ languageCode: String) -> String {
        switch languageCode {
        case "en":
            return "English"
        case "ar":
            return "العربية"
        default:
            return "Unknown"
        }
    }
}
