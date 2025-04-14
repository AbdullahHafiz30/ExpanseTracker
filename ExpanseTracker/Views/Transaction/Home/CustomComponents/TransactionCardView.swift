//
//  TransactionCardView.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import SwiftUI

/// A card-style view that displays information about a single transaction.
struct TransactionCardView: View {
    
    var transaction: Transaction  // The transaction data to display
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Circle avatar showing the first letter of the transaction title
            Text("\(String(transaction.title.prefix(1)))")
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
                Text(transaction.title)
                    .foregroundStyle(.primary)
                
                // Transaction description
                Text(transaction.description)
                    .font(.caption)
                    .foregroundStyle(.primary.secondary)
                
                // Formatted transaction date
                Text(format(date: transaction.date, format: "dd MMM yyyy"))
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1) // Prevent text from wrapping into multiple lines
            .hSpacing(.leading) // Custom modifier for horizontal fill and leading alignment
            
            VStack{
                Button(action: {}, label: {
                    Image(systemName: "pencil")
                        .font(.title)
                })
                .padding([.bottom, .leading])
                // Transaction amount formatted as currency
                Text(currencyString(transaction.amount, allowedDigits: 1))
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: 10))
    }
}
