//
//  HomeViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI
import CoreData


/// ViewModel for managing logic on the Home screen.
/// Handles filtering, transaction totals, and deletion.
final class TransactionViewModel: ObservableObject {
    
    // MARK: - Published Variable
    @Published var searchText: String = ""
    @Published var selectedType: TransactionType = .income
    @Published var selectedTab: TimeFilter = .monthly
    @Published var startDate: Date = TimeFilter.monthly.startDate(from: Date())
    @Published var endDate: Date = Date()
    @Published var transactions: [TransacionsEntity] = []
    @Published var selectedFilter: TimeFilter = .daily

    // MARK: - Transaction Filtering Logic
        
    /// Filters the provided transactions based on the current search text and selected transaction type.
    /// - Parameter transactions: A list of all transactions.
    /// - Returns: A filtered array of TransacionsEntity matching the current filters.
    
    func filteredTransactions(_ transactions: FetchedResults<TransacionsEntity>, filter: TimeFilter) -> [TransacionsEntity] {
        
        let calendar = Calendar.current

        return transactions.filter { transaction in
            
            // Match title search
            let matchesSearch = searchText.isEmpty || (transaction.title?.localizedCaseInsensitiveContains(searchText) ?? false)
            
            // Match type
            let matchesType = transaction.transactionType == selectedType.rawValue
            
            // Match time filter
            guard let dateString = transaction.date,
                  let transactionDate = parseDate(from: dateString) else {
                return false
            }

            let matchesDate: Bool
            switch filter {
            case .daily:
                matchesDate = calendar.isDate(transactionDate, inSameDayAs: Date())
            case .weekly:
                matchesDate = calendar.isDate(transactionDate, equalTo: Date(), toGranularity: .weekOfYear)
            case .monthly:
                matchesDate = calendar.isDate(transactionDate, equalTo: Date(), toGranularity: .month)
            case .yearly:
                matchesDate = calendar.isDate(transactionDate, equalTo: Date(), toGranularity: .year)
            }

            return matchesSearch && matchesType && matchesDate
        }
    }

    private func parseDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" 
        return formatter.date(from: string)
    }

    // MARK: - Total Amount
        
        /// Calculates the total sum of amounts for a given transaction type.
        /// - Parameters:
        ///   - type: The type of transaction to calculate the total for.
        ///   - transactions: A list of all transactions.
        /// - Returns: The sum of amounts for the matching transaction type.
    func total(_ type: TransactionType, transactions: FetchedResults<TransacionsEntity>) -> Double {
        return transactions
            .filter { $0.transactionType == type.rawValue }   // Filter by type
            .map { $0.amount }                                // Extract amount
            .reduce(0, +)                                      // Sum all amounts
    }
    
    // MARK: - Delete Funaction
        
    /// Deletes a specific transaction from the Core Data and saves the change.
    /// - Parameters:
    ///   - transaction: The TransacionsEntity to delete.
    ///   - viewContext: The managed object context used to delete the entity.
    func deleteTransaction(_ transaction: TransacionsEntity, viewContext: NSManagedObjectContext) {
        withAnimation {
            viewContext.delete(transaction)
            
            PersistanceController.shared.saveContext()
        }
    }
    
}




