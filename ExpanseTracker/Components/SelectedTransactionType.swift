//
//  TransactionTypeSelector.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A SwiftUI view that displays the currently selected transaction type in a styled capsule.
/// - Parameters:
///   - themeManager: Manages color and style preferences for light/dark mode.
///   - selectedType: The currently selected transaction type to display.
///   - currentLanguage: The current language code used for localization.
func SelectedTransactionType(themeManager: ThemeManager, selectedType: TransactionType, currentLanguage: String) -> some View {
    HStack {
        // Label for the section
        Text("Transactiontype".localized(using: currentLanguage))
            .font(.title2)
            .foregroundColor(themeManager.textColor.opacity(0.5))
        
        // Display the selected transaction type in a styled capsule
        Text(selectedType.rawValue.localized(using: currentLanguage))
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                // Capsule background that changes based on dark or light theme
                Capsule()
                    .fill(themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4))
            )
            .overlay(
                // Capsule border (lineWidth is 0)
                Capsule()
                    .stroke(themeManager.textColor.opacity(0.4), lineWidth: 0)
            )
            .foregroundColor(themeManager.textColor)
    }
}
