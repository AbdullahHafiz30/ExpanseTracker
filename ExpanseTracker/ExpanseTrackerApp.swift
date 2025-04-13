//
//  ExpanseTrackerApp.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 27/09/1446 AH.
//
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var themeManager = ThemeManager()

  var body: some Scene {
    WindowGroup {
      NavigationView {
          WelcomePage()
                      .environmentObject(themeManager)
                                      .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
      }
    }
  }
}



