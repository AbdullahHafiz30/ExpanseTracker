//
//  SearchBar.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable SwiftUI view that displays a localized search bar with a magnifying glass icon and rounded design.
/// - Parameters:
///   - searchText: A binding to the user-entered search string.
struct SearchBar: View {
    
    @Binding var searchText: String
    
    // The current app language for localization.
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    var body: some View {
        HStack {
            
            // MARK: - Search Icon (magnifying glass)
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // MARK: - Search Input Field
            TextField("SearchFor".localized(using: currentLanguage), text: $searchText)
                .font(.footnote)
                .foregroundColor(.primary)
                .disableAutocorrection(true) // Prevent iOS from correcting user input
                .textInputAutocapitalization(.none) // Prevent capitalization for better search accuracy
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.gray.opacity(0.15))
        .cornerRadius(50)
        
        // MARK: - Border & Shadow Styling
        .overlay {
            Capsule()
                .stroke(Color(.systemGray4), lineWidth: 0.5)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .padding()
    }
}


struct CategorySearchBar: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            // MARK: - Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // MARK: - Search Input Field
            TextField("Search for a Category ...", text: $searchText)
                .font(.footnote)
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.gray.opacity(0.15))
        .cornerRadius(50)

        // Capsule border and shadow
//        .overlay {
//            Capsule()
//                .stroke(Color(.systemGray4), lineWidth: 0.5)
//                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
//        }
//        .padding()
    }
}

