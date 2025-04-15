//
//  DummyDataView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI

class DummyDataView: ObservableObject {
    
    @Published var dummyData: [Transactions] = [
        Transactions(
            id: "1",
            title: "tt",
            description: "aa",
            amount: 100.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 15))!,
            transactionType: .income,
            category: Category(
                id: "1",
                name: "salary",
                color: "#34C759",
                icon: "carrot",
                categoryType: .Essential,
                budgetLimit: 10000.00
            ),
            receiptImage: ""
        )
    ]
    
}
