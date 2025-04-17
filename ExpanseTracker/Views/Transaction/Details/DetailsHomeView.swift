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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Amount
                PriceSection(amount: nil, readOnlyAmount: transaction.amount, themeManager: themeManager)
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Title
                    CustomText(text: transaction.title ?? "No Title", placeholder: "Title:")
                    
                    // Category
                    CustomText(text: transaction.category?.name ?? "No Category Selected", placeholder: "Category:")
                    
                    // Date
                    CustomText(text: transaction.date ?? "No Date Set", placeholder: "Date:")
                    
                    // Description
                    CustomText(text: transaction.desc ?? "No Description", placeholder: "Description:")
                    
                    // Transaction Type
                    SelectedTransactionType(
                        themeManager: themeManager,
                        selectedType: TransactionType(rawValue: transaction.transactionType ?? "") ?? .expense
                    )
                    
                    // Receipt Image
                    ZStack{
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(themeManager.textColor, lineWidth: 1)
                            .frame(height: 350)
                        
                        if let base64String = transaction.image {
                            if let imageData = Data(base64Encoded: base64String),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                            }
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
