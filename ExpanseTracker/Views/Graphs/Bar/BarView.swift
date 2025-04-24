//
//  BarView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct BarView: View {
    
    @ObservedObject var viewModel = BarViewModel()
    @ObservedObject var viewModel1 = PieViewModel()
    @Binding var allSelect : Bool
    @Binding var selectedType: CategoryType?
    @Binding var selectedTab: DateTab
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State var chartData: [Bar] = []
    @State var pieData: [Test] = []
    
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    var userId: String
    
    
    var body: some View {
        
        let image = Image("noData")
        
        VStack {
            if chartData.isEmpty {
                image
                    .resizable()
                    .scaledToFit()
                Text("NoDataFound".localized(using: currentLanguage))
            } else {
                Chart {
                    ForEach(chartData, id: \.id) { transaction in
                        BarMark(
                            x: .value("category", transaction.text),
                            y: .value("expense", transaction.number),
                            stacking: .standard
                        )
                        .foregroundStyle(Color(UIColor().colorFromHexString(transaction.color)))
                        
                    }
                }.chartLegend(.hidden)
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: 3)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                
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
        }.onAppear{
            updateChartData()
        }
        .onChange(of: allSelect) { _ in updateChartData() }
        .onChange(of: selectedType) { _ in updateChartData() }
        .onChange(of: selectedTab) { _ in updateChartData() }
        .onChange(of: selectedMonth) { _ in updateChartData() }
        .onChange(of: selectedYear) { _ in updateChartData() }
    }
    
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
