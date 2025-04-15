//
//  TransactionTypeSelector.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 16/10/1446 AH.
//

import SwiftUI

/// A reusable transaction type selector component.
func TransactionTypeSelector(selectedType: Binding<TransactionType>, themeManager: ThemeManager) -> some View {
    VStack(alignment: .leading) {
        
        // Title aligned to leading
        Text("Transaction type:")
            .font(.title2)
            .foregroundColor(themeManager.textColor.opacity(0.5))
            .padding(.leading, 5)
        
        // Centered HStack inside a full-width container
        HStack(spacing: 12) {
            ForEach(TransactionType.allCases) { type in
                let isSelected = selectedType.wrappedValue == type
                let fillColor = isSelected
                    ? (themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4))
                    : themeManager.backgroundColor
                let borderWidth: CGFloat = isSelected ? 0 : 1
                
                Text(type.rawValue.capitalized)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(fillColor))
                    .overlay(Capsule().stroke(themeManager.textColor.opacity(0.4), lineWidth: borderWidth))
                    .foregroundColor(themeManager.textColor)
                    .onTapGesture {
                        selectedType.wrappedValue = type
                    }
            }
        }
        .frame(maxWidth: .infinity) // full width to allow centering
        .multilineTextAlignment(.center)
        .padding(.top, 5)
    }
}
