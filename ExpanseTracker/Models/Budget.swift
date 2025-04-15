//
//  Budget.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct Budget: Codable {
    let id: UUID?
    let amount: Double?
    let startDate: Date?
    let endDate: Date?
}
