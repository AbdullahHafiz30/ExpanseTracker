//
//  PriceSection.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable SwiftUI view that displays a price section with a label, currency icon, and formatted amount.
/// - Parameters:
///   - amount: The numerical value to display as a price.
///   - themeManager: An instance of ThemeManager used to control theme-based styling.
/// - Returns: A SwiftUI view representing the price section.
func PriceSection(amount: Binding<Double>?, readOnlyAmount: Double?, themeManager: ThemeManager) -> some View {
    return VStack(alignment: .leading, spacing: 10) {
        
        // MARK: - Price section label
        Text("How much?")
            .font(.system(size: 33))
            .foregroundColor(themeManager.textColor.opacity(0.2))
            .bold()
            .padding(.leading)
        
        HStack {
            
            // MARK: - Price section currency icon and formatted amount
            Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                .resizable()
                .frame(width: 50, height: 50)
            
            if let amountBinding = amount {
                TextField("Amount", value: amountBinding, formatter: NumberFormatterManager.shared.formatter)
                    .font(.system(size: 33))
                    .keyboardType(.decimalPad)
                    .foregroundColor(themeManager.textColor)
            } else {
                Text(NumberFormatterManager.shared.decimalString(from: readOnlyAmount ?? 0.0))
                    .font(.system(size: 33))
                    .foregroundColor(themeManager.textColor)
            }
        }
    }
    .padding()
}



