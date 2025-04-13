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
func PriceSection(amount: Double, themeManager: ThemeManager) -> some View {
    
    // Computed property to format the amount as a string with two decimal places
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
    
    // Return the view structure
    return VStack(alignment: .leading, spacing: 10) {
        
        // Section title
        Text("How much?")
            .font(.system(size: 33))
            .foregroundColor(themeManager.textColor.opacity(0.2))
            .bold()
            .padding(.leading)
        
        HStack {
            // Riyal currency symbol image (changes based on dark/light mode)
            Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                .resizable()
                .frame(width: 50, height: 50)
            
            // Display the formatted amount
            Text("\(formattedAmount)")
                .font(.system(size: 33))
                .foregroundColor(themeManager.textColor)
        }
    }
    .padding() 
}
