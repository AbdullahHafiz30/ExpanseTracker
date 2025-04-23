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
    @Binding var userId: String
    
    
    var body: some View {
        
        let image = Image("noData")
        
        let chartData = viewModel.getData(
            allSelect: allSelect,
            selectedTab: selectedTab,
            selectedType: selectedType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            userId: userId)
        
        let pieData = viewModel1.getData(
            allSelect: allSelect,
            selectedTab: selectedTab,
            selectedType: selectedType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            userId: userId)
        
        VStack {
            if chartData.isEmpty {
                image
                    .resizable()
                    .scaledToFit()
                Text("No Data Found")
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
                                
                                Text(item.text)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
        }
    }
}
