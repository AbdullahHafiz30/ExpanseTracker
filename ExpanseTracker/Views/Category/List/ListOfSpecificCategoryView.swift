//
//  ListOfSpecificCategoryView.swift
//  ExpanseTracker
//
//  Created by Naif on 17/04/2025.
//

import SwiftUI
import CoreData

struct ListOfSpecificCategoryView: View {
    // The name of the category to filter transactions
    var categoryName: String
    @Environment(\.dismiss) var dismiss

    // FetchRequest to get transactions related to the specific category, sorted by date (newest first)
    @FetchRequest private var transactions: FetchedResults<TransacionsEntity>

    // Custom initializer to apply the predicate based on the selected category name
    init(categoryName: String) {
        self.categoryName = categoryName
        _transactions = FetchRequest<TransacionsEntity>(
            entity: TransacionsEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TransacionsEntity.date, ascending: false)],
            predicate: NSPredicate(format: "category.name == %@", categoryName)
        )
    }

    var body: some View {
        VStack(alignment: .leading)  {
            CustomBackward(title:"\(categoryName)", tapEvent: { dismiss() })
                .frame(maxWidth: .infinity, alignment: .leading)

            if transactions.isEmpty {
                Spacer()
                Text("No transactions available for this category.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                List {
                    ForEach(transactions, id: \.id) { transaction in
                        TransactionCardView(transaction: transaction)
                            .environmentObject(ThemeManager()) 
                            .padding(.vertical, 8)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        //.navigationTitle("\(categoryName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
