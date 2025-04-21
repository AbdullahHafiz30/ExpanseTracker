//
//  SearchBar.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable search and filter bar that combines a static search hint and a filter menu.
struct SearchBar: View {
    
    @Binding var searchText: String
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    
    var body: some View {
        
        HStack {
            // Magnifying glass icon to indicate search functionality
            Image(systemName: "magnifyingglass")
            
            // TextField for user input
            TextField("SearchFor".localized(using: currentLanguage), text: $searchText)
                .font(.footnote)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.gray.opacity(0.15))
        .cornerRadius(50)
        
        // Decorative border and subtle shadow
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.5)
                .foregroundColor(Color(.systemGray4)) // Light border color
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding()
    }
}
