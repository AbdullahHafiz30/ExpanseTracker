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
    @ObservedObject var auth: AuthViewModel
    @StateObject private var alertManager = AlertManager.shared
    
    //MARK: - View
    var body: some View {
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
                                    // Check name
                                    guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
                                        let message = "Need to add a name"
                                        AlertManager.shared.showAlert(title: "Name is required", message: message)
                                        return
                                    }
                                    // Create User with Firebase
                                    isLoading = true
                                    auth.signUp(name: username, email: email, password: password,confirmPassword: confirmPassword) { success, message in
                                        isLoading = false
                                        if success {
                                            goToHome = true
                                        }
                                    }
                                }
                            )
                            .disabled(isLoading)
                            
                            // Navigation to log in
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
        } .alert(isPresented: $alertManager.alertState.isPresented) {
            Alert(
                title: Text(alertManager.alertState.title),
                message: Text(alertManager.alertState.message),
                dismissButton: .default(Text("OK"))
        )}
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
        NavigationLink(
            destination: LogInPage(auth:auth),
                    isActive: $isLoggedIn,
                    label: {
                        EmptyView()
                    }
        )
    }
}

