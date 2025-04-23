//
//  PieView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct PieView: View {
    
    @ObservedObject var viewModel = PieViewModel()
    @Binding var allSelect : Bool
    @Binding var selectedType: CategoryType?
    @Binding var selectedTab: DateTab
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    var userId: String
    @State var chartData: [Test] = []
    var body: some View {
        
        let image = Image("noData")
        
        VStack {
            if chartData.isEmpty {
                image
                    .resizable()
                    .scaledToFit()
                Text("No Data Found")
            } else {
                Chart(chartData) { data in
                    SectorMark(
                        angle: .value(
                            data.text,
                            data.number
                        ),
                        innerRadius: .ratio(0.6)
                    ).foregroundStyle(UIColor().colorFromHexString(data.color))
                }.chartLegend(.hidden)
                
                VStack {
                    ForEach(chartData) { item in
                        HStack {
                            Circle()
                                .fill(UIColor().colorFromHexString(item.color))
                                .frame(width: 18, height: 18)
                            
                            Text(item.text)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            Text(String(format: "%.0f%%", item.percentage))
                        }
                    }
                }
            }
            
        }
        .onAppear{
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
                userId: userId
            )
        }
}
