//
//  DetailsHomeView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A SwiftUI view that displays detailed, read-only information about a specific transaction.
/// Includes amount, title, category, date, description, type, and an optional receipt image.
struct DetailsHomeView: View {
    
    // MARK: - Environment
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Input
    var currentLanguage: String
    let transaction: TransacionsEntity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: - Read-Only Amount Display
                PriceSection(
                    viewModel: AddOrEditTransactionViewModel(),
                    amountText: nil,
                    readOnlyAmount: transaction.amount,
                    themeManager: _themeManager,
                    currentLanguage: currentLanguage
                )
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    // MARK: - Transaction Title
                    CustomText(
                        text: transaction.title ?? "No Title",
                        placeholder: "TitleD".localized(using: currentLanguage)
                    )
                    
                    // MARK: - Category Name
                    CustomText(
                        text: transaction.category?.name ?? "No Category Selected",
                        placeholder: "CategoryD".localized(using: currentLanguage)
                    )
                    
                    // MARK: - Transaction Date
                    CustomText(
                        text: transaction.date ?? "No Date Set",
                        placeholder: "DateD".localized(using: currentLanguage)
                    )
                    
                    // MARK: - Description Field
                    CustomText(
                        text: transaction.desc ?? "No Description",
                        placeholder: "DescriptionD".localized(using: currentLanguage)
                    )
                    
                    // MARK: - Transaction Type Capsule Display
                    SelectedTransactionType(
                        themeManager: themeManager,
                        selectedType: TransactionType(rawValue: transaction.transactionType ?? "") ?? .expense,
                        currentLanguage: currentLanguage
                    )
                    
                    // MARK: - Receipt Image Preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(themeManager.textColor, lineWidth: 1)
                            .frame(height: 350)
                        
                        if let base64String = transaction.image,
                           !base64String.isEmpty,
                           let imageData = Data(base64Encoded: base64String),
                           let uiImage = UIImage(data: imageData) {
                            
                            // If an image is attached, show it
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                        } else {
                            // Fallback placeholder image
                            Image("Photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 350, height: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.gray.opacity(0.15))
                .ignoresSafeArea(edges: .bottom)
                .cornerRadius(32)
                .padding(.bottom, -50)
            }
        }
        
        // MARK: - Toolbar with Custom Back Button
        .toolbar {
            ToolbarItem(placement: currentLanguage == "ar" ? .topBarTrailing : .topBarLeading) {
                CustomBackward(title: "TransactionDetails".localized(using: currentLanguage)) {
                    dismiss()
                }
            }
        }
        
        .navigationBarBackButtonHidden(true)
        
        // MARK: - Language-Based Layout Direction
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
}
