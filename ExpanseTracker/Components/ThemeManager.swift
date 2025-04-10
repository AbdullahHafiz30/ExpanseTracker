//
//  ThemeManager.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    // Colors that adapt to dark/light mode
    var backgroundColor: Color {
        isDarkMode ? Color.black : Color.white
    }
    
    var textColor: Color {
        isDarkMode ? Color.white : Color.black
    }
    
    var gradient: LinearGradient {
        isDarkMode ? 
        LinearGradient(colors: [Color.white, Color.gray.opacity(0.7)], startPoint: .top, endPoint: .bottom) :
            LinearGradient(colors: [Color.gray.opacity(0.7), Color.white], startPoint: .top, endPoint: .bottom)
    }
}