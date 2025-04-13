//
//  HeaderSection.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable view builder function that creates a header section with a localized title and a back navigation arrow.
/// - Parameters:
///   - title: The localized key for the title displayed in the header.
///   - action: The closure executed when the arrow icon is tapped.
@ViewBuilder
func HeaderSection(title: String, action: @escaping () -> Void) -> some View {
    
    // Get the current language code
    let languageCode = Locale.current.language.languageCode?.identifier
    
    HStack {
        // Navigation arrow
        Image(systemName: languageCode == "en" ? "arrow.left" : "arrow.right")
            .font(.system(size: 22))
            .onTapGesture {
                action() // Trigger the passed action when the arrow is tapped
            }
        
        // Display the localized title
        Text(LocalizedStringKey(title))
            .font(.system(size: 22))
            .bold()
    }
}

