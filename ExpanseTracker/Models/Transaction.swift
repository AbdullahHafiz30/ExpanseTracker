//
//  Transactions.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation


struct Transaction: Identifiable, Hashable {
    let id: String?
    let title: String?
    let description: String?
    let amount: Double?
    let date: Date?
    let transactionType: TransactionType?
    let category: Category?
    let receiptImage: String?
    
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
   
    init(from entity: TransacionsEntity) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.id = entity.id ?? ""
        self.title = entity.title ?? ""
        self.description = entity.description
        self.receiptImage = entity.image ?? ""
        self.date = formatter.date(from: entity.date ?? "")
        self.amount = entity.amount
        self.transactionType = TransactionType(rawValue: entity.transactionType ?? "")
        if let categoryEntity = entity.category {
            self.category = Category(from: categoryEntity)
        } else {
            self.category = nil
        }
    }
}

