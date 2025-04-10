//
//  SearchBar.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable search and filter bar that combines a static search hint and a filter menu.
struct SearchAndFilterBar: View {
    
    @Binding var searchText: String
    @Binding var selectedTab: Tab

    @State private var debounceTimer: Timer?
    
    var body: some View {
        HStack {
            // Magnifying glass icon to indicate search functionality
            Image(systemName: "magnifyingglass")
            
            // TextField for user input
            TextField("Search for a transaction...", text: $searchText)
                .font(.footnote)
                .onChange(of: searchText) {
                    debounceTimer?.invalidate()
                    debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in}
                }
            
            Spacer() // Push filter icon to the right edge
            
            // Filter menu using a Picker inside a Menu
            Menu {
                Picker("Filter", selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.self) { tabOption in
                        Text(tabOption.rawValue).tag(tabOption)
                    }
                }
            } label: {
                // Filter icon as the menu trigger
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        
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
