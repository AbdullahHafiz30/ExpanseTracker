//
//  PieChartView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/10/1446 AH.
//


import SwiftUI

struct GraphsView: View {

    @EnvironmentObject var themeManager: ThemeManager
    @State private var allSelect : Bool = true
    @State private var selectedTab: DateTab = .monthly
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedCategoryType: CategoryType? = nil
    @State var tabSelectedValue = 0
    var userId: String
    
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Statistics".localized(using: currentLanguage))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .font(.custom("Poppins-Bold", size: 36))
                        .fontWeight(.bold)
                }
                
                GraphsViewHeader(
                    allSelect: $allSelect,
                    selectedTab: $selectedTab,
                    selectedMonth: $selectedMonth,
                    selectedYear: $selectedYear,
                    selectedType: $selectedCategoryType,
                    currentLanguage: currentLanguage
                )
                
                VStack {
                    Picker(selection: $tabSelectedValue, label: Text("")) {
                        Text("Pie".localized(using: currentLanguage)).tag(0)
                        Text("Bar".localized(using: currentLanguage)).tag(1)
                        Text("Line".localized(using: currentLanguage)).tag(2)
                        
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    TabView(selection: $tabSelectedValue,
                            content:  {
                        PieView(allSelect: $allSelect, selectedType: $selectedCategoryType, selectedTab: $selectedTab, selectedMonth: $selectedMonth, selectedYear: $selectedYear, userId: userId).tag(0).padding()
                        BarView(allSelect: $allSelect, selectedType: $selectedCategoryType, selectedTab: $selectedTab, selectedMonth: $selectedMonth, selectedYear: $selectedYear, userId: userId).tag(1).padding()
                        LineView(allSelect: $allSelect, selectedType: $selectedCategoryType, selectedTab: $selectedTab, selectedMonth: $selectedMonth, selectedYear: $selectedYear, userId: userId).tag(2).padding()
                    })
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                    
                }
                Spacer()
            }
            .padding(.top)
        }
    }
}


