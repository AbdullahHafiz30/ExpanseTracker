//
//  SearchBar.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable SwiftUI view that displays a search bar with a magnifying glass icon and placeholder text.
/// - Parameters:
///   - searchText: A binding to the text the user enters in the search field.
struct SearchBar: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            // MARK: - Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // MARK: - Search Input Field
            TextField("Search for a transaction...", text: $searchText)
                .font(.footnote)
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.gray.opacity(0.15))
        .cornerRadius(50)

        // Capsule border and shadow
        .overlay {
            Capsule()
                .stroke(Color(.systemGray4), lineWidth: 0.5)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding()
    }
}
