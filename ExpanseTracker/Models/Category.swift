//
//  Category.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 12/10/1446 AH.
//

import Foundation

struct Category: Identifiable,Hashable {
    let id: String?
    let name: String?
    let color: String?
    let icon: String?
    let categoryType: CategoryType?
    let budgetLimit: Double?
    
    init(id: String?, name: String?, color: String?, icon: String?, categoryType: CategoryType?, budgetLimit: Double?) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.categoryType = categoryType
        self.budgetLimit = budgetLimit
    }
}
