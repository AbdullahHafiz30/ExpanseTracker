//
//  DateExtensions.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import Foundation

extension Date {
    
    // MARK: - Start Of Month computed variable
    /// Returns a Date representing the start of the current month.
    var startOfMonth: Date {
        
        let calendar = Calendar.current
        // Extract the year and month from the current date
        let components = calendar.dateComponents([.year, .month], from: self)
        // Recreate a new date using the extracted components
        return calendar.date(from: components) ?? self
    }
    
    // MARK: - Formatted function
    /// Formats the date into a string using the specified format.
    /// - Parameter format: A format string.
    /// - Returns: A formatted string representing the date.
    func formatted(as format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

