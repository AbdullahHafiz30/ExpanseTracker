//
//  PieChartView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/10/1446 AH.
//


import SwiftUI

struct GraphsView: View {
    
    
    @State private var allSelect : Bool = true
    @State private var selectedTab: DateTab = .monthly
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedCategoryType: CategoryType? = nil
    @State var tabSelectedValue = 0

    var body: some View {
        VStack(spacing: 16) {
            GraphsViewHeader(
                allSelect: $allSelect,
                selectedTab: $selectedTab,
                selectedMonth: $selectedMonth,
                selectedYear: $selectedYear,
                selectedType: $selectedCategoryType
            )
            
            VStack {
                Picker(selection: $tabSelectedValue, label: Text("")) {
                    Text("Pie").tag(0)
                    Text("Bar").tag(1)
                    Text("Line").tag(2)
                    
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                TabView(selection: $tabSelectedValue,
                        content:  {
                    PieView(allSelect: $allSelect, selectedType: $selectedCategoryType, selectedTab: $selectedTab, selectedMonth: $selectedMonth, selectedYear: $selectedYear).tag(0).padding()
                    BarView(allSelect: $allSelect, selectedType: $selectedCategoryType, selectedTab: $selectedTab, selectedMonth: $selectedMonth, selectedYear: $selectedYear).tag(1).padding()
                    LineView().tag(2)
                })
                .tabViewStyle(PageTabViewStyle())
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding()
            }
            
            Text("Selected: \(selectedTab == .monthly ? "\(Calendar.current.monthSymbols[selectedMonth]) \(selectedYear)" : "\(selectedYear)")")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
            Spacer()
            // Chart view can go here
        }
        .padding(.top)
    }
}

