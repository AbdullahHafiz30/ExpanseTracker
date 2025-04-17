//
//  CustomTextField.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

/// A reusable custom text field component that adapts to secure or regular input.
/// Uses a placeholder overlay extension to customize placeholder styling.
struct CustomTextField: View {
    
    //MARK: - Variables
    
    var placeholder: String
    @Binding var text: String
    // If it is for a password then this will be true
    @Binding var isSecure: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    //MARK: - View
    var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(themeManager.textColor)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(themeManager.textColor.opacity(0.5))
                    }
            }else {
                TextField(placeholder, text: $text)
                    .foregroundColor(themeManager.textColor)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(themeManager.textColor.opacity(0.5))
                    }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(themeManager.textColor, lineWidth: 1)
        )
    }
}
