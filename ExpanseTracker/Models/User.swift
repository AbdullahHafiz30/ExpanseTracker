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
    let image: String?
    let transactions: [Transactions]?
    let budgets: [Budget?]
<<<<<<< Updated upstream
    let categories: [Category?]
=======
    let categories: [Category?] 
>>>>>>> Stashed changes
}

