//
//  PieChartView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/10/1446 AH.
//

import SwiftUI

struct GraphsView: View {
    @State private var selectedTab: DateTab = .monthly
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())

    var body: some View {
        VStack(spacing: 16) {
            DateModePicker(
                selectedTab: $selectedTab,
                selectedMonth: $selectedMonth,
                selectedYear: $selectedYear
            )

            Text("Selected: \(selectedTab == .monthly ? "\(Calendar.current.monthSymbols[selectedMonth]) \(selectedYear)" : "\(selectedYear)")")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            // Chart view can go here
        }
        .padding(.top)
    }
}

