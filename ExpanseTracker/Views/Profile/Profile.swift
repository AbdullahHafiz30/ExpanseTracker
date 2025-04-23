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
    @State var userName = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    var userId: String
    @State var userBudget: Double = 100
    @State var userSpend: Double = 500
    @StateObject var budgetViewModel = BudgetViewModel()
    @ObservedObject var auth: AuthViewModel
    @State var showAlert: Bool = false
    let notificationToggleKey = "notificationsEnabled"
    @State private var notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    @State private var showSettingsAlert = false
    @EnvironmentObject var languageManager: LanguageManager
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    @State private var selectedLanguageIndex: Int = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var isDeleting: Bool = false
    var coreViewModel = CoreDataHelper()
    @State var user: User? = nil
    // MARK: - UI Design
    var body: some View {
        ZStack{
            NavigationStack {
                VStack(alignment: .leading){
                    Text(String(format: "Hello".localized(using: currentLanguage), userName))
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
                                
                                HStack{
                                    if !isArabic{
                                        Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    
                                    Text("\(String(format: "%.1f", userBudget))")
                                    
                                    if isArabic{
                                        Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                
                                // set budget pop up
                                Text("Budget".localized(using: currentLanguage))
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
                                
                                HStack{
                                    if !isArabic{
                                        Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    
                                    Text("\(String(format: "%.1f", userSpend))")
                                    
                                    if isArabic{
                                        Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    
                                }
                                Text("YourSpend".localized(using: currentLanguage))
                                    .bold()
                                    .offset(x: currentLanguage == "en" ? -30 : -50 ,y: -30)
                            }
                        }
                    }
                    
                    ScrollView{
                        Section {
                            HStack {
                                NavigationLink(destination: ViwAndEditAccountInformation(userId: userId, currentLanguage: currentLanguage, user: $user, isEdit: false)) {
                                    Image(systemName: "gearshape")
                                    Text("AccountInformation".localized(using: currentLanguage))
                                    
                                    Spacer()
                                    
                                    Image(systemName: currentLanguage == "en" ? "chevron.right" : "chevron.left")
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
                                Text(themeManager.isDarkMode ? "LightMode".localized(using: currentLanguage) : "DarkMode".localized(using: currentLanguage))
                                
                                Spacer()
                                
                                Toggle("", isOn: $themeManager.isDarkMode)
                                    .tint(themeManager.isDarkMode ? .white.opacity(0.3) : .black)
                                    .onChange(of: themeManager.isDarkMode) { _, isOn in
                                        UserDefaults.standard.set(isOn, forKey: "isDarkMode")
                                    }
                                
                            }
                            Divider()
                                .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                        }
                        .padding(.horizontal,5)
                        .padding(.top, 10)
                        
                        Section {
                            HStack {
                                Image(systemName: notificationsEnabled ? "bell" :"bell.slash")  // Icon changes based on mode
                                Text("Notifications".localized(using: currentLanguage))
                                
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
                                                    title: "NewMonth".localized(using: currentLanguage),
                                                    body: "MonthPaln".localized(using: currentLanguage)
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
                        .alert(isPresented: $showSettingsAlert) {
                            Alert(
                                title: Text("NotificationsDisabled".localized(using: currentLanguage)),
                                message: Text("NotificationSettings".localized(using: currentLanguage)),
                                primaryButton: .default(Text("OpenSettings".localized(using: currentLanguage))) {
                                    if let appSettings = URL(string: UIApplication.openSettingsURLString),
                                       UIApplication.shared.canOpenURL(appSettings) {
                                        UIApplication.shared.open(appSettings)
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancel".localized(using: currentLanguage)))
                            )
                        }
                        
                        Section{
                            HStack {
                                Image(systemName: "globe")
                                Text("Language".localized(using: currentLanguage))
                                
                                
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
                                Text("Logout".localized(using: currentLanguage))
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
                                Text("DeleteAccount".localized(using: currentLanguage))
                            }.onTapGesture {
                                showAlert.toggle()
                            }
                            
                            Divider()
                                .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                        }
                        .padding(.horizontal,5)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Sure".localized(using: currentLanguage)), message: Text("DeleteAccountMessage".localized(using: currentLanguage)), primaryButton: .destructive(Text("Delete".localized(using: currentLanguage))){
                                isDeleting = true
                                //delete from firebase
                                    auth.deleteUserAccount(email: userEmail, password: userPassword) { result in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success:
                                                // Delete from CoreData
                                                CoreDataHelper().deleteUser(userId: userId,password: userPassword)
                                                // Reset app state
                                                isDeleting = false
                                                backHome = true
                                                
                                            case .failure(_):
                                                isDeleting = false
                                                AlertManager.shared.showAlert(title: "Error", message: "Account deletion failed!")
                                            }
                                        }
                                    }
                                
                            } , secondaryButton: .cancel(Text("Cancel".localized(using: currentLanguage))))
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding()
                }
            }
            .onAppear{
                // MARK: - Get user information from core
                // Fetch the user from Core Date using user id
                DispatchQueue.global(qos: .userInitiated).async {
                    user = coreViewModel.fetchUserFromCoreData(uid: userId)
                    // Fetch the Current Month Budget from Core Date using user id
                    let budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId)
                    let spend = budgetViewModel.getUserSpending(userId: userId)
                    DispatchQueue.main.async {
                        // Assign its properties to local state variables
                        userName = user?.name ?? "Guest"
                        userEmail = user?.email ?? ""
                        userPassword = user?.password ?? ""
                        userBudget = budget?.amount ?? 0.0
                        userSpend = spend
                    }
                }
                
                // Set the badge count of the app icon to 0
                UNUserNotificationCenter.current().setBadgeCount(0) { error in
                    if let error = error {
                        print("Error setting badge: \(error)")
                    }
                }
                
                // Retrieve the value of whether notifications are enabled from UserDefaults
                notificationsEnabled =  UserDefaults.standard.bool(forKey: "notificationsEnabled")
                print("notificationsEnabled: \(notificationsEnabled)")
                
                if let index = languageManager.supportedLanguages.firstIndex(of: currentLanguage) {
                    selectedLanguageIndex = index
                    isArabic = currentLanguage == "ar"
                } else {
                    let defaultLanguage = "en"
                    if let defaultIndex = languageManager.supportedLanguages.firstIndex(of: defaultLanguage) {
                        selectedLanguageIndex = defaultIndex
                        currentLanguage = defaultLanguage
                        isArabic = false
                        languageManager.setLanguage(defaultLanguage)
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                SetBudget(isPresented: $isPresented, userId: userId, budgetAmount: userBudget)
            }
            .onChange(of: isPresented) { oldValue, newValue in
                if !newValue {
                    if let budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId) {
                        userBudget = budget.amount
                    }
                }
            }
            .onChange(of: isArabic) { _ , value in
                let languageCode = value ? "ar" : "en"
                languageManager.setLanguage(languageCode)
                currentLanguage = languageCode
                if let index = languageManager.supportedLanguages.firstIndex(of: languageCode) {
                    selectedLanguageIndex = index
                }
            }

            if isDeleting {
                ProgressView("Deleting".localized(using: currentLanguage))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
        //cover the whole page with the welcome page
        .fullScreenCover(isPresented: $backHome) {
            WelcomePage(auth:auth)
        }
    }
}


