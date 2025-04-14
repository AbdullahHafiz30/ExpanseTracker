//
//  EditTransaction.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 15/10/1446 AH.
//

import SwiftUI
import PhotosUI

struct EditTransaction: View {
    
    // Access the shared theme manager for dark/light mode styling
    @EnvironmentObject var themeManager: ThemeManager
    
    // Used to dismiss the current view
    @Environment(\.dismiss) var dismiss
    
    var transaction: Transaction
    
    @State private var price: String = ""
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var date = Date()
    @State private var showDatePicker = false
    @State private var selectedCategory = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var imageData: Data?
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
                        DropDownMenu(
                            title: "Category",
                            options: ["Food", "Transport", "Shopping", "Bills"],
                            selectedOption: $selectedCategory
                        )
                        .environmentObject(themeManager)
                        //amount
                        CustomTextField(placeholder: "Amount", text: $amount,isSecure: .constant(false))
                            .environmentObject(themeManager)
                        //date picker
                        DatePickerField(date: $date, showDatePicker: $showDatePicker)
                            .environmentObject(themeManager)
                        //Description
                        CustomTextField(placeholder: "Description", text: $description,isSecure: .constant(false))
                            .environmentObject(themeManager)
                        //image picker
                        ImagePickerField(imageData: $imageData)
                            .environmentObject(themeManager)
                        //type selector
                        //transactionTypeSelector
                        //the add button
                        //addButton
                        
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
