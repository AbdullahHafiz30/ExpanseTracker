//
//  ExpanseTrackerApp.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 27/09/1446 AH.
//

import SwiftUI

@main
struct ExpanseTrackerApp: App {
    @StateObject private var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            HomeView()
            .environmentObject(themeManager)
                            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}



