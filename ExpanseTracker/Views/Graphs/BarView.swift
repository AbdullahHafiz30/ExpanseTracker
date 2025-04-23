//
//  BarView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import Charts

struct BarView: View {
    
    @ObservedObject var viewModel = DummyDataViewModel()
    @Binding var allSelect : Bool
    @Binding var selectedType: CategoryType?
    @Binding var selectedTab: DateTab
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    var userId: String
    var body: some View {
        
        VStack {
            Chart(viewModel.getData(
                allSelect: allSelect,
                selectedTab: selectedTab,
                selectedType: selectedType,
                selectedMonth: selectedMonth,
                selectedYear: selectedYear,
                userId: userId)) {
                BarMark(
                    x: .value("category", $0.text),
                    y: .value("expense", $0.number)
                ).foregroundStyle(by: .value("Product Category", $0.text))
                
            }
        }
    }
}
