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
    
    
//    getDataByTab(selectedTab: selectedTab, selectedYear: selectedYear, selectedMonth: selectedMonth)
    
    
//    getTestDataByMonthYear(selectedMonth: selectedMonth, selectedYear: selectedYear)
    
//    getTestData(selectedType: selectedType)
    
//    getTestDataByYear(selectedYear: selectedYear)
    
    var body: some View {
        VStack {
            Chart(viewModel.getData(
                allSelect: allSelect,
                selectedTab: selectedTab,
                selectedType: selectedType,
                selectedMonth: selectedMonth,
                selectedYear: selectedYear)) { data in
                SectorMark(
                    angle: .value(
                        data.text,
                        data.number
                    )
                ).foregroundStyle(
                    by: .value(
                        Text(verbatim: data.text),
                        data.text
                    )
                )
                
            }
        }
    }
}
