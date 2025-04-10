//
//  Transaction.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

struct Transaction: Identifiable{
    let id = UUID()
    var title: String
    var description: String
    var amount: Double
    var date: Date
    var type: String
    
    init(title: String, description: String, amount: Double, date: Date, type: TransactionType) {
        self.title = title
        self.description = description
        self.amount = amount
        self.date = date
        self.type = type.rawValue
    }
}

