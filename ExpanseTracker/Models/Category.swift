//
//  Category.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct Category: Identifiable {
    let id: String?
    let name: String?
    let color: String?
    let icon: String?
    let categoryType: CategoryType?
    let budgetLimit: Double?
}
