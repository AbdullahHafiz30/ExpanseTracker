//
//  TransactionTypeSelector.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 16/10/1446 AH.
//

import SwiftUI

/// A reusable segmented selector that allows the user to choose a transaction type. Displays each option as a capsule-style button.
/// - Parameters:
///   - selectedType: A binding to the currently selected TransactionType.
///   - themeManager: A ThemeManager instance to apply light/dark mode styling.
///   - currentLanguage: The current app language code for localizing type labels.
func TransactionTypeSelector(selectedType: Binding<TransactionType>, themeManager: ThemeManager, currentLanguage: String) -> some View {
    
    VStack(alignment: .leading) {
        
        // MARK: - Section Title
        Text("TransactionType".localized(using: currentLanguage))
            .font(.title2)
            .foregroundColor(themeManager.textColor.opacity(0.5))
            .padding(.leading, 5)
        
        // MARK: - Capsule Buttons for Each Transaction Type
        HStack(spacing: 12) {
            ForEach(TransactionType.allCases) { type in
                
                let isSelected = selectedType.wrappedValue == type // to access the actual value inside the binding
                
                // Determine background color based on theme and selection state
                let fillColor = isSelected
                    ? (themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4))
                    : themeManager.backgroundColor
                
                // Show a border only for unselected capsules
                let borderWidth: CGFloat = isSelected ? 0 : 1
                
                // Display each type label inside a capsule
                Text(type.rawValue.localized(using: currentLanguage))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule().fill(fillColor)
                    )
                    .overlay(
                        Capsule().stroke(
                            themeManager.textColor.opacity(0.4),
                            lineWidth: borderWidth
                        )
                    )
                    .foregroundColor(themeManager.textColor)
                    .onTapGesture {
                        // Update the selected type when tapped
                        selectedType.wrappedValue = type
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.top, 5)
    }
}
