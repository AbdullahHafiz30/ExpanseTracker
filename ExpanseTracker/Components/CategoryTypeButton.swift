//
//  CategoryTypeButton.swift
//  ExpanseTracker
//
//  Created by Mac on 17/10/1446 AH.
//

import SwiftUI

// MARK: - Category Type Button
struct CategoryTypeButton: View {
    let title: String
    let isSelected: Bool
    var animation: Namespace.ID
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(   ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeManager.isDarkMode ? Color.black.opacity(0.6) : Color.black)
                            .matchedGeometryEffect(id: "categoryType", in: animation)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                    }
                }
            )
                .foregroundColor(isSelected ? .white : .black)
        }
    }
}
