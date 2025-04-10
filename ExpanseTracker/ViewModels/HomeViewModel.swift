//
//  HomeViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var sampleTransactions: [Transaction] = [
        .init(title: "Magic Keyboard", description: "Apple Product", amount: 129.0, date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 5))!, type: .expense),
        .init(title: "Payment", description: "Payment Received", amount: 2499.0, date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 10))!, type: .income),
        .init(title: "Coffee", description: "Morning caffeine boost", amount: 4.99, date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 9))!, type: .expense),
        .init(title: "Groceries", description: "Weekly shopping", amount: 76.45, date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 2))!, type: .expense),
        .init(title: "Spotify", description: "Music subscription", amount: 9.99, date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 20))!, type: .expense),
        .init(title: "Electricity Bill", description: "Monthly utility bill", amount: 60.0, date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 15))!, type: .expense),
        .init(title: "Freelance Project", description: "Website redesign", amount: 1200.0, date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 5))!, type: .income),
        .init(title: "Book Sale", description: "Sold old books", amount: 45.0, date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 25))!, type: .income),
        .init(title: "Netflix", description: "Monthly subscription", amount: 15.49, date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 1))!, type: .expense),
        .init(title: "Gym Membership", description: "Fitness plan", amount: 30.0, date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 7))!, type: .expense),
        .init(title: "YouTube Ad Revenue", description: "Monthly payout", amount: 250.0, date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 1))!, type: .income),
        .init(title: "Dining Out", description: "Dinner with friends", amount: 52.25, date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 28))!, type: .expense)
    ]

    
    @Published var sampleTransaction: [Transaction] = []

    init() {
        self.sampleTransaction = sampleTransactions
    }

    func total(for type: TransactionType, from startDate: Date, to endDate: Date) -> Double {
        sampleTransactions
            .filter {
                $0.type == type.rawValue &&
                $0.date >= startDate &&
                $0.date <= endDate
            }
            .map { $0.amount }
            .reduce(0, +)
    }
}
