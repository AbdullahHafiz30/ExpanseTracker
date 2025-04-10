//
//  Extensions.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import SwiftUI

extension View {
    
    /// Applies horizontal spacing by expanding the view's width to fill the available space,
    /// and aligns the content based on the provided alignment.
    /// - Parameter alignment: The alignment for the view (default is `.center`).
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    /// Applies vertical spacing by expanding the view's height to fill the available space,
    /// and aligns the content based on the provided alignment.
    /// - Parameter alignment: The alignment for the view (default is `.center`).
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Formats a given `Date` into a `String` based on the specified date format.
    /// - Parameters:
    ///   - date: The date to format.
    ///   - format: A date format string.
    /// - Returns: A formatted date string.
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// Converts a `Double` value into a currency-formatted `String`.
    /// - Parameters:
    ///   - value: The numeric value to format.
    ///   - allowedDigits: The number of decimal places to allow (default is 2).
    /// - Returns: A localized currency string (e.g., "SAR 19.99").
    func currencyString(_ value: Double, allowedDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = allowedDigits
        
        return formatter.string(from: .init(value: value)) ?? ""
    }
}

