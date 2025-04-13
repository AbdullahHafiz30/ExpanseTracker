//
//  Profile.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//


//
//  Profile.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct Profile: View {
    @State private var isArabic: Bool = false
    @State var showNotification: Bool = false
    @State var showAccountInformation: Bool = false
    @State var isPresented: Bool = false
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var auth: AuthViewModel
    var body: some View {
        ZStack{
            NavigationStack {
                VStack(alignment: .leading){
                    Text("Hello, Rayaheen!")
                        .font(.headline)
                    
                    HStack {
                        ShapeView()
                        
                        Spacer()
                        
                        VStack(spacing: 25 ){
                            ZStack {
                                Rectangle()
                                    .fill(themeManager.isDarkMode ? .white.opacity(0.2): .gray.opacity(0.05))
                                    .frame(height: 60)
                                    .cornerRadius(10)
                                
                                Text("2000 USD")
                                
                                Text("your spend")
                                    .bold()
                                    .offset(x:-30 ,y: -30)
                            }
                            
                            ZStack{
                                Rectangle()
                                    .fill(themeManager.isDarkMode ? .white.opacity(0.2): .gray.opacity(0.05))
                                    .frame(height: 60)
                                    .cornerRadius(10)
                                
                                Text("5500 USD")
                                
                                // set budget pop up
                                Text("Budget")
                                    .bold()
                                    .offset(x:-45 ,y: -30)
                            }
                            .onTapGesture {
                                isPresented.toggle()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Section {
                        HStack {
                            Image(systemName: "gearshape")
                            Text("Account information")
                            
                            Spacer()
                            NavigationLink(destination: AccountInformation()) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.primary)
                            }
                        }
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding([.horizontal, .top])
                    
                    Section {
                        HStack {
                            Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")  // Icon changes based on mode
                            Text("Dark Mode")
                            
                            Spacer()
                            
                            Toggle("", isOn: $themeManager.isDarkMode)
                                .tint(themeManager.isDarkMode ? .white.opacity(0.3) : .black)
                            
                        }
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding([.horizontal, .top])
                    
                    
                    Section {
                        HStack {
                            Image(systemName: showNotification ? "bell" :"bell.slash")  // Icon changes based on mode
                            Text("Notifications")
                            
                            Spacer()
                            
                            Toggle(isOn: $showNotification) {
                                Text("")
                            }
                            .tint(themeManager.isDarkMode ? .white.opacity(0.3) : .black)
                        }
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding([.horizontal, .top])
                    
                    
                    Section{
                        HStack {
                            Image(systemName: "globe")
                            Text("Language")
                                .font(.headline)
                            
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 120, height: 40)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(themeManager.isDarkMode ? .white : .black)
                                    .frame(width: 60, height: 40)
                                    .offset(x: isArabic ? -30 : 30)
                                    .animation(.easeInOut(duration: 0.3), value: isArabic)
                                
                                HStack {
                                    Text("EN")
                                        .foregroundColor(isArabic ? themeManager.isDarkMode ? .black : .white : .gray)
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("AR")
                                        .foregroundColor(isArabic ? .gray : themeManager.isDarkMode ? .black : .white)
                                        .frame(maxWidth: .infinity)
                                }
                                .font(.subheadline)
                                .frame(width: 120, height: 40)
                                
                                
                            }
                            .onTapGesture {
                                isArabic.toggle()
                            }
                            
                        }
                        .padding()
                        
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                            Text("Logout")
                                .onTapGesture {
                                    auth.logOut()
                                }
                            
                        }
                        
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding([.horizontal, .top])
                    
                    Spacer()
        
                }
                .padding()
            }
            
            if isPresented {
                ZStack {
                    Color.black.opacity(0.65) // Black overlay
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isPresented.toggle()
                        }
                    
                    VStack {
                        SetBudget()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}
