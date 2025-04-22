//
//  DetailsHomeView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A SwiftUI view that displays detailed information about a specific transaction.
struct DetailsHomeView: View {
    
    // MARK: - Variable
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    var currentLanguage: String
    let transaction: TransacionsEntity
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                // MARK: - Amount Section
                PriceSection(viewModel: AddOrEditTransactionViewModel(), amountText: nil, readOnlyAmount: transaction.amount, themeManager: _themeManager, currentLanguage: currentLanguage)
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    // MARK: - Title
                    CustomText(text: transaction.title ?? "No Title", placeholder: "TitleD".localized(using: currentLanguage))
                    
                    // MARK: - Category
                    CustomText(text: transaction.category?.name ?? "No Category Selected", placeholder: "CategoryD".localized(using: currentLanguage))
                    
                    // MARK: - Date
                    CustomText(text: transaction.date ?? "No Date Set", placeholder: "DateD".localized(using: currentLanguage))
                    
                    // MARK: - Description
                    CustomText(text: transaction.desc ?? "No Description", placeholder: "DescriptionD".localized(using: currentLanguage))
                    
                    // MARK: - Transaction Type
                    SelectedTransactionType(
                        themeManager: themeManager,
                        selectedType: TransactionType(rawValue: transaction.transactionType ?? "") ?? .expense, currentLanguage: currentLanguage
                    )
                    // MARK: - Receipt Image
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
            ToolbarItem(placement: currentLanguage == "ar" ? .topBarTrailing : .topBarLeading) {
                CustomBackward(title: "TransactionDetails".localized(using: currentLanguage)) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
}
