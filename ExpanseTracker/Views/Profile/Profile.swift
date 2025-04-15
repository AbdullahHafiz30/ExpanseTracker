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
    @State private var backHome = false
    let languageCode = Locale.current.language.languageCode?.identifier
    @State var userName = ""
    @Binding var userId: String
    @State var userBudget: Double = 100
    @State var userSpend: Double = 500
    @StateObject var budgetViewModel = BudgetViewModel()
    @ObservedObject var auth: AuthViewModel
    var body: some View {
        ZStack{
            NavigationStack {
                VStack(alignment: .leading){
                    Text("Hello, \(userName)!")
                        .font(.headline)
                    
                    HStack {
                        ShapeView(usedWaterAmount: CGFloat(userSpend), maxWaterAmount: CGFloat(userBudget))
                        
                        Spacer()
                        
                        VStack(spacing: 25 ){
                            
                            ZStack{
                                Rectangle()
                                    .fill(themeManager.isDarkMode ? .white.opacity(0.2): .gray.opacity(0.05))
                                    .frame(height: 60)
                                    .cornerRadius(10)
                                
                                Text("\(String(format: "%.1f", userBudget)) Riyals")
                                
                                // set budget pop up
                                Text("Budget")
                                    .bold()
                                    .offset(x:-45 ,y: -30)
                            }
                            .onTapGesture {
                                isPresented.toggle()
                            }
                            
                            ZStack {
                                Rectangle()
                                    .fill(themeManager.isDarkMode ? .white.opacity(0.2): .gray.opacity(0.05))
                                    .frame(height: 60)
                                    .cornerRadius(10)
                                
                                Text("\(String(format: "%.1f", userSpend)) Riyals")
                                
                                Text("Your Spend")
                                    .bold()
                                    .offset(x: languageCode == "en" ? -30 : -50 ,y: -30)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Section {
                        HStack {
                            Image(systemName: "gearshape")
                            Text("Account Information")
                            
                            Spacer()
                            NavigationLink(destination: AccountInformation(userId: $userId)) {
                                Image(systemName: languageCode == "en" ? "chevron.right" : "chevron.left")
                                    .foregroundColor(.primary)
                            }
                        }
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding(.horizontal,5)
                    .padding(.top, 10)
                    
                    Section {
                        HStack {
                            Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")  // Icon changes based on mode
                            Text(themeManager.isDarkMode ? "Light Mode" : "Dark Mode")
                            
                            Spacer()
                            
                            Toggle("", isOn: $themeManager.isDarkMode)
                                .tint(themeManager.isDarkMode ? .white.opacity(0.3) : .black)
                            
                        }
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding(.horizontal,5)
                    .padding(.top, 10)
                    
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
                    .padding(.horizontal,5)
                    .padding(.top, 10)
                    
                    Section{
                        HStack {
                            Image(systemName: "globe")
                            Text("Language")
                                
                            
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
                                    Text("AR")
                                        .foregroundColor(isArabic ? themeManager.isDarkMode ? .black : .white : .gray)
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("EN")
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
                        
                        
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding(.horizontal,5)
                    .padding(.top, 10)
                    
                    Section {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                            Text("Logout")  
                        }.onTapGesture {
                            auth.logOut()
                            backHome = true
                        }
                        
                        Divider()
                            .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    }
                    .padding(.horizontal,5)
                    .padding(.top, 10)
                    
                    Spacer()
        
                }
                .padding()
            }
            .onAppear{
<<<<<<< Updated upstream
                let user = CoreDataHelper().fetchUserFromCoreData(uid: userId)
                userName = user?.name ?? "Guest"
                var budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId)
=======
                let userInfo = userViewModel.fetchUserFromCoreDataWithId(id: userId)
                
                userName = userInfo?.name ?? ""
                let budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId)
>>>>>>> Stashed changes
                userBudget = budget?.amount ?? 0.0
                print("User loaded .\(user)")
            }
            .sheet(isPresented: $isPresented) {
                SetBudget(isPresented: $isPresented, userId: $userId, budgetAmount: $userBudget)
            }

        } //cover the whole page with the welcome page
        .fullScreenCover(isPresented: $backHome) {
            WelcomePage(auth:auth)
        }
    }
}
