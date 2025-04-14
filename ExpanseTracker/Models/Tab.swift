//
//  Tab.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

/// Enum representing the available time filters for data display.
enum Tab: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String {
        rawValue
    }
}

