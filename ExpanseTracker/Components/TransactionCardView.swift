//
//  TransactionCardView.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import SwiftUI

/// A card-style view that displays key information about a single transaction,
/// including its title, category icon, description, amount, and a button to edit the transaction.
struct TransactionCardView: View {
    
    @StateObject var transaction: TransacionsEntity
    @EnvironmentObject var themeManager: ThemeManager
    var currentLanguage: String
    var userId: String
    
    var body: some View {
        HStack(spacing: 12) {
            
            // MARK: - Category Icon Circle (colored by category)
            Image(systemName: transaction.category?.icon ?? "")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(UIColor().colorFromHexString(transaction.category?.color ?? ""))
                .frame(width: 45, height: 45)
                .background(
                    Color(UIColor().colorFromHexString(transaction.category?.color ?? "")
                        .opacity(themeManager.isDarkMode ? 0.3 : 0.2)),
                    in: .circle
                )
            
            // MARK: - Transaction Info (Title, Description, Date)
            VStack(alignment: .leading, spacing: 4) {
                
                // Title of the transaction
                Text(transaction.title ?? "No Title")
                    .foregroundStyle(.primary)
                
                // Transaction description
                Text(transaction.desc ?? "No Description Provided")
                    .font(.caption)
                    .foregroundStyle(.primary.secondary)
                
                // Transaction Date
                Text(transaction.date ?? "No Date Provided")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1) // Restrict all text lines to a single line
            .hSpacing(.leading)
            
            VStack {
                
                // MARK: - Edit Transaction Button
                NavigationLink(destination: AddOrEditTransactionView(userId: userId, transaction: transaction, currentLanguage: currentLanguage)) {

                    Image(systemName: "pencil.circle")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 15, height: 15)
                        .padding(.leading, 100)
                }

                HStack(spacing: 4) {
                    // Currency icon
                    Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    // Formatted amount
                    Text(NumberFormatterManager.shared.decimalString(from: transaction.amount))
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.gray.opacity(0.15))
        .background(.background, in: .rect(cornerRadius: 10))
    }
}
