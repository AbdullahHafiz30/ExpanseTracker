//
//  HomeViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI
import CoreData


final class TransactionViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var selectedType: TransactionType = .income
    @Published var selectedTab: TimeFilter = .monthly
    @Published var startDate: Date = TimeFilter.monthly.startDate(from: Date())
    @Published var endDate: Date = Date()
    
    
    func filteredTransactions(_ transactions: FetchedResults<TransacionsEntity>) -> [TransacionsEntity] {
        transactions.filter { transaction in
            let matchesSearch = searchText.isEmpty || (transaction.title?.localizedCaseInsensitiveContains(searchText) ?? false)
            let matchesType = transaction.transactionType == selectedType.rawValue
            return matchesSearch && matchesType
        }
    }
    
    func total(_ type: TransactionType, transactions: FetchedResults<TransacionsEntity>) -> Double {
        return transactions
            .filter { $0.transactionType == type.rawValue }   // Filter by type
            .map { $0.amount }                                // Extract amount
            .reduce(0, +)                                      // Sum all amounts
    }
    
    func deleteTransaction(_ transaction: TransacionsEntity, viewContext: NSManagedObjectContext) {
        withAnimation {
            viewContext.delete(transaction)
            
            PersistanceController.shared.saveContext()
        }
    }
}


