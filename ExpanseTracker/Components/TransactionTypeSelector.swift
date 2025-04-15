//
//  TransactionTypeSelector.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 16/10/1446 AH.
//

import SwiftUI

/// A reusable transaction type selector component.
func TransactionTypeSelector(selectedType: Binding<TransactionType>, themeManager: ThemeManager) -> some View {
    VStack(alignment: .center) {
        // Section title
        Text("Transaction type:")
            .font(.title2)
            .foregroundColor(themeManager.textColor.opacity(0.5))
                    
        HStack(spacing: 12) {
            // Loop over all available cases from the TransactionType enum
            ForEach(TransactionType.allCases) { type in
                
                // Check if the current type is the selected one
                let isSelected = selectedType.wrappedValue == type
                
                // Determine background color based on selection and theme mode
                let fillColor = isSelected
                    ? (themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4))
                    : themeManager.backgroundColor
                
                // Border width: hide if selected, show if not
                let borderWidth: CGFloat = isSelected ? 0 : 1
                
                // Render the capsule button for each type
                Text(type.rawValue.capitalized) // Display the type name
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule().fill(fillColor)
                    )
                    .overlay(
                        Capsule().stroke(themeManager.textColor.opacity(0.4), lineWidth: borderWidth)
                    )
                    .foregroundColor(themeManager.textColor)
                    .onTapGesture {
                        // Update the selected type when tapped
                        selectedType.wrappedValue = type
                    }
            }
        }
    }
}
