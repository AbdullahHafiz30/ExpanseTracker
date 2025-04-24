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
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    //MARK: - View
    var body: some View {
        NavigationStack{
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ZStack{
                        themeManager.backgroundColor
                            .ignoresSafeArea()
                        ScrollView(showsIndicators: false) {
                            VStack{
                                VStack(alignment: .center){
                                    // Logo
                                    HStack{
                                        CustomBackward(title:"".localized(using: currentLanguage)){
                                            backHome.toggle()
                                        }.offset(y: 10)
                                        Image(themeManager.isDarkMode ? "logoW":"logoB")
                                            .resizable()
                                            .frame(width: 220,height: 70)
                                            .padding()
                                    }.padding(.trailing, 40)
                                    
                                    // Image
                                    Image(themeManager.isDarkMode ?  "loginW":"loginB")
                                        .resizable()
                                        .frame(width: 280,height: 280)
                                        .padding(.top,-20)
                                }
                                // Custom Text feild
                                VStack(spacing: 20) {
                                    // Text
                                    Text("SignUp".localized(using: currentLanguage))
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(themeManager.textColor)
                                    CustomTextField(
                                        placeholder: "Name".localized(using: currentLanguage),
                                        text: $username,
                                        isSecure: .constant(false)
                                    )
                                    CustomTextField(
                                        placeholder: "Email".localized(using: currentLanguage),
                                        text: $email,
                                        isSecure: .constant(false)
                                    )
                                    ZStack(alignment: .trailing) {
                                        CustomTextField(
                                            placeholder: "Password".localized(using: currentLanguage),
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
                                            placeholder: "ConfirmPassword".localized(using: currentLanguage),
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
                                        title: "SignUp".localized(using: currentLanguage),
                                        action: {
                                            // Check name
                                            guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
                                                let message = "NameRequired".localized(using: currentLanguage)
                                                AlertManager.shared.showAlert(title: "Error".localized(using: currentLanguage), message: message)
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
                                        Text("HaveAccount".localized(using: currentLanguage))
                                            .foregroundColor(themeManager.textColor)
                                        Text("LogIn2".localized(using: currentLanguage))
                                            .foregroundColor(.blue)
                                            .onTapGesture {
                                                isLoggedIn.toggle()
                                            }
                                    }
                                }
                                .padding()
                                .padding(.top,-40)
                            }
                            .padding(.top,-20)
                        }
                    }
                }
            }
        } .alert(isPresented: $alertManager.alertState.isPresented) {
            Alert(
                title: Text(alertManager.alertState.title),
                message: Text(alertManager.alertState.message),
                dismissButton: .default(Text("OK".localized(using: currentLanguage)))
            )}
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
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

