//
//  SignUpPage.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//

import SwiftUI

struct SignUpPage: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoggedIn = false
    @State private var backHome = false
    @State private var goToHome = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var auth: AuthViewModel
    @State private var isPasswordSecure: Bool = true
    @State private var isConPasswordSecure: Bool = true
    var body: some View {
        NavigationStack{
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
            ZStack{
                themeManager.backgroundColor
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack{
                        //logo
                        HStack() {
                            Button(action: {
                                backHome.toggle()
                            }) {
                                //go back to the welcome page
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
                        
                        //image
                        Image(themeManager.isDarkMode ?  "loginW":"loginB")
                            .resizable()
                            .frame(width: 280,height: 280)
                            .padding(-40)
                        
                        //Custom Text feild
                        VStack(spacing: 20) {
                            //text
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

                            //Custom button
                            CustomButton(
                                title: "Sign up",
                                action: {
                                    // Create User with Firebase
                                    auth.signUp(name: username, email: email, password: password, confirmPassword: confirmPassword){ success in
                                        if success {
                                            goToHome = true
                                        }
                                    }
                                    
                                }
                            ).disabled(auth.isLoading)
                            
                            //navigation to sign up
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
            WelcomePage()
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $auth.showAlert) {
                    Alert(title: Text(auth.alertTitle), message: Text(auth.alertMessage), dismissButton: .default(Text("OK")))
                }
        NavigationLink(
            destination: MainTabView(auth:auth),
                    isActive: $goToHome,
                    label: {
                        EmptyView()
                    }
                )
    }
}

