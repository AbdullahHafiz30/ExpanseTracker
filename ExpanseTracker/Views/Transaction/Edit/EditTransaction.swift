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

    let transaction: TransacionsEntity

    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showDatePicker = false
    @State private var isSecure: Bool = false
    
    @StateObject private var viewModel = EditTransactionViewModel()

    @FetchRequest(
        entity: CategoryEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)]
    ) private var categories: FetchedResults<CategoryEntity>

    var body: some View {
        ScrollView {
            LazyVStack {
                ZStack {
                    VStack(alignment: .leading) {
                        PriceSection(amount: $viewModel.editedAmount, readOnlyAmount: nil, themeManager: themeManager)

                        VStack(alignment: .center, spacing: 15) {
                            CustomTextField(placeholder: "Title", text: $viewModel.editedTitle, isSecure: $isSecure)

                            DropDownMenu(
                                title: "Category",
                                options: ["Food", "Transport", "Shopping", "Bills"],
                                selectedOption: $viewModel.editedCategoryName
                            )

                            DatePickerField(date: $viewModel.editedDate, showDatePicker: $showDatePicker)

                            CustomTextField(placeholder: "Description", text: $viewModel.editedDescription, isSecure: $isSecure)

                            TransactionTypeSelector(selectedType: $viewModel.editedType, themeManager: themeManager)

                            ImagePickerField(imageData: $viewModel.imageData, image: "")

                            CustomButton(
                                title: "Save",
                                action: {
                                    viewModel.editTransaction(transaction, in: viewContext, dismiss: {
                                        dismiss()
                                    })
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
                        CustomBackward(title: "Edit Transaction", tapEvent: {
                            dismiss()
                        })
                    }
                }
                .navigationBarBackButtonHidden(true)
                .onChange(of: viewModel.selectedImage) {
                    Task {
                        await viewModel.loadImage(from: viewModel.selectedImage)
                    }
                }
                .onAppear {
                    viewModel.initialize(from: transaction)
                }
            }
        }
    }
}
