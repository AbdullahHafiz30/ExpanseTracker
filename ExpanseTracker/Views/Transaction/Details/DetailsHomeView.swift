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
<<<<<<< Updated upstream
                    PriceSection(amount: nil, readOnlyAmount: transaction.amount, themeManager: themeManager)
=======
                  //  PriceSection(amount: transaction.amount, themeManager: themeManager)
>>>>>>> Stashed changes
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // Display the transaction title
<<<<<<< Updated upstream
                        CustomText(text: transaction.title ?? "No Title", placeholder: "Title:")

                        CustomText(text: transaction.category?.name ?? "No Category", placeholder: "Category:")

                        
                        // Display the formatted transaction date
                        CustomText(
                            text: transaction.date?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted),
                            placeholder: "Date:"
                        )
                        
                        // Display the transaction description
                        CustomText(text: transaction.description ?? "No Description", placeholder: "Description:")
                            .environmentObject(themeManager)
=======
//                        CustomText(text: transaction.title, placeholder: "Title:")
//                        
//                        // Display the transaction's category name
//                        CustomText(text: transaction.category.name, placeholder: "Category:")
//                        
//                        // Display the formatted transaction date
//                        CustomText(
//                            text: transaction.date.formatted(date: .abbreviated, time: .omitted),
//                            placeholder: "Date:"
//                        )
//                        
//                        // Display the transaction description
//                        CustomText(text: transaction.description, placeholder: "Description:")
//                            .environmentObject(themeManager)
>>>>>>> Stashed changes
                        
                        
                        // Display the transaction type
<<<<<<< Updated upstream
                        SelectedTransactionType(themeManager: themeManager, selectedType: transaction.type ?? .income)
                        
                        // Display an attached receipt image
                        ImagePickerField(imageData: $imageData, image: transaction.receiptImage ?? "No Image Provided")
=======
                       // SelectedTransactionType(themeManager: themeManager, selectedType: transaction.type)
                        
                        // Display an attached receipt image
//                        Image(transaction.receiptImage)
//                            .resizable()
//                            .frame(height: 300)
//                            .cornerRadius(10)
>>>>>>> Stashed changes
                        
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
