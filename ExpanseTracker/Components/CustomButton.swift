//
//  CustomButton.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI
// Custom button to be used everywhere we need
struct CustomButton: View {
<<<<<<< Updated upstream
    //MARK: - Variables
=======
    // MARK: - Variables
>>>>>>> Stashed changes
    var title: String
    var action: () -> Void = {}
    var cornerRadius: CGFloat = 8
    @EnvironmentObject var themeManager: ThemeManager
    // To manage the colors of the background and text
    private var backgroundColor: Color {
        themeManager.isDarkMode ? .white : .black
    }
    
    private var foregroundColor: Color {
        themeManager.isDarkMode ? .black : .white
    }
    
    var body: some View {
        //MARK: - View
        // The button
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(foregroundColor)
                .padding()
                .frame(width: 170)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(themeManager.textColor.opacity(0.2), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}
