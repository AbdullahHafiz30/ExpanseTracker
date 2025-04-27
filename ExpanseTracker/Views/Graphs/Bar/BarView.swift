//
//  BarView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct BarView: View {
    
    // MARK: - ViewModels
    /// Retrieves bar chart data (Bar structs)
    @ObservedObject var viewModel = BarViewModel()
    
    /// Retrieves pie chart data (Test structs) for legend
    @ObservedObject var viewModel1 = PieViewModel()
    
    // MARK: - State & Bindings
        
    /// Whether “All Categories” is selected
    @Binding var allSelect : Bool
    /// Specific category filter (nil = all)
    @Binding var selectedType: CategoryType?
    /// Date granularity (monthly vs. yearly)
    @Binding var selectedTab: DateTab
    /// Filter month index (1 = January)
    @Binding var selectedMonth: Int
    /// Filter year value
    @Binding var selectedYear: Int
    
    /// Bar chart data points
    @State var chartData: [Bar] = []

    /// Pie chart data used for legend colors and labels
    @State var pieData: [Test] = []
    
    /// Language code for localization
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    /// Current user identifier
    var userId: String
    
    // MARK: - View Body

    var body: some View {
        
        // Placeholder image when no data is available
        let image = Image("noData")
        
        VStack {
            // Show “no data” placeholder if chartData is empty
            if chartData.isEmpty {
                image
                    .resizable()
                    .scaledToFit()
                Text("NoDataFound".localized(using: currentLanguage))
            } else {
                // Render horizontal bar chart
                Chart {
                    ForEach(chartData, id: \.id) { transaction in
                        BarMark(
                            x: .value("category", transaction.text),
                            y: .value("expense", transaction.number),
                            stacking: .standard
                        )
                        // Apply category color to each bar
                        .foregroundStyle(Color(UIColor().colorFromHexString(transaction.color)))
                        
                    }
                }.chartLegend(.hidden)
                    .chartScrollableAxes(.horizontal)
                // Show only 3 bars at a time for readability
                    .chartXVisibleDomain(length: 3)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                
                // Custom legend scroll view using pieData for color swatches
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(pieData) { item in
                            HStack {
                                Circle()
                                    .fill(UIColor().colorFromHexString(item.color))
                                    .frame(width: 18, height: 18)
                                
                                Text(item.text.localized(using: currentLanguage))
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
        }
        // MARK: - Lifecycle & Data Refresh
        .onAppear{
            updateChartData()
        }
        .onChange(of: allSelect) {updateChartData() }
        .onChange(of: selectedType) {updateChartData() }
        .onChange(of: selectedTab) {updateChartData() }
        .onChange(of: selectedMonth) {updateChartData() }
        .onChange(of: selectedYear) {updateChartData() }
    }
    
    
    // MARK: - Data Loading
    /// Fetches both bar and pie data whenever any filter changes.
    private func updateChartData() {
        chartData = viewModel.getData(
            allSelect: allSelect,
            selectedTab: selectedTab,
            selectedType: selectedType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            userId: userId)
        
        pieData = viewModel1.getData(
            allSelect: allSelect,
            selectedTab: selectedTab,
            selectedType: selectedType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            userId: userId)
    }
}
