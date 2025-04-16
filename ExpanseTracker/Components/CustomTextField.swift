//
//  CustomTextField.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI
// Reuseable text feild
// So i can change the color of placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

struct CustomTextField: View {
    //MARK: - Variables 
    var placeholder: String
    @Binding var text: String
    // If it is for a password then this will be true
    @Binding var isSecure: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        //MARK: - View
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
