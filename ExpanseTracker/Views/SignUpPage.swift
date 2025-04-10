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
                        text: $username
                    )
                    CustomTextField(
                        placeholder: "Email",
                        text: $email
                    )
                    CustomTextField(
                        placeholder: "Password",
                        text: $password,
                        isSecure: true
                    )
                    CustomTextField(
                        placeholder: "Confirm password",
                        text: $confirmPassword,
                        isSecure: true
                    )
                    //Custom button
                    CustomButton(
                        title: "Sign up",
                        action: {}
                    )
                    
                    //navigation to sign up
                    HStack{
                        Text("You already have an account?")
                            .foregroundColor(themeManager.textColor)
                        Text("Log in")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isLoggedIn.toggle()
                            }
                    }
                }
                .padding()
            }
        }
        }
        //cover the whole page with the sign up page
        .fullScreenCover(isPresented: $isLoggedIn) {
            LogInPage()
        }
        //cover the whole page with the welcome page
        .fullScreenCover(isPresented: $goHome) {
            WelcomePage()
        }
        .navigationBarBackButtonHidden(true)
    }
}
