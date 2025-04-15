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
    
    @State private var isSecure: Bool = false

    // Initialize editable values with the current transaction
    init(transaction: Transaction) {
        _editedAmount = State(initialValue: transaction.amount ?? 0.0)
        _editedType = State(initialValue: transaction.type ?? .income)
        self.transaction = transaction
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ZStack {
                    VStack(alignment: .leading) {
                        
                        // Price display + input
                        PriceSection(amount: $editedAmount, readOnlyAmount: nil, themeManager: themeManager)
                        
                        VStack(alignment: .center, spacing: 15) {
                            
                            // Title
                            CustomTextField(placeholder: "\(transaction.title ?? "No Title")", text: $editedTitle, isSecure: $isSecure)
                            
                            // Category dropdown
                            DropDownMenu(
                                title: "\(transaction.category?.name ?? "No Category")",
                                options: ["Food", "Transport", "Shopping", "Bills"],
                                selectedOption: $editedCategory
                            )
                            
                            // Date picker
                            DatePickerField(date: $editedDate, showDatePicker: $showDatePicker)
                            
                            // Description
                            CustomTextField(placeholder: "\(transaction.description ?? "No Description")", text: $editedDescription, isSecure: $isSecure)
                            
                            // Transaction type selector
                            TransactionTypeSelector(selectedType: $editedType, themeManager: themeManager)
                            
                            // Image picker
                            ImagePickerField(imageData: $imageData, image: transaction.receiptImage ?? "No Image Provided")
                            
                            // Save button
                            CustomButton(
                                title: "Save",
                                action: saveTransaction
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
    
    func saveTransaction() {
        withAnimation {
            transaction.title = editedTitle
            transaction.date = editedDate
            transaction.description = editedDescription
            transaction.type = editedType
            transaction.amount = editedAmount
            
            if let existingCategory = transaction.category {
                transaction.category = Category(
                    id: existingCategory.id,
                    name: editedCategory,
                    color: existingCategory.color,
                    icon: existingCategory.icon,
                    categoryType: existingCategory.categoryType,
                    budgetLimit: existingCategory.budgetLimit
                )
            }

            // Save selected image path
            if let imageData {
                let path = saveDataLocallyAndReturnPath(data: imageData)
                transaction.receiptImage = path
            }
            
            PersistanceController.shared.saveContext()
            dismiss()
        }
    }

}
