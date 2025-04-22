//
//  PriceSection.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable SwiftUI view that displays a currency amount section with a label, currency icon, and either an editable or read-only amount field.
/// - Parameters:
///   - amount: An optional Binding<Double> used for editable input. If nil, a read-only amount is shown.
///   - readOnlyAmount: An optional Double displayed when amount is nil.
///   - themeManager: The current ThemeManager controlling light/dark appearance.
/// - Returns: A SwiftUI view showing the amount section.
func PriceSection(amount: Binding<Double>?, readOnlyAmount: Double?, themeManager: ThemeManager, currentLanguage: String) -> some View {
    return VStack(alignment: .leading, spacing: 10) {
        
        // MARK: - Section title
        Text("HowMuch".localized(using: currentLanguage))
            .font(.largeTitle)
            .foregroundColor(themeManager.textColor.opacity(0.2))
            .bold()
        
        HStack {
            // MARK: - Currency icon (switches based on theme)
            Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                .resizable()
                .frame(width: 60, height: 60)
            
            // MARK: - Editable or read-only amount field
            if let amountBinding = amount {
                // Editable text field for amount input
                TextField("0", value: amountBinding, formatter: NumberFormatterManager.shared.formatter)
                    .font(.system(size: 50))
                    .keyboardType(.decimalPad)
                    .foregroundColor(themeManager.textColor)
            } else {
                // Read-only formatted amount
                Text(NumberFormatterManager.shared.decimalString(from: readOnlyAmount ?? 0.0))
                    .font(.system(size: 33))
                    .foregroundColor(themeManager.textColor)
            }
        }
    }
    .padding(.leading)
}

