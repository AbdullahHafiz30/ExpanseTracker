//
//  LineView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct LineView: View {
    @ObservedObject var viewModel = LineViewModel()
    @State private var lineChartData: [DailyBalance] = []
    @Binding var allSelect : Bool
    @Binding var selectedType: CategoryType?
    @Binding var selectedTab: DateTab
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    var userId: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        var lineChartData = viewModel.getLineChartData(
            allSelect: allSelect,
            selectedTab: selectedTab,
            selectedType: selectedType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            userId: userId
        )
        
        VStack{
            Chart{
                ForEach(lineChartData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date, unit: .day),
                        y: .value("Balance", dataPoint.balance)
                    )
                    .foregroundStyle(themeManager.isDarkMode ? .cyan : .blue)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .padding(.vertical)
            
            HStack{
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                
                Text("Income")
                    .font(.title3)
                
                Spacer()
                
                Image(systemName: "chart.line.downtrend.xyaxis")
                    .font(.title2)
                Text("Expense")
                    .font(.title3)
            }
            .padding()
        }
        .onAppear{
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
}

