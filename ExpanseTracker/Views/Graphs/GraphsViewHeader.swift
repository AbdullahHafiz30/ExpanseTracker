//
//  GraphsViewHeader.swift
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

struct GraphsViewHeader: View {
    
    @Binding var allSelect: Bool
    @Binding var selectedTab: DateTab
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var selectedType: CategoryType?
    
    private let yearRange = 2020...2060
    private let monthSymbols: [String] = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.monthSymbols
    }()
    
    var currentLanguage: String
    
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
                    DateLabelView(text: monthSymbols[selectedMonth])
                }
            }
            
            // Year Picker
            Menu {
                Picker("Year", selection: $selectedYear) {
                    ForEach(yearRange, id: \.self) { year in
                        Text(String(format : "%d", year)).tag(year)
                    }
                }
            } label: {
                DateLabelView(text: "\(selectedYear)")
            }
            
            Spacer()
            
            // Tab switcher (monthly/yearly)
            Menu {
                Picker("Select Mode", selection: $selectedTab) {
                    ForEach(DateTab.allCases) { tab in
                        Text(tab.rawValue.localized(using: currentLanguage)).tag(tab)
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.primary)
                    .font(.title2)
            }
            
            // Category select
            Menu {
                Picker("Category Type", selection: Binding(
                    get: { selectedType?.rawValue ?? "All" },
                    set: { newValue in
                        if newValue == "All" {
                            allSelect = true
                            selectedType = nil
                        } else {
                            allSelect = false
                            selectedType = CategoryType(rawValue: newValue)
                        }
                    })
                ) {
                    Text("All".localized(using: currentLanguage)).tag("All")
                    ForEach(CategoryType.allCases, id: \.self) { type in
                        Text(type.rawValue.localized(using: currentLanguage)).tag(type.rawValue)
                    }
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.primary)
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
}
