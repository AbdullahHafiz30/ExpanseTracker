//
//  CategoryRow.swift
//  ExpanseTracker
//
//  Created by Mac on 17/10/1446 AH.
//

import SwiftUI


// MARK: - Category Row View
struct CategoryRow: View {
    let category: Category
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 16) {
            // Icon with colored circle
            ZStack {
                Circle()
                    .fill(themeManager.isDarkMode && UIColor().colorFromHexString(category.color ?? "") == .black ? .white.opacity(0.3) : themeManager.isDarkMode ? UIColor().colorFromHexString(category.color ?? "").opacity(0.3) : UIColor().colorFromHexString(category.color ?? "").opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: category.icon ?? "")
                    .foregroundColor(themeManager.isDarkMode && UIColor().colorFromHexString(category.color ?? "") == .black ? .white : themeManager.isDarkMode ? UIColor().colorFromHexString(category.color ?? ""): UIColor().colorFromHexString(category.color ?? ""))
                    .font(.system(size: 20, weight: .medium))
            }

            // Name and Type
                Text(category.name ?? "")
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)

            Spacer()
        }
        .frame(height: 40)

    }
}
