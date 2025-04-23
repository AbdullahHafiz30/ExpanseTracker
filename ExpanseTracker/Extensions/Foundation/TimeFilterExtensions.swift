//
//  TabExtensions.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

extension TimeFilter {
    
    /// Returns the start date for the given filter type (e.g., start of day, week, month, or year).
    /// - Parameter current: The current date from which the calculation is based.
    /// - Returns: A Date representing the beginning of the selected time range.
    func startDate(from current: Date) -> Date {
        
        let calendar = Calendar.current
        
        switch self {
        // Start of the current day
        case .daily:
            return calendar.startOfDay(for: current)
            
        // Start of the current week
        case .weekly:
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: current)
            return weekInterval?.start ?? current
            
        // The first day of the month
        case .monthly:
            return current.startOfMonth
            
        // Return January 1st of that year after extracting only the year
        case .yearly:
            let components = calendar.dateComponents([.year], from: current)
            return calendar.date(from: components) ?? current
        }
    }
}
