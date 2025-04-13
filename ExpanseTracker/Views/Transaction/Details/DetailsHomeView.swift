//
//  DetailsHomeView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A SwiftUI view that displays detailed information about a specific transaction.
struct DetailsHomeView: View {
    
    // Access the shared theme manager for dark/light mode styling
    @EnvironmentObject var themeManager: ThemeManager
    
    // Used to dismiss the current view
    @Environment(\.dismiss) var dismiss
    
    // The transaction to display details for
    var transaction: Transaction
    
    var body: some View {
        ScrollView {
            ZStack {
                // Background color for the entire view
                Color.white
                
                VStack(alignment: .leading) {
                    
                    // Display the transaction amount using a styled price section
                    PriceSection(amount: transaction.amount, themeManager: themeManager)
                    
                    VStack(alignment: .leading) {
                        
                        // Display the transaction title
                        CustomText(text: transaction.title, placeholder: "Title:")
                        
                        // Display the transaction's category name
                        CustomText(text: transaction.category.name, placeholder: "Category:")
                        
                        // Display the formatted transaction date
                        CustomText(
                            text: transaction.date.formatted(date: .abbreviated, time: .omitted),
                            placeholder: "Date:"
                        )
                        
                        // Display the transaction description
                        CustomText(text: transaction.description, placeholder: "Description:")
                            .environmentObject(themeManager)
                        
                        // Display the transaction type
                        TransactionTypeSelector(themeManager: themeManager, selectedType: transaction.type)
                        
                        // Display an attached receipt image
                        Image(transaction.receiptImage)
                            .resizable()
                            .frame(height: 300)
                            .cornerRadius(10)
                        
                        Spacer() // Push content to the top
                    }
                    .padding()
                    .ignoresSafeArea(edges: .bottom)
                    .background(.gray.opacity(0.15))
                    .cornerRadius(32)
                    .padding(.bottom, -35) // Adjust bottom spacing
                }
            }
            // Custom toolbar with localized title and dismiss button
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HeaderSection(title: "Transaction Details", action: {
                        dismiss() // Dismiss the view when the header arrow is tapped
                    })
                }
            }
            .navigationBarBackButtonHidden(true) // Hide the default navigation back button
        }
    }
}
