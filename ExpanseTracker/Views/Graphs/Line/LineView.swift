//
//  LineView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct LineView: View {
    /// ViewModel handling data retrieval and processing for the line chart
    @ObservedObject var viewModel = LineViewModel()
    
    // MARK: - State & Bindings
    
    /// Data points for daily balance chart
    @State private var lineChartData: [DailyBalance] = []
    
    /// Whether “All Categories” is selected (affects filtering)
    @Binding var allSelect : Bool
    
    /// Optional specific category filter (nil = all)
    @Binding var selectedType: CategoryType?
    
    /// Date granularity (monthly vs. yearly)
    @Binding var selectedTab: DateTab
    
    /// Filter month index (1 = January)
    @Binding var selectedMonth: Int
    
    /// Filter year value
    @Binding var selectedYear: Int
    
    /// Current user identifier for fetching transactions
    var userId: String
    
    /// Access to global theme settings (light/dark mode)
    @EnvironmentObject var themeManager: ThemeManager
    
    /// Language code for localization lookups
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    
    // MARK: - View Body

    var body: some View {
        
        // Placeholder image for empty data sets
        let image = Image("noData")
        
        VStack{
            // Show placeholder when there's no data to chart
            if lineChartData.isEmpty {
                image
                    .resizable()
                    .scaledToFit()
                Text("NoDataFound".localized(using: currentLanguage))
            } else {
                // Render line chart with balance over time
                Chart{
                    ForEach(lineChartData) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date, unit: .day),
                            y: .value("Balance", dataPoint.balance)
                        )
                        // Color line based on theme
                        .foregroundStyle(themeManager.isDarkMode ? .cyan : .blue)
                    }
                }
                // Move Y axis to the leading edge for readability
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding(.vertical)
                
                // Legend for income vs. expense trend
                HStack{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                    
                    Text("Income".localized(using: currentLanguage))
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chart.line.downtrend.xyaxis")
                        .font(.title2)
                    Text("Expense".localized(using: currentLanguage))
                        .font(.title3)
                    
                }.padding()
            }
        }
        // MARK: - Lifecycle & Data Refresh
                
        // Initial data load on appear
        .onAppear() {
            updateChartData()
        }
        // Refresh when any filter changes
        .onChange(of: allSelect) {updateChartData() }
        .onChange(of: selectedType) {updateChartData() }
        .onChange(of: selectedTab) {updateChartData() }
        .onChange(of: selectedMonth) {updateChartData() }
        .onChange(of: selectedYear) {updateChartData() }
    }
    
    // MARK: - Data Fetch
        
    /// Invokes ViewModel to retrieve chart data based on current filters.
    private func updateChartData() {
        lineChartData = viewModel.getLineChartData(
            allSelect: allSelect,
            selectedTab: selectedTab,
            selectedType: selectedType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            userId: userId
        )
    }
    
}
