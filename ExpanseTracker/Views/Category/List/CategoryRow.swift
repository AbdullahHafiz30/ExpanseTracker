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
                    .fill(Color(colorFromHexString(category.color ?? "")).opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: category.icon ?? "")
                    .foregroundColor(Color(colorFromHexString(category.color ?? "")))
                    .font(.system(size: 20, weight: .medium))
            }

            // Name and Type
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name ?? "")
                    .font(.headline)
                    .foregroundColor(.black)
                Text(LocalizedStringKey(category.categoryType?.rawValue ?? ""))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Chevron Arrow
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        //.padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
              //  .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

