//
//  HomeViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var sampleTransactions: [Transaction] = [
        Transaction(
            title: "Salary",
            description: "Monthly salary deposit",
            amount: 5000.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 1))!,
            type: .income,
            category: Category(
                id: UUID().uuidString,
                name: "Salary",
                color: "#34C759",
                icon: "banknote",
                categoryType: .Essential,
                budgetLimit: 0
            ),
            receiptImage: "Image"
        ),
        Transaction(
            title: "Groceries",
            description: "Weekly grocery shopping at HyperPanda",
            amount: 350.75,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 5))!,
            type: .expense,
            category: Category(
                id: UUID().uuidString,
                name: "Groceries",
                color: "#FF9500",
                icon: "cart",
                categoryType: .Essential,
                budgetLimit: 1500
            ),
            receiptImage: "Image"
        ),
        Transaction(
            title: "Netflix Subscription",
            description: "Monthly subscription fee",
            amount: 55.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 3))!,
            type: .expense,
            category: Category(
                id: UUID().uuidString,
                name: "Entertainment",
                color: "#AF52DE",
                icon: "tv",
                categoryType: .Entertainment,
                budgetLimit: 200
            ),
            receiptImage: "Image"
        ),
        Transaction(
            title: "Car Repair",
            description: "Emergency car repair at local garage",
            amount: 1200.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 7))!,
            type: .expense,
            category: Category(
                id: UUID().uuidString,
                name: "Car Maintenance",
                color: "#FF3B30",
                icon: "wrench.and.screwdriver",
                categoryType: .emergency,
                budgetLimit: 1000
            ),
            receiptImage: "Image"
        ),
        Transaction(
            title: "Freelance Work",
            description: "Payment from freelance project",
            amount: 1200.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 28))!,
            type: .income,
            category: Category(
                id: UUID().uuidString,
                name: "Freelance",
                color: "#007AFF",
                icon: "laptopcomputer",
                categoryType: .other,
                budgetLimit: 0
            ),
            receiptImage: "Image"
        )
    ]



    
    @Published var sampleTransaction: [Transaction] = []

    init() {
        self.sampleTransaction = sampleTransactions
    }

    func total(for type: TransactionType, from startDate: Date, to endDate: Date) -> Double {
        sampleTransactions
            .filter {
                $0.type.rawValue == type.rawValue &&
                $0.date >= startDate &&
                $0.date <= endDate
            }
            .map { $0.amount }
            .reduce(0, +)
    }
}
