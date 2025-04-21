//
//  PieView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct PieView: View {
    
    @ObservedObject var viewModel = DummyDataViewModel()
    @Binding var allSelect : Bool
    @Binding var selectedType: CategoryType?
    @Binding var selectedTab: DateTab
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var userId: String
    
    var body: some View {
        
        let chartData = viewModel.getData(
            allSelect: allSelect,
            selectedTab: selectedTab,
            selectedType: selectedType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            userId: userId)
   
        VStack {
            Chart(chartData) { data in
                SectorMark(
                    angle: .value(
                        data.text,
                        data.number
                    ),
                    innerRadius: .ratio(0.6)
                ).foregroundStyle(
                    by: .value(
                        Text(verbatim: data.text),
                        data.text
                    )
                )
                
                
            }
            VStack {
                ForEach(chartData) { item in
                    Text(String(item.percentage))
                }
            }
            //                .chartLegend(position: .bottom) {
            //                    ScrollView(.horizontal) {
            //                        VStack {
            //                            ForEach(viewModel.getData(
            //                                allSelect: allSelect,
            //                                selectedTab: selectedTab,
            //                                selectedType: selectedType,
            //                                selectedMonth: selectedMonth,
            //                                selectedYear: selectedYear)) { data in
            //                                VStack {
            //                                    BasicChartSymbolShape.circle
            //                                        .foregroundColor(colorFor(data.text: symbol))
            //                                        .frame(width: 8, height: 8)
            //                                    Text(symbol)
            //                                        .foregroundColor(.gray)
            //                                        .font(.caption)
            //                                }
            //                            }
            //                        }
            //                        .padding()
            //                    }
            //                }
        }
    }
}
