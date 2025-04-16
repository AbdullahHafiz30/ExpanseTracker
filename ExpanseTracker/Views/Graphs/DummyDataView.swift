//
//  DummyDataView.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI

class DummyDataView: ObservableObject {
    
    
    @Published var dummyData: [Transaction] = [
        Transaction(
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
                categoryType: .essential,
                budgetLimit: 10000.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "2",
            title: "Groceries",
            description: "Weekly shopping",
            amount: 300.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 27))!,
            transactionType: .expense,
            category: Category(
                id: "2",
                name: "Groceries",
                color: "#FF9500",
                icon: "cart",
                categoryType: .essential,
                budgetLimit: 1200.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "3",
            title: "Netflix",
            description: "Monthly subscription",
            amount: 50.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 5))!,
            transactionType: .expense,
            category: Category(
                id: "3",
                name: "Streaming",
                color: "#AF52DE",
                icon: "tv",
                categoryType: .entertainment,
                budgetLimit: 200.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "4",
            title: "Freelance",
            description: "App design project",
            amount: 2200.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 18))!,
            transactionType: .income,
            category: Category(
                id: "4",
                name: "Freelance",
                color: "#007AFF",
                icon: "laptopcomputer",
                categoryType: .other,
                budgetLimit: 0.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "5",
            title: "Doctor Visit",
            description: "Emergency check-up",
            amount: 600.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 22))!,
            transactionType: .expense,
            category: Category(
                id: "5",
                name: "Health",
                color: "#FF3B30",
                icon: "cross.case.fill",
                categoryType: .emergency,
                budgetLimit: 1000.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "6",
            title: "Salary",
            description: "Monthly payment",
            amount: 8000.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 1))!,
            transactionType: .income,
            category: Category(id: "1", name: "Salary", color: "#34C759", icon: "banknote", categoryType: .essential, budgetLimit: 10000.00),
            receiptImage: ""
        ),
        Transaction(
            id: "7",
            title: "Groceries",
            description: "Weekly shopping",
            amount: 350.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 12))!,
            transactionType: .expense,
            category: Category(id: "2", name: "Groceries", color: "#FF9500", icon: "cart", categoryType: .essential, budgetLimit: 1500.00),
            receiptImage: ""
        ),
        Transaction(
            id: "8",
            title: "Spotify",
            description: "Music subscription",
            amount: 55.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 20))!,
            transactionType: .expense,
            category: Category(id: "3", name: "Music", color: "#AF52DE", icon: "music.note", categoryType: .entertainment, budgetLimit: 200.00),
            receiptImage: ""
        ),
        Transaction(
            id: "9",
            title: "Freelance Job",
            description: "Logo design",
            amount: 1800.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 10))!,
            transactionType: .income,
            category: Category(id: "4", name: "Freelance", color: "#007AFF", icon: "laptopcomputer", categoryType: .other, budgetLimit: 0.00),
            receiptImage: ""
        ),
        Transaction(
            id: "10",
            title: "ER Visit",
            description: "Emergency room charges",
            amount: 950.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 8))!,
            transactionType: .expense,
            category: Category(id: "5", name: "Health", color: "#FF3B30", icon: "cross.case.fill", categoryType: .emergency, budgetLimit: 1200.00),
            receiptImage: ""
        ),
        Transaction(
            id: "11",
            title: "Bonus",
            description: "End of year bonus",
            amount: 3000.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 28))!,
            transactionType: .income,
            category: Category(id: "6", name: "Bonus", color: "#5AC8FA", icon: "gift", categoryType: .other, budgetLimit: 0.00),
            receiptImage: ""
        ),
        Transaction(
            id: "12",
            title: "Gift Shopping",
            description: "Birthday gifts",
            amount: 480.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 17))!,
            transactionType: .expense,
            category: Category(id: "7", name: "Gifts", color: "#AF52DE", icon: "gift.fill", categoryType: .entertainment, budgetLimit: 500.00),
            receiptImage: ""
        ),
        Transaction(
            id: "13",
            title: "Rent",
            description: "Monthly apartment rent",
            amount: 2400.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
            transactionType: .expense,
            category: Category(id: "8", name: "Rent", color: "#FF9500", icon: "house.fill", categoryType: .essential, budgetLimit: 3000.00),
            receiptImage: ""
        ),
        Transaction(
            id: "14",
            title: "Investment Return",
            description: "Dividend from stocks",
            amount: 1250.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 15))!,
            transactionType: .income,
            category: Category(id: "9", name: "Stocks", color: "#007AFF", icon: "chart.bar.xaxis", categoryType: .other, budgetLimit: 0.00),
            receiptImage: ""
        ),
        Transaction(
            id: "15",
            title: "Car Repair",
            description: "Fixing brake system",
            amount: 1100.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5))!,
            transactionType: .expense,
            category: Category(id: "10", name: "Car", color: "#FF3B30", icon: "wrench.and.screwdriver", categoryType: .emergency, budgetLimit: 900.00),
            receiptImage: ""
        )
    ]
    
    // get all Essential amounts added
    // get all Entertainment amounts added
    // get all Emergency amounts added
    // for the (all) filter I can use all the amounts callculated above then present it in the pie chart
    
    func getEssential() -> Double {
        let essentialTotal = dummyData.filter { $0.category?.categoryType == .essential }.filter { $0.transactionType == .expense }.reduce(0) { $0 + ($1.amount ?? 0.0) }
        return essentialTotal
    }
    
    func getEntertainment() -> Double {
        let entertainmentTotal = dummyData.filter { $0.category?.categoryType == .entertainment }.filter { $0.transactionType == .expense }.reduce(0) { $0 + ($1.amount ?? 0.0) }
        return entertainmentTotal
    }
    
    func getEmergency() -> Double {
        let emergencyTotal = dummyData.filter { $0.category?.categoryType == .emergency}.filter{
            $0.transactionType == .expense}.reduce(0) { $0 + ($1.amount ?? 0.0) }
        return emergencyTotal
    }
    
    func getOther() -> Double {
        let otherTotal = dummyData.filter {
            $0.category?.categoryType == .other }.filter { $0.transactionType == .expense }.reduce(0) { $0 + ($1.amount ?? 0.0) }
        return otherTotal
    }
    func getAll() -> Double {
        let allTotal = dummyData.filter { $0.transactionType == .expense }.reduce(0) { $0 + ($1.amount ?? 0.0) }
        return allTotal
    }
    
    func getTestData() -> [Test] {
        return [
            Test(text: "Essential", number: getEssential()),
            Test(text: "Entertainment", number: getEntertainment()),
            Test(text: "Emergency", number: getEmergency()),
            Test(text: "Other", number: getOther()),
        ]
    }
    
    
    
    
}



struct Test: Identifiable {
    let text: String
    let number: Double
    
    let id = UUID()
    
    init(text: String, number: Double) {
        self.text = text
        self.number = number
    }
}

