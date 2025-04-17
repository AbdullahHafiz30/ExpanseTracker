////
////  EditCategory.swift
////  ExpensesMonthlyProjrct
////
////  Created by Rayaheen Mseri on 12/10/1446 AH.
////
//
//import SwiftUI
//
//struct EditCategory: View {
//    // MARK: - Variables
//    @State var viewModel = IconModel()
//    @StateObject var categoryViewModel = EditCategoryViewModel()
//    @State private var color: Color = .black
//    @State private var limit: Double = 1
//    @State private var userBudget: Double = 0
//    @State private var selectedIcon: String = "star"
//    @State private var categoryName: String = ""
//    @State private var showIcons: Bool = false
//    @State private var showColorPicker: Bool = false
//    @State var categoryType: CategoryType = .other
//    var id: String
//    @EnvironmentObject var themeManager: ThemeManager
//    @Namespace var animation
//    @State private var showNameAlert: Bool = false
//    @StateObject var budgetViewModel = BudgetViewModel()
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var alertManager = AlertManager.shared
//    var userId: String
//    // MARK: - UI Design
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // Title
//                CustomBackward(title: "Edit Category", tapEvent: {dismiss()})
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                VStack(alignment: .leading, spacing: 30) {
//                    // Category Name and Icon
//                    HStack {
//                        ZStack {
//                            Rectangle()
//                                .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : themeManager.isDarkMode ? color.opacity(0.3) : color.opacity(0.1))
//                                .frame(width: 75, height: 75)
//                                .cornerRadius(10)
//                            
//                            Image(systemName: selectedIcon)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 40, height: 40)
//                                .foregroundColor(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
//                        }
//                        .padding(5)
//                        
//                        CustomTextField(placeholder: "Category Name", text: $categoryName,isSecure: .constant(false))
//                        
//                        
//                    }
//                    
//                    // Category Icon Selection
//                    HStack {
//                        Text("Category Icon")
//                        Spacer()
//                        Image(systemName: selectedIcon)
//                            .resizable()
//                            .foregroundColor(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
//                            .frame(width: 25, height: 25)
//                    }
//                    .padding(.horizontal)
//                    .onTapGesture {
//                        showIcons.toggle()
//                    }
//                    
//                    // Color Picker
//                    HStack{
//                        Text("Category Color")
//                        Spacer()
//                        
//                        ZStack{
//                            Circle()
//                                .stroke(LinearGradient(colors: [.red,.yellow ,.green ,.cyan, .blue,.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
//                                .frame(width: 27, height: 27)
//                            Circle()
//                                .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
//                                .frame(width: 20, height: 20)
//                            
//                        }
//                    }
//                    .padding(.horizontal)
//                    .onTapGesture {
//                        showColorPicker.toggle()
//                    }
//                    
//                    
//                    Text("Category Type")
//                        .padding(.horizontal)
//                    
//                    VStack(spacing: 10) {
//                        // Split into chunks of 2 types per row
//                        ForEach(Array(CategoryType.allCases.chunked(into: 2)), id: \.self) { rowItems in
//                            HStack(spacing: 5) {
//                                ForEach(rowItems, id: \.self) { type in
//                                    Text(LocalizedStringKey(type.rawValue))
//                                        .font(.callout)
//                                        .padding(.vertical, 8)
//                                        .frame(maxWidth: .infinity)
//                                        .foregroundColor(categoryType.rawValue == type.rawValue ? (themeManager.isDarkMode ? .black : .white) : (themeManager.isDarkMode ? .white : .black))
//                                        .background {
//                                            if categoryType.rawValue == type.rawValue {
//                                                Capsule()
//                                                    .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3)  : color)
//                                                    .matchedGeometryEffect(id: "Type", in: animation)
//                                            } else {
//                                                Capsule()
//                                                    .stroke(.gray)
//                                            }
//                                        }
//                                        .contentShape(Capsule())
//                                        .onTapGesture {
//                                            withAnimation {
//                                                categoryType = type
//                                            }
//                                        }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    HStack{
//                        Text("Budget Limit")
//                            .padding(.horizontal)
//                        
//                        Spacer()
//                        
//                        Text(String(format: "%.0f", userBudget * (limit / 100)))
//                    }
//                    
//                    // Category Limit Slider
//                    HStack (spacing: 20){
//                        
//                        Slider(value: $limit, in: 1...100)
//                            .tint(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
//                        
//                        Text("\(Int(limit))%")
//                    }
//                    .padding(.horizontal)
//                    
//                }
//                .padding(.top)
//                
//                Spacer()
//                // MARK: - Save edited catrgory information button
//                CustomButton(title: "Save", action: {
//                    guard !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//                        showNameAlert = true
//                        return
//                    }
//                    
//                    // Create a new Category object to hold the updated/edited data
//                    let category = Category(
//                        id: id,
//                        name: categoryName,
//                        color: UIColor(color).toHexString(),
//                        icon: selectedIcon,
//                        categoryType: categoryType,
//                        budgetLimit: userBudget * (limit / 100)
//                    )
//                    
//                })
//                
//            }
//            .padding(.horizontal)
//            .sheet(isPresented: $showIcons) {
//                IconPicker(selectedIcon: $selectedIcon, color: $color)
//            }
//            .sheet(isPresented: $showColorPicker) {
//                ColorsPicker(selectedColor: $color)
//                
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            // MARK: - Get user information from core
//            // Fetch the category from Core Date using (category id , user id)
//            if let category = categoryViewModel.fetchCategoryFromCoreDataWithId(categoryId: id, userId: userId) {
//                // Fetch the Current Month Budget from Core Date using user id
//                let budget = budgetViewModel.fetchCurrentMonthBudget(userId: userId)
//                // Assign its properties to local state variables
//                userBudget = budget?.amount ?? 1.0
//                
//                // If found assign its properties to local state variables
//                categoryName = category.name ?? ""
//                selectedIcon = category.icon ?? ""
//                color = colorFromHexString(category.color ?? "")
//                categoryType = category.categoryType ?? .other
//                limit = ((category.budgetLimit ?? 1.0) / userBudget) * 100
//            } else {
//                print("Category not found.")
//            }
//            
//        }
//        .alert(isPresented: $alertManager.alertState.isPresented) {
//            Alert(
//                title: Text(alertManager.alertState.title),
//                message: Text(alertManager.alertState.message),
//                dismissButton: .default(Text("OK")))
//        }
//    }
//}
////// MARK: - Functions
////func colorFromHexString(_ hex: String) -> Color {
////    // Remove whitespace, newlines, and make the string uppercase
////    var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
////    
////    // Remove the "#" symbol at the beginning if it exists
////    if hexFormatted.hasPrefix("#") {
////        hexFormatted.remove(at: hexFormatted.startIndex)
////    }
////    
////    // Check if the cleaned string is not exactly 6 characters
////    if hexFormatted.count != 6 {
////        return Color.gray // default fallback
////    }
////    
////    // Create a scanner instance that will read from the hexFormatted string and tries to convert the hex string into an integer and store it in rgbValue
////    var rgbValue: UInt64 = 0
////    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
////    
////    // Extract the red, green, and blue components from the hex value
////    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
////    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
////    let blue = Double(rgbValue & 0x0000FF) / 255.0
////    
////    // Return a SwiftUI Color with the RGB values
////    return Color(red: red, green: green, blue: blue)
////}
//
