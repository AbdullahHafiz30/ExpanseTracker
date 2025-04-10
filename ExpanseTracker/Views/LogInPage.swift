//
//  LogInPage.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

struct LogInPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var goHome = false
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        NavigationStack{
            ZStack{
                themeManager.backgroundColor
                    .ignoresSafeArea()
                VStack{
                    
                    //logo
                    HStack() {
                        Button(action: {
                            goHome.toggle()
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
                    
                    //image
                    Image(themeManager.isDarkMode ?  "loginW":"loginB")
                        .resizable()
                        .frame(width: 300,height: 300)
                        .padding(-40)
                    
                    //text
                    Text("Log in")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(themeManager.textColor)
                        .padding()
                    
                    //Custom Text feild
                    VStack(spacing: 20) {
                        
                        CustomTextField(
                            placeholder: "Email",
                            text: $email
                        )
                        CustomTextField(
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                        //Cutsom button
                        CustomButton(
                            title: "Login",
                            action: {}
                        )
                        
                    }
                    .padding()
                    Spacer()
                    
                    //navigation to sign up
                    HStack{
                        Text("You don't have an account?")
                            .foregroundColor(themeManager.textColor)
                        Text("Sign Up")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isLoggedIn.toggle()
                            }
                    }
                }
                
            }
        }
        //cover the whole page with the sign up page
        .fullScreenCover(isPresented: $isLoggedIn) {
            SignUpPage()
        }
        //cover the whole page with the welcome page
        .fullScreenCover(isPresented: $goHome) {
            WelcomePage()
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
