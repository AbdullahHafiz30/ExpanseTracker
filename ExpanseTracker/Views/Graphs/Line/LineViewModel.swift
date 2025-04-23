//
//  BarViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 24/10/1446 AH.
//

import Foundation
import CoreData
import SwiftUI

class LineViewModel: ObservableObject {
    private let context = PersistanceController.shared.context

    //MARK: - Get The Four Main Types or All
    // this will give all the expenses elements in the array based on the category type
    func getType(array: [Transaction], selectedType: CategoryType?) -> [Transaction] {
        switch selectedType {
        case .essential?:
            return array.filter { $0.category?.categoryType == .essential}
        case .entertainment?:
            return array.filter { $0.category?.categoryType == .entertainment}
        case .emergency?:
            return array.filter { $0.category?.categoryType == .emergency}
        case .other?:
            return array.filter { $0.category?.categoryType == .other}
        default:
            return array
        }
    }

    //MARK: - get Data for Line Chart
    func getLineChartData(allSelect: Bool, selectedTab: DateTab, selectedType: CategoryType?, selectedMonth: Int, selectedYear: Int, userId: String) -> [DailyBalance] {
    
        let cal = Calendar.current
        
        let catData = getType(array: getUserTransactions(userId: userId), selectedType: selectedType)
        
        var filteredData: [Transaction] = []

        if DateTab.yearly == selectedTab {
            
            filteredData = catData.filter { cal.component(.year, from: $0.date ?? Date()) == selectedYear }
            
        } else {
            
            filteredData = catData.filter { cal.component(.month, from: $0.date ?? Date()) == selectedMonth + 1 && cal.component(.year, from: $0.date ?? Date()) == selectedYear }
            
        }


        var dailyBalances: [DailyBalance] = []
        var currentBalance: Double = 0

        // Group transactions by day in a dictionary
        let groupedTransactions = Dictionary(grouping: filteredData, by:  { cal.startOfDay(for: $0.date ?? Date()) })
        
        // Sort the date --- from old to new date
        let sortedDays = groupedTransactions.keys.sorted(by: <)
        
        for day in sortedDays {
            if let transactionsOnDay = groupedTransactions[day] {
                var dailyAmount: Double = 0
                for transaction in transactionsOnDay {
                    print(transaction)
                    if transaction.transactionType == .expense {
                        dailyAmount -= (transaction.amount ?? 0.0)
                    } else {
                        dailyAmount += (transaction.amount ?? 0.0)
                    }
                }
                currentBalance += dailyAmount
                dailyBalances.append(DailyBalance(date: day, balance: currentBalance))
            }
        }

        return dailyBalances
    }

    func getUserTransactions(userId: String) -> [Transaction] {
        let transaction = [] as [Transaction]
        // Fetch user
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        do {
            if let user = try context.fetch(userRequest).first, let transactions = user.transaction?.allObjects as? [TransacionsEntity] {
                return transactions.map {
                    Transaction(
                        id: $0.id ?? UUID().uuidString,
                        title: $0.title ?? "",
                        description: $0.desc,
                        amount: $0.amount,
                        date: formatter.date(from: $0.date ?? "") ?? Date(),
                        transactionType: TransactionType(rawValue: $0.transactionType ?? "") ?? .expense, 
                        category: $0.category.map { Category(from: $0) },
                        receiptImage: $0.image ?? ""
                    )
                }
            }
        } catch {
            print("Error fetching user: \(error)")
        }
        return transaction
    }
}

//MARK: - Line Chart Return Architecture
struct DailyBalance: Identifiable {
    let date: Date
    let balance: Double
    let id = UUID()
}
