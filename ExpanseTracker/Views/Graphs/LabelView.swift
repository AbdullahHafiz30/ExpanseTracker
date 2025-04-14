//
//  LabelView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 14/04/2025.
//

import SwiftUI

//struct LabelView: View {
//    let text: String
//
//    var body: some View {
//        HStack(spacing: 4) {
//            Text(text)
//                .font(.subheadline)
//                .fontWeight(.medium)
//            Image(systemName: "chevron.down")
//                .font(.caption)
//        }
//        .padding(.vertical, 6)
//        .padding(.horizontal, 10)
//        .background(Color(.systemGray5))
//        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color(.separator), lineWidth: 0.5)
//        )
//    }
//}

struct LabelView: View {
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Image(systemName: "chevron.down")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

