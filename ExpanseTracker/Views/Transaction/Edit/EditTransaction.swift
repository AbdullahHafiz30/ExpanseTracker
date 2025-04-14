//
//  EditTransaction.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 15/10/1446 AH.
//

import SwiftUI
import PhotosUI

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss

    // Transaction for editing
    @State var transaction: Transaction
    
    @EnvironmentObject var themeManager: ThemeManager
    
    // UI states
    @State private var showDatePicker = false
    
    // Fields to edit
    @State private var editedTitle: String = ""
    @State private var editedDescription: String = ""
    @State private var editedDate = Date()
    @State private var editedCategory = ""
    @State private var editedType: TransactionType
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var imageData: Data?
    @State private var editedAmount: Double = 0.0

    // Initialize editable values with the current transaction
    init(transaction: Transaction) {
        _editedAmount = State(initialValue: transaction.amount)
        _editedType = State(initialValue: transaction.type)
        self.transaction = transaction
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ZStack {
                    Color.white
                    
                    VStack(alignment: .leading) {
                        
                        // Price display + input
                        PriceSection(amount: $editedAmount, readOnlyAmount: nil, themeManager: themeManager)
                        
                        VStack(alignment: .center, spacing: 15) {
                            
                            // Title
                            CustomTextField(placeholder: "\(transaction.title)", text: $editedTitle)
                            
                            // Category dropdown
                            DropDownMenu(
                                title: "\(transaction.category.name)",
                                options: ["Food", "Transport", "Shopping", "Bills"],
                                selectedOption: $editedCategory
                            )
                            
                            // Date picker
                            DatePickerField(date: $editedDate, showDatePicker: $showDatePicker)
                            
                            // Description
                            CustomTextField(placeholder: "\(transaction.description)", text: $editedDescription)
                            
                            // Transaction type selector
                            TransactionTypeSelector(selectedType: $editedType, themeManager: themeManager)
                            
                            // Image picker
                            ImagePickerField(imageData: $imageData, image: transaction.receiptImage)
                            
                            // Save button
                            CustomButton(
                                title: "Save",
                                action: {
                                    withAnimation {
                                        // Update Core Data transaction
                                        transaction.title = editedTitle
                                        transaction.category = Category(
                                            id: transaction.category.id,
                                            name: editedCategory,
                                            color: transaction.category.color,
                                            icon: transaction.category.icon,
                                            categoryType: transaction.category.categoryType,
                                            budgetLimit: transaction.category.budgetLimit
                                        )
                                        transaction.date = editedDate
                                        transaction.description = editedDescription
                                        transaction.type = editedType
                                        transaction.amount = editedAmount
                                        
                                        // Save selected image path
                                        if let imageData {
                                            let path = saveDataLocallyAndReturnPath(data: imageData)
                                            transaction.receiptImage = path
                                        }
                                        
                                        // Save changes to Core Data
                                        PersistanceController.shared.saveContext()
                                        
                                        // Dismiss view
                                        dismiss()
                                    }
                                }
                            )
                            .padding(.top, 10)
                            
                            Spacer()
                        }
                        .padding()
                        .ignoresSafeArea(edges: .bottom)
                        .background(.gray.opacity(0.15))
                        .cornerRadius(32)
                        .frame(maxWidth: 400)
                        .padding(.bottom, -35)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HeaderSection(title: "Edit Transaction", action: {
                            dismiss()
                        })
                    }
                }
                .navigationBarBackButtonHidden(true)
                .onChange(of: selectedImage) { _, newItem in
                    loadImage(from: newItem)
                }
            }
        }
    }

    // Load image data when selected
    func loadImage(from item: PhotosPickerItem?) {
        Task {
            guard let item = item else { return }
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    imageData = data
                }
            } catch {
                print("Failed to load image data: \(error)")
            }
        }
    }

    // Save image to local storage and return the file path
    func saveDataLocallyAndReturnPath(data: Data) -> String {
        let fileName = UUID().uuidString + ".jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? data.write(to: url)
        return url.path
    }
}
