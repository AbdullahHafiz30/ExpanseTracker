//
//  WelcomePage.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

struct WelcomePage: View {
    @State private var navigateToLogin = false
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var auth = AuthViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                //the background color
                themeManager.gradient
                    .ignoresSafeArea()
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                VStack{
                    //logo
                    Image("logoB")
                        .resizable()
                        .frame(width: 260,height: 90)
                    
                    //image
                    Image("welcome")
                        .resizable()
                        .frame(width: 350,height: 350)
                    
                    //welcome message
                    Text("   Welcome to SpendSmartly")
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(2)
                        .padding()
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                    //caption
                    Text("Make your expense tracking experience more better today.")
                        .font(.headline)
                        .lineLimit(3)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    //log in button
                    NavigationLink( destination: LogInPage(auth:auth)) {
                        AuthButton(label: "Log in", isFilled: true)
                    }
                    
                    //sign up button
                    NavigationLink( destination: SignUpPage(auth: auth)) {
                        AuthButton(label: "Sign up", isFilled: false)
                    }
                    //dark mood toggle
                    //NOTE: this should be in the profile page

                    //                    Toggle("Dark Mode", isOn: $themeManager.isDarkMode)
                    //                                            .padding()
                    //                                            .tint(.black)
                    
                    
                }.padding(.bottom,20)

//                    Toggle("Dark Mode", isOn: $themeManager.isDarkMode)
//                                            .padding()
//                                            .tint(.black)

                }

            }
        }
    }
        }.animation(.smooth, value: themeManager.isDarkMode)
        
    }
}
