//
//  ExpanseTrackerApp.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 27/09/1446 AH.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var themeManager = ThemeManager()
    @StateObject var localizableManager = LanguageManager()
    // Add persistence controller
    let persistenceController = PersistanceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomePage()
                .environmentObject(localizableManager)
                .environmentObject(themeManager)
                .environmentObject(AlertManager.shared)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
                .environment(\.managedObjectContext, PersistanceController.shared.context)
                
        }
    }
}




