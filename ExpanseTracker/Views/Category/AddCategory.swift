//
//  AddCategory.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//


import SwiftUI

struct AddCategory: View {
    @State var iconViewModel = IconModel()
    @StateObject var categoryViewModel = CategoryViewModel()
    @State private var color: Color = .black
    @State private var limit: Double = 1
    @State private var selectedIcon: String = "star"
    @State private var categoryName: String = ""
    @State private var showIcons: Bool = false
    @State private var showColorPicker: Bool = false
    @State var categoryType: CategoryType = .other
    @EnvironmentObject var themeManager: ThemeManager
    @Namespace var animation

    var body: some View {
        NavigationStack {
            VStack {
                // Title
                ZStack {
                    // Background Layer
                    Rectangle()
                        .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : themeManager.isDarkMode ? color.opacity(0.3) : color.opacity(0.1))
                        .frame(width: 220, height: 10)
                        .cornerRadius(5)
                        .offset(y: 10)

                    // Foreground Layer
                    Text("Add Category")
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .font(.largeTitle)
                }
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
                        
                        CustomTextField(placeholder: "Category Name", text: $categoryName,isSecure: .constant(false))
                            
                         
                    }

                    // Category Icon Selection
                    HStack {
                        Text("Category Icon")
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
                        Text("Category Color")
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
                    

                        Text("Category Type")
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        // Split into chunks of 2 types per row
                        ForEach(Array(CategoryType.allCases.chunked(into: 2)), id: \.self) { rowItems in
                            HStack(spacing: 5) {
                                ForEach(rowItems, id: \.self) { type in
                                    Text(LocalizedStringKey(type.rawValue))
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
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)


                    Text("Budget Limit")
                        .padding(.horizontal)
                    // Category Limit Slider
                    HStack (spacing: 20){
                        
                            Slider(value: $limit, in: 1...100)
                                .tint(themeManager.isDarkMode && color == .black ? .blue.opacity(0.3) : color)
                            
                            Text("\(Int(limit))%")
                        }
                        .padding(.horizontal)
 
                }
                .padding(.top)

                Spacer()

                CustomButton(title: "Add", action: {
                    let newCategory = Category(
                          id: UUID().uuidString,
                          name: categoryName,
                          color: UIColor(color).toHexString(),
                          icon: selectedIcon,
                          categoryType: categoryType,
                          budgetLimit: limit
                      )

                      categoryViewModel.saveCategoryToCoreData(category: newCategory)
                })
                
            }
            .padding(.horizontal)
            .sheet(isPresented: $showIcons) {
                IconPicker(selectedIcon: $selectedIcon, color: $color)
            }
            .sheet(isPresented: $showColorPicker) {
                ColorsPicker(selectedColor: $color)
                
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}


#Preview {
    AddCategory()
}
