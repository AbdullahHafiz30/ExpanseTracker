//
//  DateLabelView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 14/04/2025.
//

import SwiftUI

struct DateLabelView: View {
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

