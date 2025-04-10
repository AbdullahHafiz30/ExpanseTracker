//
//  AuthButton.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI
//custom auth button to be used in the welcome page for log in and sign up 
struct AuthButton: View {
    let label: String
    let isFilled: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3.15)
                .fill(isFilled ? themeManager.textColor : Color.clear)
                .frame(width: 350, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 3.15)
                        .stroke(themeManager.textColor, lineWidth: isFilled ? 0 : 1)
                )
            
            Text(label)
                .foregroundColor(isFilled ? themeManager.backgroundColor : .black)
                .bold()
        }
    }
}