//
//  User.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct User: Identifiable {
    var id: String?
    let name: String?
    let email: String?
    let password: String?
    let image: String? // added
    let transactions: [Transactions]?
    let budgets: [Budget?]
    let categories: [Category?] // added
}

