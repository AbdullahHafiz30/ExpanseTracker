//
//  PieChartView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/10/1446 AH.
//


import SwiftUI

struct GraphsView: View {

    
    // MARK: - Environment
    /// Manages app-wide theme (light/dark mode)
    @EnvironmentObject var themeManager: ThemeManager
    // MARK: - State & Bindings
    /// Toggle for “All Categories” filter
    @State private var allSelect : Bool = true
    /// Currently selected date granularity (monthly, yearly)
    @State private var selectedTab: DateTab = .monthly
    /// Month index for filtering (0 = January, 11 = December)
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) - 1
    /// Year for filtering data
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    /// Specific category type filter (nil means all types)
    @State private var selectedCategoryType: CategoryType? = nil
    /// Index for segmented control / tab selection (0: Pie, 1: Bar, 2: Line)
    @State var tabSelectedValue = 0
    /// Identifier for the current user
    var userId: String
    /// Language code for localization
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    // MARK: - View Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // MARK: Page Title
                HStack {
                    // Localized title text
                    Text("Statistics".localized(using: currentLanguage))
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .font(.title.bold())
                        .padding(.leading, 15)
                    Spacer()
                }
                
                // MARK: Filter Header
                GraphsViewHeader(
                    allSelect: $allSelect,
                    selectedTab: $selectedTab,
                    selectedMonth: $selectedMonth,
                    selectedYear: $selectedYear,
                    selectedType: $selectedCategoryType,
                    currentLanguage: currentLanguage
                )
                
                // MARK: Chart Type Selection & Display
                VStack {
                    // Segmented control for choosing chart type
                    Picker(selection: $tabSelectedValue, label: Text("")) {
                        Text("Pie".localized(using: currentLanguage)).tag(0)
                        Text("Bar".localized(using: currentLanguage)).tag(1)
                        Text("Line".localized(using: currentLanguage)).tag(2)
                        
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    // TabView to render the selected chart
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


