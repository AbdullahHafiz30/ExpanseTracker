//
//  TabExtensions.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

extension Tab {
    func startDate(from current: Date) -> Date {
        let calendar = Calendar.current
        switch self {
        case .daily:
            return calendar.startOfDay(for: current)
        case .weekly:
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: current)
            return weekInterval?.start ?? current
        case .monthly:
            return current.startOfMonth
        case .yearly:
            let components = calendar.dateComponents([.year], from: current)
            return calendar.date(from: components) ?? current
        }
    }
}
