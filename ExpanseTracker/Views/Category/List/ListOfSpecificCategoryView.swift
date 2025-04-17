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
        VStack(alignment: .leading) {
            // Section header showing the selected category name
//            Text("Transactions for Category: \(categoryName)")
//                .font(.title2)
//                .bold()
//                .padding(.horizontal)
            CustomBackward(title:"\(categoryName)", tapEvent: {dismiss()})
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if transactions.isEmpty {
                // Display message when no transactions are found
                Spacer()
                Text("No transactions available for this category.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                // List of transactions
                List {
                    ForEach(transactions, id: \.id) { transaction in
                        VStack(alignment: .leading, spacing: 6) {
                            // Title and type of transaction
                            HStack {
                                Text(transaction.title ?? "No Title")
                                    .font(.headline)
                                Spacer()
                                Text(transaction.transactionType ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            // Description if available
                            if let desc = transaction.desc, !desc.isEmpty {
                                Text(desc)
                                    .font(.subheadline)
                            }

                            // Amount and date of transaction
                            HStack {
                                Text("Amount: \(transaction.amount, specifier: "%.2f")")
                                Spacer()
                                Text(transaction.date ?? "")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                            }

                            // Display image if available and valid
                            if let imageBase64 = transaction.image,
                               let imageData = Data(base64Encoded: imageBase64),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationBarBackButtonHidden(true)
        //.navigationTitle("\(categoryName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
