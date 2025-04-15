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
    
    let formatter = NumberFormatter.decimalFormatter
    let displayedValue = amount?.wrappedValue ?? readOnlyAmount ?? 0.0
    let formattedAmount = formatter.string(from: NSNumber(value: displayedValue)) ?? "0.00"
    
    return VStack(alignment: .leading, spacing: 10) {
        
        Text("How much?")
            .font(.system(size: 33))
            .foregroundColor(themeManager.textColor.opacity(0.2))
            .bold()
            .padding(.leading)
        
        HStack {
            Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                .resizable()
                .frame(width: 50, height: 50)
            
            if let amountBinding = amount {
                TextField("Amount", value: amountBinding, formatter: formatter)
                    .font(.system(size: 33))
                    .keyboardType(.decimalPad)
                    .foregroundColor(themeManager.textColor)
            } else {
                Text("\(formattedAmount)")
                    .font(.system(size: 33))
                    .foregroundColor(themeManager.textColor)
            }
        }
    }
    .padding()
}
