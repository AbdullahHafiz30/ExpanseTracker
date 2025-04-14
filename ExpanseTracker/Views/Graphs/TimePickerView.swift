//
//  TimePickerView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 16/10/1446 AH.
//


import SwiftUI

struct MonthlyYearlyPickerView: View {
    
    // MARK: - State Variables
    @State private var selectedTab: Tab = .monthly
    
    // For "Month" mode
    @State private var selectedMonthIndex: Int = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYearForMonth: Int = Calendar.current.component(.year, from: Date())
    
    // For "Year" mode
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    // Example range of years
    private let yearRange = Array(2024...2040)
    
    // List of month names
    private let monthSymbols = Calendar.current.monthSymbols
    
    var body: some View {
        VStack(spacing: 24) {
            // MARK: - 1) Segmented control: Monthly or Yearly
            Picker("Time Filter", selection: $selectedTab) {
                ForEach(Tab.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // MARK: - 2) Conditionally show the relevant pickers
            switch selectedTab {
            case .monthly:
                monthlyPicker
            case .yearly:
                yearlyPicker
            }
            
            // MARK: - 3) Display the chosen result
            displayResult
            
            Spacer()
        }
        .navigationTitle("Time Picker")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

extension MonthlyYearlyPickerView {
    // MARK: - Monthly Picker
    private var monthlyPicker: some View {
        VStack(spacing: 8) {
            Text("Select Month & Year").font(.headline)
            HStack(spacing: 16) {
                // Month Wheel
                Picker("Month", selection: $selectedMonthIndex) {
                    ForEach(monthSymbols.indices, id: \.self) { i in
                        Text(monthSymbols[i]).tag(i)
                    }
                }
                .frame(width: 120, height: 100)
                .clipped()
                
                // Year Wheel
                Picker("Year", selection: $selectedMonthYear) {
                    ForEach(yearRange, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .frame(width: 80, height: 100)
                .clipped()
            }
        }
    }
    
    // MARK: - Yearly Picker
    private var yearlyPicker: some View {
        VStack(spacing: 8) {
            Text("Select Year").font(.headline)
            Picker("Year", selection: $selectedYear) {
                ForEach(yearRange, id: \.self) { year in
                    Text("\(year)").tag(year)
                }
            }
            .frame(width: 100, height: 100)
            .clipped()
        }
    }
    
    // MARK: - Display the result
    private var displayResult: some View {
        VStack(spacing: 8) {
            switch selectedTab {
            case .monthly:
                Text("Monthly: \(monthSymbols[selectedMonthIndex]) \(selectedMonthYear)")
            case .yearly:
                Text("Yearly: \(selectedYear)")
            }
        }
        .font(.headline)
        .padding()
    }
}
