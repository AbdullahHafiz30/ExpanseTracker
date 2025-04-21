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
    var animation: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(   ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black)
                            .matchedGeometryEffect(id: "categoryType", in: animation)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    }
                }
            )
                .foregroundColor(isSelected ? .white : .black)
        }
    }
}
