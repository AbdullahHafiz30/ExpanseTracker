//
//  NumberFormatterManager.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

struct NumberFormatterManager {
    
    static let shared = NumberFormatterManager()
    
    private init() {}
    
    /// Returns a decimal formatted string (e.g., "1,234.56")
    func decimalString(from value: Double, minDigits: Int = 2, maxDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minDigits
        formatter.maximumFractionDigits = maxDigits
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

