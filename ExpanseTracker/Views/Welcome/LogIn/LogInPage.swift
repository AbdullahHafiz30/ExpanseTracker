//
//  LogInPage.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//
import SwiftUI

struct LogInPage: View {
    
    //MARK: - Variables
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var backHome = false
    @State private var goToHome = false
    @State private var isLoading = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var auth: AuthViewModel
    @State private var isPasswordSecure: Bool = true
    @StateObject private var alertManager = AlertManager.shared
    
    //MARK: - View
    var body: some View {
        NavigationStack{
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
            ZStack{
                themeManager.backgroundColor
                    .ignoresSafeArea()
                VStack{
                    
                    // Logo
                    HStack() {
                        Button(action: {
                            backHome.toggle()
                        }) {
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
                        .padding(.top,-20)
                    
                    // Image
                    Image(themeManager.isDarkMode ?  "loginW":"loginB")
                        .resizable()
                        .frame(width: 300,height: 300)
                        .padding(-40)
                    
                    // Text
                    Text("Log in")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(themeManager.textColor)
                        .padding()
                    
                    // Custom Text feild
                    VStack(spacing: 20) {
                        
                        CustomTextField(
                            placeholder: "Email",
                            text: $email,
                            isSecure:.constant(false)
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
                        // Cutsom button
                        CustomButton(
                            title: "Login",
                            action: {
                                isLoading = true
                                // Firebase login
                                auth.logIn(email: email, password: password) { success, message in
                                    isLoading = false
                                    if success {
                                        goToHome = true
                                    }
                                }
                            }
                        )
                        .disabled(isLoading)
                        
                    }
                    .padding()
                    Spacer()
                    .padding(.bottom,100)
                    // Navigation to sign up
                    HStack{
                        Text("Don't have an account?")
                            .foregroundColor(themeManager.textColor)
                        Text("Sign Up")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isLoggedIn.toggle()
                            }
                    }
                }.padding(.bottom,20)
                
            }
        }
    }
        } .alert(isPresented: $alertManager.alertState.isPresented) {
            Alert(
                title: Text(alertManager.alertState.title),
                message: Text(alertManager.alertState.message),
                dismissButton: .default(Text("OK")))
        }
        // Cover the whole page with the sign up page
        .fullScreenCover(isPresented: $isLoggedIn) {
            SignUpPage(auth:auth)
        }
        // Cover the whole page with the welcome page
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
