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
    @State private var imageData: Data?
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading) {
                    
                    // Display the transaction amount using a styled price section
                    PriceSection(amount: nil, readOnlyAmount: transaction.amount, themeManager: themeManager)
                    
                    VStack(alignment: .leading) {
                        
                        // Display the transaction title
                        CustomText(text: transaction.title ?? "No Title", placeholder: "Title:")
                        
                        // Display the transaction's category name
<<<<<<< Updated upstream
                        CustomText(text: transaction.category?.name ?? "No Category", placeholder: "Category:")
=======
                        CustomText(text: transaction.category.name ?? "" , placeholder: "Category:")
>>>>>>> Stashed changes
                        
                        // Display the formatted transaction date
                        CustomText(
                            text: transaction.date?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted),
                            placeholder: "Date:"
                        )
                        
                        // Display the transaction description
                        CustomText(text: transaction.description ?? "No Description", placeholder: "Description:")
                            .environmentObject(themeManager)
                        
                        
                        // Display the transaction type
                        SelectedTransactionType(themeManager: themeManager, selectedType: transaction.type ?? .income)
                        
                        // Display an attached receipt image
                        ImagePickerField(imageData: $imageData, image: transaction.receiptImage ?? "No Image Provided")
                        
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
