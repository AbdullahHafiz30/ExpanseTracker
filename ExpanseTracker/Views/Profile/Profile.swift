//
//  Profile.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct Profile: View {
    // MARK: - Variables
    @State private var isArabic: Bool = false
    @State var showAccountInformation: Bool = false
    @State var isPresented: Bool = false
    @EnvironmentObject var themeManager: ThemeManager
    @State private var backHome = false
    let languageCode = Locale.current.language.languageCode?.identifier
    @State var userName = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @Binding var userId: String
    @State var userBudget: Double = 100
    @State var userSpend: Double = 500
    @StateObject var budgetViewModel = BudgetViewModel()
    @ObservedObject var auth: AuthViewModel
    @State var showAlert: Bool = false
    let notificationToggleKey = "notificationsEnabled"
    @State private var notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    @State private var showSettingsAlert = false
    // MARK: - UI Design
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
                    
                    ScrollView{
                        Section {
                            HStack {
                                NavigationLink(destination: AccountInformation(userId: $userId)) {
                                    Image(systemName: "gearshape")
                                    Text("Account Information")
                                    
                                    Spacer()
                                    
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
                                Image(systemName: notificationsEnabled ? "bell" :"bell.slash")  // Icon changes based on mode
                                Text("Notifications")
                                
                                Spacer()
                                
                                Toggle(isOn: $notificationsEnabled) {
                                    Text("")
                                }
                                .tint(themeManager.isDarkMode ? .white.opacity(0.3) : .black)
                                        .onChange(of: notificationsEnabled) { _, isOn in
                                            print(isOn)
                                            UserDefaults.standard.set(isOn, forKey: notificationToggleKey)
                                            print(UserDefaults.standard.bool(forKey: "notificationsEnabled"))
                                            if isOn {
                                                NotificationManager.shared.requestPermission { granted in
                                                    if granted {
                                                        NotificationManager.shared.scheduleNotification(
                                                            title: "It's a new month 😍!",
                                                            body: "What is your plan for this month? Has your budget changed 💸😉?"
                                                        )
                                                    } else {
                                                        notificationsEnabled = false
                                                        UserDefaults.standard.set(false, forKey: notificationToggleKey)
                                                        showSettingsAlert = true
                                                    }
                                                }
                                            } else {
                                                NotificationManager.shared.removeAllPendingNotifications()
                                            }
                                        }
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Section {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Delete Account")
                            }.onTapGesture {
                                showAlert = true
                            }
                            
                            Divider()
                                .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                        }
                        .padding(.horizontal,5)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .scrollIndicators(.hidden)
                    .padding()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Are you sure?"), message: Text("Deleting your account will erase all your data."), primaryButton: .destructive(Text("Delete")) {
                    //delete from firebase
                    AuthViewModel().deleteUserAccount(email: userEmail, password: userPassword){ result in
                        switch result {
                        case .success(let message):
                            print(message)
                            backHome = true
                        case .failure(let error):
                            print("Error deleting user: \(error.localizedDescription)")
                        }
                    }
                    //delete from core helper
                    CoreDataHelper().deleteUser(userId: userId)
                } , secondaryButton: .cancel())
            }
            .onAppear{
                // MARK: - Get user information from core
                // Fetch the user from Core Date using user id
                let user = CoreDataHelper().fetchUserFromCoreData(uid: userId)
                
                // Assign its properties to local state variables
                userName = user?.name ?? "Guest"
                userEmail = user?.email ?? ""
                userPassword = user?.password ?? ""
                // Fetch the Current Month Budget from Core Date using user id
                let budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId)
                // Assign its properties to local state variables
                userBudget = budget?.amount ?? 0.0
                print("User loaded .\(String(describing: user))")
                
                // Set the badge count of the app icon to 0
                UNUserNotificationCenter.current().setBadgeCount(0) { error in
                 if let error = error {
                        print("Error setting badge: \(error)")
                    }
                }
                
                // Retrieve the value of whether notifications are enabled from UserDefaults
                notificationsEnabled =  UserDefaults.standard.bool(forKey: "notificationsEnabled")
                print(notificationsEnabled)
            }
            .sheet(isPresented: $isPresented) {
                SetBudget(isPresented: $isPresented, userId: $userId, budgetAmount: $userBudget)
            }
            .alert(isPresented: $showSettingsAlert) {
                Alert(
                    title: Text("Notifications Disabled"),
                    message: Text("To receive reminders, please enable notifications in Settings."),
                    primaryButton: .default(Text("Open Settings")) {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.open(appSettings)
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
            .onChange(of: isPresented) { oldValue, newValue in
                if !newValue {
                    if let budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId) {
                        userBudget = budget.amount
                    }
                }
            }
            
        } //cover the whole page with the welcome page
        .fullScreenCover(isPresented: $backHome) {
            WelcomePage(auth:auth)
        }
    }
}
