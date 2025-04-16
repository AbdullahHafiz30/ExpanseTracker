//
//  CategoryTypeButton.swift
//  ExpanseTracker
//
//  Created by Mac on 17/10/1446 AH.
//

import SwiftUI

// MARK: - Category Type Button
struct CategoryTypeButton: View {
    let title: LocalizedStringKey
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.black : Color.gray.opacity(0.15))
                )
                .foregroundColor(isSelected ? .white : .black)
                .shadow(radius: isSelected ? 3 : 0)
        }
    }
}
