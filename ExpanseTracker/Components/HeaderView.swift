//
//  File.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable header view that displays a localized welcome message, the time filter menu, and a custom search bar.
/// - Parameters:
///   - searchText: A binding to the current search text input.
///   - selectedTab: A binding to the selected time filter.
///   - currentLanguage: The current app language code.
@ViewBuilder
func HeaderView(searchText: Binding<String>, selectedTab: Binding<TimeFilter>, currentLanguage: String) -> some View {
    HStack(spacing: 10) {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                // MARK: - Localized Welcome Title
                Text("Welcome".localized(using: currentLanguage))
                    .font(.title.bold())
                
                Spacer()
                
                // MARK: - Time Filter Picker as Menu
                Menu {
                    Picker("Select Time Filter", selection: selectedTab) {
                        ForEach(TimeFilter.allCases, id: \.self) { tab in
                            Text(tab.rawValue.localized(using: currentLanguage)).tag(tab)
                            /*
                             Without .tag(...):
                             The Picker wouldn’t know which case corresponds to which label, so it wouldn’t update selectedTab correctly.
                             */
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.black)
                        .font(.title)
                }
            }
            
            // MARK: - Search Bar
            SearchBar(searchText: searchText)
        }
    }
    .padding(.bottom, 5)
    .background {
        VStack(spacing: 0) {
            // Background layer using system material
            Rectangle()
                .fill(.background) // a system-adaptive background color
        }
        // Expand background to cover the full width and top safe area
        .padding(.horizontal, -15)
        .padding(.top, -(safeArea.top))
    }
}

/// A computed property to get the device's current safe area insets.
var safeArea: UIEdgeInsets {
    if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
        return windowScene.keyWindow?.safeAreaInsets ?? .zero
    }
    return .zero
}
