//
//  DetailsHomeView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A SwiftUI view that displays detailed information about a specific transaction.
struct DetailsHomeView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    let transaction: TransacionsEntity
    
    @State private var imageData: Data?
    
    var formattedTransactionDate: String {
        guard let dateString = transaction.date else {
            return "No Date Provided"
        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd MMM yyyy" 
        
        if let date = inputFormatter.date(from: dateString) {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
        
        return "No Date Provided"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Amount
                PriceSection(amount: nil, readOnlyAmount: transaction.amount, themeManager: themeManager)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    // Title
                    CustomText(text: transaction.title ?? "No Title", placeholder: "Title:")
                    
                    // Category
                    CustomText(text: transaction.category?.name ?? "No Category", placeholder: "Category:")
                    
                    // Date
                    CustomText(text: formattedTransactionDate, placeholder: "Date:")
                    
                    // Description
                    CustomText(text: transaction.desc ?? "No Description", placeholder: "Description:")
                    
                    // Transaction Type
                    SelectedTransactionType(
                        themeManager: themeManager,
                        selectedType: TransactionType(rawValue: transaction.transactionType ?? "") ?? .expense
                    )

                    // Receipt Image
                    if let base64String = transaction.receiptImage {
                        if let imageData = Data(base64Encoded: base64String),
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.gray.opacity(0.15))
                .cornerRadius(32)
                .padding(.bottom, -35)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackward(title: "Transaction Details") {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
