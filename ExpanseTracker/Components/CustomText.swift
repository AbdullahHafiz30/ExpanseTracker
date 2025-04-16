//
//  CustomText.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A reusable SwiftUI view that displays a labeled text field-like container.
/// - Parameters:
///   - text: The actual text content to display.
///   - placeholder: A label indicating what the content represents.
///   - themeManager: EnvironmentObject used for styling.
struct CustomText: View {
    
    // MARK: - Variables
    var text: String
    var placeholder: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        
        // Outer rounded rectangle with a border
        RoundedRectangle(cornerRadius: 7)
            .stroke(themeManager.textColor, lineWidth: 1)
            .frame(height: 48)
            .overlay(
                
                // HStack to layout placeholder and actual text horizontally
                HStack {
                    
                    // Placeholder label
                    Text(placeholder)
                        .foregroundStyle(.gray)
                    
                    // The actual text value
                    Text(text)
                        .foregroundStyle(themeManager.textColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
            )
    }
}
