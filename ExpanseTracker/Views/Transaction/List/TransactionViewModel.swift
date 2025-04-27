//
//  HomeViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI
import CoreData


/// ViewModel for managing logic on the Home screen.
/// Handles filtering, transaction totals, and deletion actions.
final class TransactionViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published var selectedType: TransactionType = .expense
    @Published var selectedTab: TimeFilter = .weekly
    @Published var startDate: Date = TimeFilter.weekly.startDate(from: Date())
    @Published var endDate: Date = Date()
    @Published var transactions: [TransacionsEntity] = []
    
    // MARK: - Date Filtering Logic
    
    /// Checks if a given date string matches the currently selected time filter.
    /// - Parameters:
    ///   - dateString: The transaction date string.
    ///   - filter: The time filter to check against.
    /// - Returns: A Boolean indicating whether the date falls within the filter.
    func isDate(_ dateString: String, filter: TimeFilter) -> Bool {
        
        // Convert the dateString into a Date object
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        guard let date = formatter.date(from: dateString) else {
            return false
        }
        
        let calendar = Calendar.current
        
        switch filter {
        case .daily:
            return calendar.isDate(date, inSameDayAs: Date())
        case .weekly:
            return calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
        case .monthly:
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        case .yearly:
            return calendar.isDate(date, equalTo: Date(), toGranularity: .year)
        }
    }
    
    // MARK: - Transaction Filtering
    
    /// Filters transactions based on search text, transaction type, and date range.
    /// - Parameters:
    ///   - transactions: A list of transactions fetched from Core Data.
    ///   - filter: The selected time filter.
    /// - Returns: A filtered array of TransacionsEntity matching the criteria.
    func filteredTransactions(_ transactions: FetchedResults<TransacionsEntity>, filter: TimeFilter) -> [TransacionsEntity] {
        return transactions.filter { transaction in
            
            let matchesSearch = searchText.isEmpty || (transaction.title?.localizedCaseInsensitiveContains(searchText) ?? false)
            
            let matchesType = transaction.transactionType == selectedType.rawValue
            
            let matchesDate = transaction.date.map { isDate($0, filter: filter) } ?? false
            
            return matchesSearch && matchesType && matchesDate
        }
    }
    
    // MARK: - Transaction Total Calculation
    
    /// Calculates the total amount for a specific transaction type.
    /// - Parameters:
    ///   - type: The transaction type to calculate for.
    ///   - transactions: A list of transactions.
    ///   - filter: An optional time filter to apply.
    /// - Returns: The total sum for the specified transaction type and filter.
    func total(_ type: TransactionType, transactions: FetchedResults<TransacionsEntity>, filter: TimeFilter? = nil) -> Double {
        transactions
            .filter {
                $0.transactionType == type.rawValue &&
                (filter == nil || ($0.date.map { isDate($0, filter: filter!) } ?? false))
            }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    // MARK: - Delete Function
    
    /// Deletes a given transaction from Core Data and persists the change.
    /// - Parameters:
    ///   - transaction: The transaction to delete.
    ///   - viewContext: The managed object context used for deletion.
    func deleteTransaction(_ transaction: TransacionsEntity, viewContext: NSManagedObjectContext) {
        viewContext.delete(transaction)
        PersistanceController.shared.saveContext()
    }
}
