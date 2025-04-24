//
//  WelcomePage.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

struct WelcomePage: View {
    
    //MARK: - Variables
    
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var auth = AuthViewModel()
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    //MARK: - Auto navigation
    var body: some View {
        NavigationStack {
            // Auto-navigation to Home if already authenticated
            if auth.isAuthenticated {
                MainTabView(auth:auth)
            } else {
                welcomeBody
            }
        }
        .animation(.smooth, value: themeManager.isDarkMode)
    }
    
    //MARK: - View
    
    // keeps welcome layout separate
    var welcomeBody: some View {
        ZStack {
            themeManager.gradient
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    VStack {
                        Image("logoB")
                            .resizable()
                            .frame(width: 260, height: 90)
                        
                        Image("welcome")
                            .resizable()
                            .frame(width: 330, height: 330)
                        
                        Text("WelcomeMesg".localized(using: currentLanguage))
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                        
                        Text("WelcomeSMesg".localized(using: currentLanguage))
                            .font(.headline)
                            .lineLimit(3)
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        
                        // Navigation to log in and sign up pages with the use of the custom AuthButton
                        NavigationLink(destination: LogInPage(auth:auth)) {
                            AuthButton(label: "LogIn".localized(using: currentLanguage), isFilled: true)
                        }
                        
                        NavigationLink(destination: SignUpPage(auth:auth)) {
                            AuthButton(label: "SignUp".localized(using: currentLanguage), isFilled: false)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
