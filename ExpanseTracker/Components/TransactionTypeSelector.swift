//
//  TransactionTypeSelector.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 16/10/1446 AH.
//

import SwiftUI

/// A reusable segmented selector for choosing a transaction type.
/// - Parameters:
///   - selectedType: A Binding to the currently selected TransactionType.
///   - themeManager: A ThemeManager instance used to  style the selector based on light/dark mode.
func TransactionTypeSelector(selectedType: Binding<TransactionType>, themeManager: ThemeManager, currentLanguage: String) -> some View {
    VStack(alignment: .leading) {
        
        // MARK: - Section title
        Text("Transactiontype".localized(using: currentLanguage))
            .font(.title2)
            .foregroundColor(themeManager.textColor.opacity(0.5))
            .padding(.leading, 5)
        
        // MARK: - Row of transaction type capsules
        HStack(spacing: 12) {
            // Loop over all available transaction types
            ForEach(TransactionType.allCases) { type in
                
                // Check if the current type is selected
                let isSelected = selectedType.wrappedValue == type
                
                // Determine fill color based on theme and selection state
                let fillColor = isSelected
                    ? (themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4))
                    : themeManager.backgroundColor
                
                // Show border only for unselected types
                let borderWidth: CGFloat = isSelected ? 0 : 1
                
                // Display each type as a capsule-shaped button
                Text(type.rawValue.localized(using: currentLanguage))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(fillColor))
                    .overlay(
                        Capsule().stroke(
                            themeManager.textColor.opacity(0.4),
                            lineWidth: borderWidth
                        )
                    )
                    .foregroundColor(themeManager.textColor) 
                    .onTapGesture {
                        // Update selected type on tap
                        selectedType.wrappedValue = type
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.top, 5)
    }
}
