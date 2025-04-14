//
//  WelcomePage.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

struct WelcomePage: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var auth = AuthViewModel()

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
                            .frame(width: 350, height: 350)
                        
                        Text("   Welcome to SpendSmartly")
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(2)
                            .padding()
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                        
                        Text("Make your expense tracking experience more better today.")
                            .font(.headline)
                            .lineLimit(3)
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)

                        NavigationLink(destination: LogInPage(auth: auth)) {
                            AuthButton(label: "Log in", isFilled: true)
                        }

                        NavigationLink(destination: SignUpPage(auth: auth)) {
                            AuthButton(label: "Sign up", isFilled: false)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
