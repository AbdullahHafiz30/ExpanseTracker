//
//  PieChartView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/10/1446 AH.
//

import SwiftUI

struct PieChartView: View {
    
    // MARK: - Date Picker Selection
    enum DatePickerMode: String, CaseIterable {
        case month = "Month"
        case year = "Year"
    }
    
    @State private var selectedMode: DatePickerMode = .month
    @State private var selectedMonth = Date()  // or your custom month selection
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    // MARK: - Category Filter
    @State private var showFilterSheet = false
    /// Suppose we have 4 main categories:
    let mainCategories = ["Essentials", "Entertainment", "Emergency", "Other"]
    /// Keep track of which main categories are selected:
    @State private var selectedCategories: Set<String> = []
    
    // MARK: - Chart Type Tab
    enum ChartType: String, CaseIterable, Identifiable {
        case pie = "Pie"
        case bar = "Bar"
        case line = "Line"
        
        var id: String { rawValue }
    }
    @State private var selectedChart: ChartType = .pie
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                
                // MARK: Header Row: Date + Filter Button
                HStack {
                    // Example: Show month/year text or button
                    if selectedMode == .month {
                        // Show a textual month (like "March 2024")
                        Text(monthYearString(for: selectedMonth))
                            .font(.headline)
                            .onTapGesture {
                                // You could show a custom month picker
                                // or just toggle the mode for demo
                            }
                        
                    } else {
                        // Show the selected year
                        Text("\(selectedYear)")
                            .font(.headline)
                            .onTapGesture {
                                // Show a custom year picker or change mode
                            }
                    }
                    
                    // Switch between month or year
                    Picker("Date Mode", selection: $selectedMode) {
                        Text("Month").tag(DatePickerMode.month)
                        Text("Year").tag(DatePickerMode.year)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 140)
                    
                    Spacer()
                    
                    // Filter button
                    Button {
                        showFilterSheet.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title3)
                    }
                    .sheet(isPresented: $showFilterSheet) {
                        CategoryFilterSheet(
                            mainCategories: mainCategories,
                            selectedCategories: $selectedCategories
                        )
                    }
                }
                .padding(.horizontal)
                
                // MARK: Chart Type Tab (Pie, Bar, Line)
                Picker("Chart Type", selection: $selectedChart) {
                    ForEach(ChartType.allCases) { chartType in
                        Text(chartType.rawValue).tag(chartType)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // MARK: Chart Placeholder
                // Replace this with your actual chart rendering (Pie, Bar, Line).
                ZStack {
                    switch selectedChart {
                    case .pie:
                        // Insert your Pie chart here
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.2))
                            .overlay(Text("Pie Chart Placeholder"))
                        
                    case .bar:
                        // Insert your Bar chart here
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.2))
                            .overlay(Text("Bar Chart Placeholder"))
                        
                    case .line:
                        // Insert your Line chart here
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.2))
                            .overlay(Text("Line Chart Placeholder"))
                    }
                }
                .frame(height: 250)
                .padding(.horizontal)
                
                // MARK: Legend (Example)
                // Under each chart, you might show different legends.
                // For demonstration, we’ll show example categories or a dynamic approach.
                if selectedChart == .pie {
                    // Example legend for 4 main categories
                    VStack(alignment: .leading, spacing: 8) {
                        LegendItem(color: .orange, text: "Entertainment 30%")
                        LegendItem(color: .yellow, text: "Essentials 40%")
                        LegendItem(color: .green, text: "Emergency 10%")
                        LegendItem(color: .blue, text: "Food 20%")
                    }
                } else if selectedChart == .bar {
                    // Example legend for Income vs Expense
                    HStack {
                        LegendItem(color: .yellow, text: "Expense")
                        LegendItem(color: .blue, text: "Income")
                    }
                } else if selectedChart == .line {
                    // Example legend for Income vs Expense, with a line style
                    HStack {
                        LegendItem(color: .blue, text: "Income")
                        LegendItem(color: .gray, text: "Expense")
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Graphs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Convert the selectedMonth date to something like "March 2024".
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.subheadline)
        }
    }
}

// MARK: - Category Filter Sheet

struct CategoryFilterSheet: View {
    let mainCategories: [String]
    @Binding var selectedCategories: Set<String>
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Main Categories")) {
                    ForEach(mainCategories, id: \.self) { cat in
                        MultipleSelectionRow(
                            title: cat,
                            isSelected: selectedCategories.contains(cat)
                        ) {
                            if selectedCategories.contains(cat) {
                                selectedCategories.remove(cat)
                            } else {
                                selectedCategories.insert(cat)
                            }
                        }
                    }
                }
                
                // If each main category has subcategories,
                // you could nest them in additional sections or logic here.
            }
            .navigationTitle("Filter Categories")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        // Dismiss
                        UIApplication.shared.endEditing() // or your own dismiss logic
                    }
                }
            }
        }
    }
}

// A simple list row with a checkmark for multiple selection
struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

// MARK: - Optional helper extension to dismiss keyboard/sheet
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

