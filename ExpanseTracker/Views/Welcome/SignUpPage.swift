//
//  SignUpPage.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//

import SwiftUI

struct SignUpPage: View {
    //MARK: - Variables
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoggedIn = false
    @State private var backHome = false
    @State private var goToHome = false
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPasswordSecure: Bool = true
    @State private var isConPasswordSecure: Bool = true
    @State private var isLoading = false
    @State private var errorMessage: String?
    @ObservedObject var auth: AuthViewModel
    @EnvironmentObject var alertManager: AlertManager
    var body: some View {
        //MARK: - View
        NavigationStack{
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
            ZStack{
                themeManager.backgroundColor
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack{
                        // Logo
                        HStack() {
                            Button(action: {
                                backHome.toggle()
                            }) {
                                // Go back to the welcome page
                                Image(systemName: "chevron.left")
                                    .foregroundColor(themeManager.textColor)
                                    .font(.system(size: 18, weight: .medium))
                            }.padding(.top,25)
                                .padding(.trailing,15)
                                .padding()
                            Image(themeManager.isDarkMode ? "logoW":"logoB")
                                .resizable()
                                .frame(width: 220,height: 70)
                                .padding()
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Image
                        Image(themeManager.isDarkMode ?  "loginW":"loginB")
                            .resizable()
                            .frame(width: 280,height: 280)
                            .padding(-40)
                        
                        // Custom Text feild
                        VStack(spacing: 20) {
                            // Text
                            Text("Sign up")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(themeManager.textColor)
                            CustomTextField(
                                placeholder: "Name",
                                text: $username,
                                isSecure: .constant(false)
                            )
                            CustomTextField(
                                placeholder: "Email",
                                text: $email,
                                isSecure: .constant(false)
                            )
                            ZStack(alignment: .trailing) {
                                CustomTextField(
                                    placeholder: "Password",
                                    text: $password,
                                    isSecure: $isPasswordSecure
                                )
                                
                                Button(action: {
                                    isPasswordSecure.toggle()
                                }) {
                                    Image(systemName: isPasswordSecure ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }

                            ZStack(alignment: .trailing) {
                                CustomTextField(
                                    placeholder: "Confirm password",
                                    text: $confirmPassword,
                                    isSecure: $isConPasswordSecure
                                )
                                
                                Button(action: {
                                    isConPasswordSecure.toggle()
                                }) {
                                    Image(systemName: isConPasswordSecure ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 16)
                                }
                            }

                            // Custom button
                            CustomButton(
                                title: "Sign up",
                                action: {
                                    // Create User with Firebase
                                    isLoading = true
                                    auth.signUp(name: username, email: email, password: password,confirmPassword: confirmPassword) { success, message in
                                        isLoading = false
                                        if success {
                                            goToHome = true
                                        } else if let message = message {
                                            alertManager.showAlert(title: "Sign up Failed", message: message)
                                        }
                                    }
                                }
                            )
                            .disabled(isLoading)
                            
                            // Navigation to sign up
                            HStack{
                                Text("Already have an account?")
                                    .foregroundColor(themeManager.textColor)
                                Text("Log in")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        isLoggedIn.toggle()
                                    }
                            }
                        }
                        .padding()
                    }.padding(.bottom,20)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,30)
                }
            }
        }
    }
        }
        //cover the whole page with the sign up page
        .fullScreenCover(isPresented: $isLoggedIn) {
            LogInPage(auth:auth)
        }
        //cover the whole page with the welcome page
        .fullScreenCover(isPresented: $backHome) {
            WelcomePage(auth:auth)
        }
        .navigationBarBackButtonHidden(true)
        
        NavigationLink(
            destination: MainTabView(auth:auth),
                    isActive: $goToHome,
                    label: {
                        EmptyView()
                    }
                )
    }
}

