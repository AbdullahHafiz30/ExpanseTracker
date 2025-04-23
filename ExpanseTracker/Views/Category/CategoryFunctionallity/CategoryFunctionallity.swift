//
//  Category.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 19/10/1446 AH.
//

import SwiftUI

struct CategoryFunctionallity: View {
    // MARK: - Variables
    @State var iconViewModel = IconModel()
    @StateObject var categoryViewModel = CategoryFunctionallityViewModel()
    @State private var color: Color = .black
    @State private var limit: Double = 1
    @State private var userBudget: Double = 0
    @State private var selectedIcon: String = "star"
    @State private var categoryName: String = ""
    @State private var showIcons: Bool = false
    @State private var showColorPicker: Bool = false
    @State var categoryType: CategoryType = .other
    @EnvironmentObject var themeManager: ThemeManager
    @Namespace var animation
    var id: String
    @State private var showNameAlert: Bool = false
    var userId: String
    @Environment(\.dismiss) var dismiss
    @StateObject var budgetViewModel = BudgetViewModel()
    @StateObject private var alertManager = AlertManager.shared
    var type: String
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    // MARK: - UI Design
    var body: some View {
        NavigationStack {
            VStack {
                // Title
                CustomBackward(title: type == "Add" ? "AddCategory".localized(using: currentLanguage) : "EditCategory".localized(using: currentLanguage), tapEvent: {dismiss()})
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 30) {
                    // Category Name and Icon
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : themeManager.isDarkMode ? color.opacity(0.3) : color.opacity(0.1))
                                .frame(width: 75, height: 75)
                                .cornerRadius(10)
                            
                            Image(systemName: selectedIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
                        }
                        .padding(5)
                        
                        CustomTextField(placeholder: "CategoryName".localized(using: currentLanguage), text: $categoryName,isSecure: .constant(false))
                        
                        
                    }
                    
                    // Category Icon Selection
                    HStack {
                        Text("CategoryIcon".localized(using: currentLanguage))
                        Spacer()
                        Image(systemName: selectedIcon)
                            .resizable()
                            .foregroundColor(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
                            .frame(width: 25, height: 25)
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        showIcons.toggle()
                    }
                    
                    // Color Picker
                    HStack{
                        Text("CategoryColor".localized(using: currentLanguage))
                        Spacer()
                        
                        ZStack{
                            Circle()
                                .stroke(LinearGradient(colors: [.red,.yellow ,.green ,.cyan, .blue,.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                .frame(width: 27, height: 27)
                            Circle()
                                .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
                                .frame(width: 20, height: 20)
                            
                        }
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        showColorPicker.toggle()
                    }
                    
                    
                    Text("CategoryType".localized(using: currentLanguage))
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        // Split into chunks of 2 types per row
                        ForEach(Array(CategoryType.allCases.chunked(into: 2)), id: \.self) { rowItems in
                            HStack(spacing: 5) {
                                ForEach(rowItems, id: \.self) { type in
                                    Text(type.rawValue.localized(using: currentLanguage))
                                        .font(.callout)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(categoryType.rawValue == type.rawValue ? (themeManager.isDarkMode ? .black : .white) : (themeManager.isDarkMode ? .white : .black))
                                        .background {
                                            if categoryType.rawValue == type.rawValue {
                                                Capsule()
                                                    .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3)  : color)
                                                    .matchedGeometryEffect(id: "Type", in: animation)
                                            } else {
                                                Capsule()
                                                    .stroke(.gray)
                                            }
                                        }
                                        .contentShape(Capsule())
                                        .onTapGesture {
                                            withAnimation {
                                                categoryType = type
                                                print(categoryType)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("BudgetLimit".localized(using: currentLanguage))
                        
                        Spacer()
                        
                        if currentLanguage == "en" {
                            Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                       
                        Text(String(format: "%.0f", floor(userBudget * (limit / 100))))
                        
                        if currentLanguage == "ar" {
                            Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                       
                    }
                    .padding(.horizontal)
                    
                    // Category Limit Slider
                    HStack (spacing: 20){
                        
                        Slider(value: $limit, in: 1...100)
                            .tint(themeManager.isDarkMode && color == .black ? .blue.opacity(0.3) : color)
                        
                        Text("\(String(format: "%.0f",limit))%")
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.top)
                
                Spacer()
                // MARK: - Add category button
                CustomButton(title: type == "Add" ? "Add".localized(using: currentLanguage) : "Save".localized(using: currentLanguage), action: {
                    
                    guard userBudget != 0.0 else {
                        AlertManager.shared.showAlert(title: "Error".localized(using: currentLanguage), message: "SetYourBudget".localized(using: currentLanguage))
                        return
                    }
                    
                    guard !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        AlertManager.shared.showAlert(title: "Error".localized(using: currentLanguage), message: "CategoryNameRequired".localized(using: currentLanguage))
                        return
                    }
                    
                    // Create category object
                    let category = Category(
                        id: type == "Add" ? UUID().uuidString : id,
                        name: categoryName,
                        color: UIColor(color).toHexString(),
                        icon: selectedIcon,
                        categoryType: categoryType,
                        budgetLimit: floor(userBudget * (limit / 100))
                    )
                    
                    let (isExist, message) = categoryViewModel.checkCategoryExist(category: category, userId: userId, userBudget: userBudget)
                    
                    if isExist {
                        AlertManager.shared.showAlert(title: "Error".localized(using: currentLanguage), message: message)
                    } else {
                        if type == "Add" {
                            categoryViewModel.saveCategoryToCoreData(category: category, userId: userId)
                        }
                        
                        categoryViewModel.saveEditedCategory(category: category, userId: userId)
                        
                        dismiss()
                    }
                })
                
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear{
                // Fetch the Current Month Budget from Core Date using user id
                let budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId)
                // Assign its properties to local state variables
                userBudget = budget?.amount ?? 0.0
                
                if type != "Add" {
                   if let categoryDate = categoryViewModel.fetchCategoryFromCoreDataWithId(categoryId: id, userId: userId) {
                        
                        // If found assign its properties to local state variables
                        categoryName = categoryDate.name ?? ""
                        selectedIcon = categoryDate.icon ?? ""
                        color = UIColor().colorFromHexString(categoryDate.color ?? "")
                        categoryType = categoryDate.categoryType ?? .other
                        if userBudget != 0 {
                            limit = ((categoryDate.budgetLimit ?? 1.0) / userBudget) * 100
                        } else {
                            limit = 0
                        }
                    } else {
                        print("Category not found.")
                    }
                }
                
            }
            .sheet(isPresented: $showIcons) {
                IconPicker(selectedIcon: $selectedIcon, color: $color)
            }
            .sheet(isPresented: $showColorPicker) {
                ColorsPicker(selectedColor: $color)
                
            }
            .alert(isPresented: $alertManager.alertState.isPresented) {
                Alert(
                    title: Text(alertManager.alertState.title),
                    message: Text(alertManager.alertState.message),
                    dismissButton: .default(Text("OK".localized(using: currentLanguage))))
            }
        }
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
}


