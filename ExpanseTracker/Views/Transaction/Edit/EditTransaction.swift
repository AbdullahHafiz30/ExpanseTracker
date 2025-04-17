//
//  EditTransaction.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 15/10/1446 AH.
//

import SwiftUI
import PhotosUI
import CoreData

struct EditTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var showDatePicker = false
    @State private var isSecure: Bool = false
    @StateObject private var viewModel = EditTransactionViewModel()
    
    let transaction: TransacionsEntity
    
    @FetchRequest(
        entity: CategoryEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)]
    ) private var categories: FetchedResults<CategoryEntity>
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                
                // Amount
                PriceSection(amount: $viewModel.editedAmount, readOnlyAmount: nil, themeManager: themeManager)
                
                VStack(alignment: .center, spacing: 25) {
                    
                    // Title
                    CustomTextField(placeholder: "Title", text: $viewModel.editedTitle, isSecure: $isSecure)
                    
                    // Category
                    DropDownMenu(
                        title: "Category",
                        options: ["Food", "Transport", "Shopping", "Bills"],
                        selectedOption: $viewModel.editedCategoryName
                    )
                    
                    // Date
                    DatePickerField(date: $viewModel.editedDate, showDatePicker: $showDatePicker)
                    
                    // Description
                    CustomTextField(placeholder: "Description", text: $viewModel.editedDescription, isSecure: $isSecure)
                    
                    // Transaction Type
                    TransactionTypeSelector(selectedType: $viewModel.editedType, themeManager: themeManager)
                    
                    // Receipt Image
                    ImagePickerField(imageData: $viewModel.imageData, image: "")
                    
                    // Save Button
                    CustomButton(
                        title: "Save",
                        action: {
                            viewModel.editTransaction(transaction, viewContext: viewContext, dismiss: {
                                dismiss()
                            })
                        }
                    )
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackward(title: "Edit Transaction", tapEvent: {
                    dismiss()
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.initialize(transaction: transaction)
        }
    }
}
