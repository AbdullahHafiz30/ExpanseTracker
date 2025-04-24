//
//  BarViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 24/10/1446 AH.
//

import CoreData
import SwiftUI

/// ViewModel responsible for fetching, filtering, and computing daily balances
/// for rendering in a line chart.
class LineViewModel: ObservableObject {
    
    // Core Data context for fetch operations
    private let context = PersistanceController.shared.context

    // MARK: - Category Filtering
        
    /// Filters transactions by main category type if one is selected.
    /// - Parameters:
    ///   - array: All transactions to filter
    ///   - selectedType: Optional `CategoryType` filter (.essential, .entertainment, etc.)
    /// - Returns: Filtered transactions matching the category (or all if `nil`)
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

    // MARK: - Line Chart Data Computation
        
    /// Computes a running daily balance for the given user and filters.
    /// - Parameters:
    ///   - allSelect: Whether “All Categories” is selected (not used here but kept for consistency)
    ///   - selectedTab: `.monthly` or `.yearly` view
    ///   - selectedType: Optional main category filter
    ///   - selectedMonth: Month index (1 = January)
    ///   - selectedYear: Year value (e.g. 2025)
    ///   - userId: Current user identifier
    /// - Returns: Array of `DailyBalance` points sorted by date
    func getLineChartData(allSelect: Bool, selectedTab: DateTab, selectedType: CategoryType?, selectedMonth: Int, selectedYear: Int, userId: String) -> [DailyBalance] {
    
        let cal = Calendar.current
        
        // Step 1: Fetch and apply category filter
        let catData = getType(array: getUserTransactions(userId: userId), selectedType: selectedType)
        
        var filteredData: [Transaction] = []

        // Step 2: Filter by date (yearly vs. monthly)
        if DateTab.yearly == selectedTab {
            
            filteredData = catData.filter { cal.component(.year, from: $0.date ?? Date()) == selectedYear }
            
        } else {
            
            filteredData = catData.filter { cal.component(.month, from: $0.date ?? Date()) == selectedMonth && cal.component(.year, from: $0.date ?? Date()) == selectedYear }
            
        }


        var dailyBalances: [DailyBalance] = []
        var currentBalance: Double = 0

        // Step 3: Group transactions by day
        let groupedTransactions = Dictionary(grouping: filteredData, by:  { cal.startOfDay(for: $0.date ?? Date()) })
        
        // Step 4: Sort days and compute running balance
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

    // MARK: - Core Data Fetch
        
        /// Fetches all transactions for a user from Core Data and maps them into `Transaction`.
        /// - Parameter userId: The user’s unique identifier
        /// - Returns: Array of `Transaction` models (empty if fetch fails)
    func getUserTransactions(userId: String) -> [Transaction] {
        let transaction = [] as [Transaction]
        // Fetch user
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        // Date formatter to parse stored date strings
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


// MARK: - Line Chart Data Model
/// Represents a single day’s end balance for plotting in a line chart.
struct DailyBalance: Identifiable {
    let date: Date      // The day (start of day)
    let balance: Double // Running balance at end of this day
    let id = UUID()
}
