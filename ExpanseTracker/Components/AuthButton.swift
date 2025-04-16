//
//  AuthButton.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI
// Custom auth button to be used in the welcome page for log in and sign up 
struct AuthButton: View {
    //MARK: - auth button variables
    let label: String
    let isFilled: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        //MARK: - auth button view
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isFilled ? themeManager.textColor : Color.clear)
                .frame(width: 350, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.textColor, lineWidth: isFilled ? 0 : 1)
                )
            
            Text(label)
                .foregroundColor(isFilled ? themeManager.backgroundColor : .black)
                .bold()
        }
    }
}
