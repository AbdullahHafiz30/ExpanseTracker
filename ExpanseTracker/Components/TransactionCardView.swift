//
//  TransactionCardView.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import SwiftUI

/// A card-style view that displays information about a single transaction.
struct TransactionCardView: View {
    
    @StateObject var transaction: TransacionsEntity
    @EnvironmentObject var themeManager: ThemeManager
    var currentLanguage: String
    var userId: String
    var body: some View {
        HStack(spacing: 12) {
            
            // Circle avatar showing the first letter of the transaction title
            Text("\(String(transaction.title?.prefix(1) ?? ""))")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 45, height: 45)
                .background(
                    .black.gradient.opacity(0.15),
                    in: .circle
                )
            
            // VStack for title, description, and date
            VStack(alignment: .leading, spacing: 4) {
                
                // Transaction title
                Text(transaction.title ?? "No Title")
                    .foregroundStyle(.primary)
                
                // Transaction description
                Text(transaction.desc ?? "No Description Provided")
                    .font(.caption)
                    .foregroundStyle(.primary.secondary)
                
                // Formatted transaction date
                Text(transaction.date ?? "No Date Provided")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1) // Prevent text from wrapping into multiple lines
            .hSpacing(.leading) // Custom modifier for horizontal fill and leading alignment
            
            VStack{
                
                NavigationLink(destination: AddOrEditTransactionView(userId: userId ,transaction: transaction, currentLanguage: currentLanguage)) {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 15, height: 15)
                        .padding(.leading, 100)
                }

                HStack{
                    
                    Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    // Transaction amount formatted as currency
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
