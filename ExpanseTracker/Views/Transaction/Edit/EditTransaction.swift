//
//  EditTransaction.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 15/10/1446 AH.
//

import SwiftUI
import PhotosUI
import CoreData

/// A view for editing an existing transaction. Pre-fills fields with existing data and allows the user
/// to modify details like amount, title, category, type, date, and receipt image.
struct EditTransactionView: View {
    
    // Dismisses the view
    @Environment(\.dismiss) var dismiss
    // Core Data context
    @Environment(\.managedObjectContext) private var viewContext
    // Theme manager for color and appearance
    @EnvironmentObject var themeManager: ThemeManager
    
    // Toggles date picker visibility
    @State private var showDatePicker = false
    // Secure input
    @State private var isSecure: Bool = false
    
    // ViewModel managing state and logic
    @StateObject private var viewModel = EditTransactionViewModel()
    
    // The Core Data transaction to be edited
    let transaction: TransacionsEntity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: - Amount Input Section
                PriceSection(
                    amount: $viewModel.editedAmount,
                    readOnlyAmount: nil,
                    themeManager: themeManager
                )
                
                VStack(alignment: .center, spacing: 25) {
                    
                    // MARK: - Title Input
                    CustomTextField(
                        placeholder: "Title",
                        text: $viewModel.editedTitle,
                        isSecure: $isSecure
                    )
                    
                    // MARK: - Category Dropdown
                    DropDownMenu(
                        title: "Category",
                        options: viewModel.categories.compactMap { $0.name },
                        selectedOption: $viewModel.editedCategoryName
                    )
                    
                    // MARK: - Date Picker
                    DatePickerField(
                        date: $viewModel.editedDate,
                        showDatePicker: $showDatePicker
                    )
                    
                    // MARK: - Description Input
                    CustomTextField(
                        placeholder: "Description",
                        text: $viewModel.editedDescription,
                        isSecure: $isSecure
                    )
                    
                    // MARK: - Transaction Type Selector
                    TransactionTypeSelector(
                        selectedType: $viewModel.editedType,
                        themeManager: themeManager
                    )
                    
                    // MARK: - Image Picker
                    ImagePickerField(
                        imageData: $viewModel.imageData,
                        image: ""
                    )
                    
                    // MARK: - Save Button
                    CustomButton(title: "Save", action: {
                        // Validate title
                        guard !viewModel.editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            AlertManager.shared.showAlert(title: "Error", message: "Title is required!")
                            return
                        }

                        // Find the selected category entity
                        let selectedCategory = viewModel.categories.first { $0.name == viewModel.editedCategoryName }
                        
                        guard let categoryEntity = selectedCategory else {
                            AlertManager.shared.showAlert(title: "Error", message: "Category is required!")
                            return
                        }

                        // Create updated model from user input
                        let updatedTransaction = Transaction(
                            id: transaction.id,
                            title: viewModel.editedTitle,
                            description: viewModel.editedDescription,
                            amount: viewModel.editedAmount,
                            date: viewModel.editedDate,
                            transactionType: viewModel.editedType,
                            category: Category(
                                id: categoryEntity.id,
                                name: categoryEntity.name,
                                color: categoryEntity.color,
                                icon: categoryEntity.icon,
                                categoryType: CategoryType(rawValue: categoryEntity.categoryType ?? ""),
                                budgetLimit: categoryEntity.budgetLimit
                            ),
                            receiptImage: viewModel.imageData?.base64EncodedString()
                        )

                        // Save the changes through the view model
                        viewModel.editTransaction(transaction, updated: updatedTransaction)
                        dismiss()
                    })
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding()
                .background(.gray.opacity(0.15))
                .ignoresSafeArea(edges: .bottom)
                .cornerRadius(32)
                .padding(.bottom, -35)
            }
        }
        // MARK: - Toolbar with Custom Back Button
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackward(title: "Edit Transaction", tapEvent: {
                    dismiss()
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        
        // MARK: - Load Data on Appear
        .onAppear {
            viewModel.initialize(transaction: transaction)
            viewModel.fetchCategories()
        }
    }
}
