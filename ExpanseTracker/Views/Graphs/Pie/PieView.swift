//
//  PieView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct PieView: View {
    
    // ViewModel driving the data retrieval and processing logic for the pie chart
    @ObservedObject var viewModel = PieViewModel()
    
    // Filters and selections passed in from the parent/graphs view:
    @Binding var allSelect : Bool  // Whether “All” categories are selected
    @Binding var selectedType: CategoryType?  // Currently selected category type filter
    @Binding var selectedTab: DateTab  // Date range granularity (monthly/Yearly)
    @Binding var selectedMonth: Int  // Filter month (1–12)
    @Binding var selectedYear: Int  // Filter year (e.g. 2025)
    var userId: String  // Current user identifier
    
    // Local state for chart slice data
    @State var chartData: [Test] = []
    
    // Current language code for localization lookups
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    var body: some View {
        // Placeholder image for “no data” scenarios
        let image = Image("noData")
        
        VStack {
            // Show placeholder when there’s no data to populate the chart
            if chartData.isEmpty {
                image
                    .resizable()
                    .scaledToFit()
                Text("NoDataFound".localized(using: currentLanguage))
            } else {
                // Render the pie chart using Chart & SectorMark from Swift Charts
                Chart(chartData) { data in
                    SectorMark(
                        angle: .value(
                            data.text, // here we put the name of sector
                            data.number // here we put the number
                        ),
                        innerRadius: .ratio(0.6) // Inner radius to create a donut-style chart
                    ).foregroundStyle(UIColor().colorFromHexString(data.color)) // Apply the user-defined color for each slice
                }.chartLegend(.hidden)
                
                VStack {
                    // Custom legend below the chart listing each category
                    ForEach(chartData) { item in
                        HStack {
                            // Legend color indicator
                            Circle()
                                .fill(UIColor().colorFromHexString(item.color))
                                .frame(width: 18, height: 18)
                            // Localized category name
                            Text(item.text.localized(using: currentLanguage))
                                .font(.body)
                                .foregroundColor(.primary)
                            // Percentage label for the slice
                            Spacer()
                            Text(String(format: "%.0f%%", item.percentage))
                        }
                    }
                }
            }
            
        }
        // MARK: - Lifecycle Hooks
        // Fetch or refresh chart data whenever the view appears or any filter changes
        .onAppear{
            updateChartData()
        }
        .onChange(of: allSelect) {updateChartData() }
        .onChange(of: selectedType) {updateChartData() }
        .onChange(of: selectedTab) {updateChartData() }
        .onChange(of: selectedMonth) {updateChartData() }
        .onChange(of: selectedYear) {updateChartData() }
    }
    
    // MARK: - Data Update
    /// Retrieves filtered data from the view model and updates the chartData state.
    private func updateChartData() {
            chartData = viewModel.getData(
                allSelect: allSelect,
                selectedTab: selectedTab,
                selectedType: selectedType,
                selectedMonth: selectedMonth,
                selectedYear: selectedYear,
                userId: userId
            )
        }
}
