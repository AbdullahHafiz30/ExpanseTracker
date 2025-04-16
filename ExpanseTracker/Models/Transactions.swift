//
//  Transactions.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

<<<<<<< Updated upstream

struct Transactions: Identifiable, Hashable {
    let id: String?
=======
struct Transactions: Identifiable {
    let id: String
>>>>>>> Stashed changes
    let title: String?
    let description: String?
    let amount: Double?
    let date: Date?
    let transactionType: TransactionType?
    let category: Category?
    let receiptImage: String? 
<<<<<<< Updated upstream
    
    init(id: String?, title: String?, description: String?, amount: Double?, date: Date?, transactionType: TransactionType?, category: Category?, receiptImage: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.amount = amount
        self.date = date
        self.transactionType = transactionType
        self.category = category
        self.receiptImage = receiptImage
    }
=======
>>>>>>> Stashed changes
}

