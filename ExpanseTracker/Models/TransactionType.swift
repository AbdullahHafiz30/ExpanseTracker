//
//  Category.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

/// Represents the type of a financial transaction.
enum TransactionType: String, CaseIterable, Codable, Identifiable {
    
    // A unique identifier for the transaction type, based on its raw string value.
    var id: String { rawValue }
    
    case expense = "Expense"
    case income = "Income"
    
}
