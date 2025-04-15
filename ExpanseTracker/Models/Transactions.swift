//
//  Transactions.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct Transactions: Identifiable,Hashable {
    let id: UUID?
    let titleq: String?
    let description: String?
    let amount: Double?
    let date: Date?
    let transactionType: TransactionType?
    let category: String
    let receiptImage: String?
}

