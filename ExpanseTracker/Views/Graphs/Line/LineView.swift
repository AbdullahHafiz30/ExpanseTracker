//
//  LineView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct LineView: View {
    @ObservedObject var viewModel = PieViewModel()
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
        
        VStack {
            if chartData.isEmpty {
                image
                    .resizable()
                    .scaledToFit()
                Text("No Data Found")
            } else {
                Chart(chartData) {
                        LineMark(
                            x: .value("category", $0.text),
                            y: .value("expense", $0.number)
                        ).foregroundStyle(by: .value("Product Category", $0.text))
                    }
                
            }
        }
    }
}
