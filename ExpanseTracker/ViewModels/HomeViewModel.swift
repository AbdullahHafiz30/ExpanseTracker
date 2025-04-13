//
//  HomeViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var sampleTransactions: [Transaction] = [
        .init(
            title: "Magic Keyboard",
            description: "Apple Product",
            amount: 129.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 5))!,
            type: .expense,
            category: Category(id: UUID(), name: "Tech", icon: "keyboard", color: "#007AFF", budgetLimit: 100.0, type: .Essential),
            receiptImage: "Image"
        ),
        .init(
            title: "Payment",
            description: "Payment Received",
            amount: 2499.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 10))!,
            type: .income,
            category: Category(id: UUID(), name: "Salary", icon: "dollarsign.circle", color: "#34C759", budgetLimit: 200.0, type: .other),
            receiptImage: "Image"
        ),
        .init(
            title: "Coffee",
            description: "Morning caffeine boost",
            amount: 4.99,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 9))!,
            type: .expense,
            category: Category(id: UUID(), name: "Food & Drink", icon: "cup.and.saucer", color: "#FF9500", budgetLimit: 150.0, type: .Essential),
            receiptImage: "Image"
        ),
        .init(
            title: "Groceries",
            description: "Weekly shopping",
            amount: 76.45,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 2))!,
            type: .expense,
            category: Category(id: UUID(), name: "Groceries", icon: "cart", color: "#FFCC00", budgetLimit: 500.0, type: .Essential),
            receiptImage: "Image"
        ),
        .init(
            title: "Spotify",
            description: "Music subscription",
            amount: 9.99,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 20))!,
            type: .expense,
            category: Category(id: UUID(), name: "Entertainment", icon: "music.note", color: "#AF52DE", budgetLimit: 100.0, type: .Entertainment),
            receiptImage: "Image"
        ),
        .init(
            title: "Electricity Bill",
            description: "Monthly utility bill",
            amount: 60.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 15))!,
            type: .expense,
            category: Category(id: UUID(), name: "Utilities", icon: "bolt.fill", color: "#FF3B30", budgetLimit: 200.0, type: .Essential),
            receiptImage: "Image"
        ),
        .init(
            title: "Freelance Project",
            description: "Website redesign",
            amount: 1200.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 5))!,
            type: .income,
            category: Category(id: UUID(), name: "Freelancing", icon: "laptopcomputer", color: "#5AC8FA", budgetLimit: 330.0, type: .other),
            receiptImage: "Image"
        ),
        .init(
            title: "Book Sale",
            description: "Sold old books",
            amount: 45.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 25))!,
            type: .income,
            category: Category(id: UUID(), name: "Side Hustle", icon: "book.closed", color: "#FF9500", budgetLimit: 400.0, type: .other),
            receiptImage: "Image"
        ),
        .init(
            title: "Netflix",
            description: "Monthly subscription",
            amount: 15.49,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 1))!,
            type: .expense,
            category: Category(id: UUID(), name: "Entertainment", icon: "film", color: "#5856D6", budgetLimit: 80.0, type: .Entertainment),
            receiptImage: "Image"
        ),
        .init(
            title: "Gym Membership",
            description: "Fitness plan",
            amount: 30.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 7))!,
            type: .expense,
            category: Category(id: UUID(), name: "Health", icon: "heart.fill", color: "#FF2D55", budgetLimit: 100.0, type: .Essential),
            receiptImage: "Image"
        ),
        .init(
            title: "YouTube Ad Revenue",
            description: "Monthly payout",
            amount: 250.0,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 1))!,
            type: .income,
            category: Category(id: UUID(), name: "Passive Income", icon: "play.rectangle", color: "#34C759", budgetLimit: 500.0, type: .other),
            receiptImage: "Image"
        ),
        .init(
            title: "Dining Out",
            description: "Dinner with friends",
            amount: 52.25,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 28))!,
            type: .expense,
            category: Category(id: UUID(), name: "Dining", icon: "fork.knife", color: "#FF9500", budgetLimit: 120.0, type: .Entertainment),
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
