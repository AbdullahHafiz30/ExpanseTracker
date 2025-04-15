//
//  Transactions.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct Transactions: Identifiable {
    let id: UUID?
    let titleq: String?
    let description: String?
    let amount: Double?
    let date: Date?
    let transactionType: TransactionType?
    let category: String
    let receiptImage: String?
    
//    init(id: UUID, titleq: String, description: String, amount: Double, date: Date, transactionType: String, category: Category, receiptImage: Data?) {
//        self.id = id
//        self.titleq = titleq
//        self.description = description
//        self.amount = amount
//        self.date = date
//        self.transactionType = TransactionType(rawValue: transactionType)
//        self.category = Category()
//        self.receiptImage =
//    }
}

