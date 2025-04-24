//
//  GraphsViewHeader.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 14/04/2025.
//


import SwiftUI

// MARK: - DateTab Enum
/// Toggles between monthly and yearly views for date filtering
enum DateTab: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { rawValue }
}

struct GraphsViewHeader: View {
    // MARK: - Bindings from Parent View
    /// Whether “All Categories” is selected
    @Binding var allSelect: Bool
    /// Granularity mode: monthly or yearly
    @Binding var selectedTab: DateTab
    /// Currently selected month index (1 = January)
    @Binding var selectedMonth: Int
    /// Currently selected year value
    @Binding var selectedYear: Int
    /// Currently selected category type (nil for all)
    @Binding var selectedType: CategoryType?
    
    // MARK: - Static Data Sources
    /// Valid range of years for the year picker
    private let yearRange = 2020...2060
    /// Month names used in month picker (English locale)
    private let monthSymbols: [String] = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.monthSymbols
    }()
    
    /// Language code for localized strings
    var currentLanguage: String
        
    // MARK: - View Body

    var body: some View {
        HStack(spacing: 12) {
            // MARK: Month Selector
            if selectedTab == .monthly {
                Menu {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(monthSymbols.indices, id: \.self) { i in
                            Text(monthSymbols[i]).tag(i)
                        }
                    }
                } label: {
                    // Custom label showing the selected month
                    DateLabelView(text: monthSymbols[selectedMonth])
                }
            }
            
            // MARK: Year Selector
            Menu {
                Picker("Year", selection: $selectedYear) {
                    ForEach(yearRange, id: \.self) { year in
                        Text(String(format : "%d", year)).tag(year)
                    }
                }
            } label: {
                // Custom label showing the selected year
                DateLabelView(text: "\(selectedYear)")
            }
            
            Spacer()
            
            // MARK: View Mode Toggle (Monthly/Yearly)
            Menu {
                Picker("Select Mode", selection: $selectedTab) {
                    ForEach(DateTab.allCases) { tab in
                        Text(tab.rawValue.localized(using: currentLanguage)).tag(tab)
                    }
                }
            } label: {
                // Icon button to open mode picker
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.primary)
                    .font(.title2)
            }
            
            // MARK: Category Type Selector
            Menu {
                // Binding converts between CategoryType? and String tags
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
                    // "All" option tag
                    Text("All".localized(using: currentLanguage)).tag("All")
                    // Individual category type tags
                    ForEach(CategoryType.allCases, id: \.self) { type in
                        Text(type.rawValue.localized(using: currentLanguage)).tag(type.rawValue)
                    }
                }
            } label: {
                // Icon button to open category picker
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.primary)
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
}
