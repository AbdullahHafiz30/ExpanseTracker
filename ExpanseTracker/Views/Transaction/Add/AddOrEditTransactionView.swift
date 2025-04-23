//
//  AddOrEditTransactionView.swift
//  ExpanseTracker
//
//  Created by Rawan on 24/10/1446 AH.
//

import SwiftUI
import PhotosUI
import CoreData

/// A form-based view used to add a new transaction or edit an existing one.
struct AddOrEditTransactionView: View {
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.managedObjectContext) var viewContext
    
    // MARK: - State & ViewModels
    @State private var showDatePicker = false
    @State private var isSecure = false
    @StateObject private var viewModel = AddOrEditTransactionViewModel()
    @StateObject private var alertManager = AlertManager.shared
    
    // MARK: - Input
    let userId: String
    var transaction: TransacionsEntity?
    var currentLanguage: String

    // MARK: - Initializer
    init(userId: String, transaction: TransacionsEntity? = nil, currentLanguage: String) {
        self.userId = userId
        self.transaction = transaction
        self.currentLanguage = currentLanguage
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: - Amount Input Section
                PriceSection(
                    viewModel: viewModel,
                    amountText: $viewModel.amount,
                    readOnlyAmount: nil,
                    themeManager: _themeManager,
                    currentLanguage: currentLanguage
                )
                
                // MARK: - Form Fields
                VStack(spacing: 25) {
                    
                    // Title TextField
                    CustomTextField(
                        placeholder: "Title".localized(using: currentLanguage),
                        text: $viewModel.title,
                        isSecure: $isSecure
                    )
                    
                    // Category Dropdown
                    DropDownMenu(
                        title: "Category".localized(using: currentLanguage),
                        options: viewModel.categories.map { $0.name ?? "" },
                        selectedOption: $viewModel.categoryName
                    )
                    
                    // Date Picker Field
                    DatePickerField(date: $viewModel.date, showDatePicker: $showDatePicker)
                    
                    // Description TextField
                    CustomTextField(
                        placeholder: "Description".localized(using: currentLanguage),
                        text: $viewModel.description,
                        isSecure: $isSecure
                    )
                    
                    // Image Picker for receipt
                    ImagePickerField(
                        imageData: $viewModel.imageData,
                        image: "",
                        currentLanguage: currentLanguage
                    )
                    
                    // Transaction Type Selector
                    TransactionTypeSelector(
                        selectedType: $viewModel.type,
                        themeManager: themeManager,
                        currentLanguage: currentLanguage
                    )
                    
                    // MARK: - Submit Button (Add or Save)
                    CustomButton(
                        title: transaction == nil
                            ? "Add".localized(using: currentLanguage)
                            : "Save".localized(using: currentLanguage)
                    ) {
                        // Validation: Title is required
                        guard !viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            alertManager.showAlert(title: "Error", message: "Title is required!")
                            return
                        }
                        
                        // Validation: Must select a category
                        guard let selectedCategory = viewModel.categories.first(where: { $0.name == viewModel.categoryName }) else {
                            alertManager.showAlert(title: "Error", message: "Category is required!")
                            return
                        }
                        
                        // Update existing transaction or add a new one
                        if let existing = transaction {
                            viewModel.updateTransaction(existing, in: viewContext, selectedCategory: selectedCategory)
                        } else {
                            viewModel.addTransaction(
                                title: viewModel.title,
                                description: viewModel.description,
                                amount: Double(viewModel.amount) ?? 0.0,
                                date: viewModel.date,
                                type: viewModel.type,
                                selectedCategoryName: viewModel.categoryName,
                                imageData: viewModel.imageData,
                                userId: userId
                            )
                        }
                        
                        dismiss()
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
                .padding(.top, 10)
                .background(.gray.opacity(0.15))
                .edgesIgnoringSafeArea(.bottom)
                .cornerRadius(32)
                .padding(.bottom, -50)
            }
        }
        // MARK: - Toolbar with custom back button
        .toolbar {
            ToolbarItem(placement: currentLanguage == "ar" ? .topBarTrailing : .topBarLeading) {
                CustomBackward(
                    title: transaction == nil
                        ? "AddTransaction".localized(using: currentLanguage)
                        : "EditTransaction".localized(using: currentLanguage)
                ) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
        // Adjust layout direction based on current language
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
        
        // MARK: - OnAppear: Load data
        .onAppear {
            viewModel.initialize(with: transaction)
            viewModel.fetchCategories(userId: userId)
        }

        // MARK: - Global alert for validation or errors
        .alert(isPresented: $alertManager.alertState.isPresented) {
            Alert(
                title: Text(alertManager.alertState.title),
                message: Text(alertManager.alertState.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
