//
//  DateTab.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 14/04/2025.
//


import SwiftUI

enum DateTab: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { rawValue }
}

struct DateModePicker: View {
    @Binding var selectedTab: DateTab
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int

    private let yearRange = 2000...2030
    private let monthSymbols: [String] = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.monthSymbols
    }()

    var body: some View {
        HStack(spacing: 12) {
            // Month Picker
            if selectedTab == .monthly {
                Menu {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(monthSymbols.indices, id: \.self) { i in
                            Text(monthSymbols[i]).tag(i)
                        }
                    }
                } label: {
                    LabelView(text: monthSymbols[selectedMonth])
                }
            }

            // Year Picker
            Menu {
                Picker("Year", selection: $selectedYear) {
                    ForEach(yearRange, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
            } label: {
                LabelView(text: "\(selectedYear)")
            }

            Spacer()

            // Tab switcher (monthly/yearly)
            Menu {
                Picker("Select Mode", selection: $selectedTab) {
                    ForEach(DateTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.primary)
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
}
