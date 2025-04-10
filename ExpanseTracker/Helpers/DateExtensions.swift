//
//  DateExtensions.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import SwiftUI

extension Date {
    
    /// Returns the start of the current month.
    var startOfMonth: Date {
        let calendar = Calendar.current
        
        // Extract only the year and month components from the current date.
        let components = calendar.dateComponents([.year, .month], from: self)
        
        // Reconstruct a date using only year and month, which defaults to the 1st of the month at midnight.
        return calendar.date(from: components) ?? self
    }
    
    /// Returns the end of the current month.
    var endOfMonth: Date {
        let calendar = Calendar.current
        
        // Add 1 month to the start of the month, then subtract 1 minute to get the very end of the current month.
        return calendar.date(byAdding: .init(month: 1, minute: -1), to: self.startOfMonth) ?? self
    }
}
