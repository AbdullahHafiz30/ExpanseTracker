//
//  Category.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct Category: Codable {
    let id: UUID?
    let name: String?
    let icon: String?
    let color: String?
    let budgetLimit: Double?
    let type: CategoryType?
}
