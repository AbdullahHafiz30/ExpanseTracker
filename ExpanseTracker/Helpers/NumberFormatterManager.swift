//
//  NumberFormatterManager.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

/// A struct for formatting numbers.
struct NumberFormatterManager {
    
    /// Shared instance for global access.
    static let shared = NumberFormatterManager()
    
    /// Private initializer to prevent external instantiation.
    private init() {}

    /// Formats a double into a string.
    /// - Parameters:
    ///   - value: The double value to format.
    ///   - minDigits: Minimum number of digits after the decimal point.
    ///   - maxDigits: Maximum number of digits after the decimal point.
    /// - Returns: A formatted string, or an empty string if fails.
    func decimalString(from value: Double, minDigits: Int = 2, maxDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minDigits
        formatter.maximumFractionDigits = maxDigits
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    /// A reusable instance with decimal style and two fraction digits.
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}


