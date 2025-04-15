//
//  NumberFormatterExtensions.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 16/10/1446 AH.
//

import Foundation

extension NumberFormatter {
    static var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

