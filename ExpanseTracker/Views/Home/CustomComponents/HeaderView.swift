//
//  File.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A header view showing a welcome message, user name, and a search/filter bar.
@ViewBuilder
func HeaderView(_ size: CGSize, searchText: Binding<String>, selectedTab: Binding<Tab>) -> some View {
    HStack(spacing: 10) {
        VStack(alignment: .leading, spacing: 5) {
            
            // Welcome title
            Text("Welcome!")
                .font(.title.bold())
            
            // User name subtitle
            Text("Tahani Ayman")
                .font(.callout)
                .foregroundStyle(.gray)
            
            // Custom search and filter UI
            SearchAndFilterBar(
                searchText: searchText,
                selectedTab: selectedTab
            )
        }
    }
    .padding(.bottom, 5)
    .background {
        VStack(spacing: 0) {
            // Translucent background material
            Rectangle()
                .fill(.ultraThinMaterial)
        }
        // Extend the background to cover the horizontal and top safe areas
        .padding(.horizontal, -15)
        .padding(.top, -(safeArea.top + 15))
    }
}

/// A computed property to get the device's current safe area insets.
/// Useful for layout adjustments, especially at the top of the screen.
var safeArea: UIEdgeInsets {
    if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
        return windowScene.keyWindow?.safeAreaInsets ?? .zero
    }
    return .zero
}
