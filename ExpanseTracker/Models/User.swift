//
//  User.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct User: Codable {
    var id: UUID?
    let name: String?
    let email: String?
    let password: String?
    let transactions: [Transactions?]
    let budgets: [Budget?]
}
