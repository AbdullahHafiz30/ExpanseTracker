//
//  LanguageManager.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 19/10/1446 AH.
//

import Foundation

class LanguageManager: ObservableObject {
    
    static let shared = LanguageManager()
    @Published var language: String = "en"
    
    func setLanguage(_ languageCode: String) {
        if Bundle.main.localizations.contains(languageCode) {
            
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
            language = languageCode
        }
    }
    
    var supportedLanguages: [String] {
        return ["en", "ar"]
    }
    
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
