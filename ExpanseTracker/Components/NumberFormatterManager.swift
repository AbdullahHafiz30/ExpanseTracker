//
//  DoubleExtensions.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

/// A singleton manager that provides NumberFormatter utilities
struct NumberFormatterManager {
    
    /// Shared instance of the formatter manager for global use.
    static let shared = NumberFormatterManager()
    
    private init() {}
    
    /// Converts a Double into a formatted decimal string.
    /// - Parameters:
    ///   - value: The numeric value to format.
    ///   - minDigits: Minimum number of digits after the decimal point.
    ///   - maxDigits: Maximum number of digits after the decimal point.
    /// - Returns: A string formatted using the .decimal style.
    func decimalString(from value: Double, minDigits: Int = 2, maxDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minDigits
        formatter.maximumFractionDigits = maxDigits
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    /// A reusable decimal formatter with 2 fixed fraction digits.
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

