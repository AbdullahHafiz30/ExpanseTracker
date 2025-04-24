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
    @State private var signedUp = false
    @State private var isLoading = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var auth: AuthViewModel
    @State private var isPasswordSecure: Bool = true
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
                            .frame(width: 300,height: 300)
                            .padding(.top,-20)
                    }.padding(.top,-15)
                    
                    // Text
                    Text("LogIn".localized(using: currentLanguage))
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(themeManager.textColor)
                        .padding()
                        .padding(.top,-30)
                    
                    // Custom Text feild
                    VStack(spacing: 20) {
                        CustomTextField(
                            placeholder: "Email".localized(using: currentLanguage),
                            text: $email,
                            isSecure:.constant(false)
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
                        // Cutsom button
                        CustomButton(
                            title: "LogIn".localized(using: currentLanguage),
                            action: {
                                DispatchQueue.main.async {
                                    isLoading = true
                                    // Firebase login
                                    auth.logIn(email: email, password: password) { success, message in
                                        isLoading = false
                                        if success {
                                            goToHome = true
                                        }
                                    }
                                }
                            }
                        )
                        .disabled(isLoading)
                        
                    }
                    .padding()
                    .padding(.bottom,70)
                    // Navigation to sign up
                    HStack{
                        Text("DHaveAccount".localized(using: currentLanguage))
                            .foregroundColor(themeManager.textColor)
                        Text("SignUp2".localized(using: currentLanguage))
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
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
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
        NavigationLink(
            destination: SignUpPage(auth:auth),
                    isActive: $isLoggedIn,
                    label: {
                        EmptyView()
                    }
        )
        
    }
}
