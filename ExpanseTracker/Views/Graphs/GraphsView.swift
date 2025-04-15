////
////  PieChartView.swift
////  ExpanseTracker
////
////  Created by Abdullah Hafiz on 15/10/1446 AH.
////


import SwiftUI

struct GraphsView: View {
    
    @State private var selectedTab: DateTab = .monthly
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedCategoryType: CategoryType? = nil
    @State var tabSelectedValue = 0

    var body: some View {
        VStack(spacing: 16) {
            GraphsViewHeader(
                selectedTab: $selectedTab,
                selectedMonth: $selectedMonth,
                selectedYear: $selectedYear,
                selectedType: $selectedCategoryType
            )
            
            VStack {
                Picker(selection: $tabSelectedValue, label: Text("")) {
                    Text("A").tag(0)
                    Text("B").tag(1)
                    Text("C").tag(2)
                    
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                TabView(selection: $tabSelectedValue,
                        content:  {
                    Text("A Tab Content").tag(0)
                    Text("B Tab Content").tag(1)
                    Text("C Tab Content").tag(2)
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

            // Chart view can go here
        }
        .padding(.top)
    }
}

