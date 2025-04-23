//
//  AddOrEditTransactionView.swift
//  ExpanseTracker
//
//  Created by Rawan on 24/10/1446 AH.
//
import SwiftUI
import PhotosUI
import CoreData

struct AddOrEditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var showDatePicker = false
    @State private var isSecure = false
    @StateObject private var viewModel = AddOrEditTransactionViewModel()
    @StateObject private var alertManager = AlertManager.shared
    
    let userId: String
    var transaction: TransacionsEntity?
    var currentLanguage: String
    init(userId: String, transaction: TransacionsEntity? = nil, currentLanguage: String) {
        self.userId = userId
        self.transaction = transaction
        self.currentLanguage = currentLanguage
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                PriceSection(
                    viewModel: viewModel,
                    amountText: $viewModel.amount,
                    readOnlyAmount: nil,
                    themeManager: _themeManager,
                    currentLanguage: currentLanguage
                )
                
                VStack(spacing: 25) {
                    CustomTextField(placeholder: "Title".localized(using: currentLanguage), text: $viewModel.title, isSecure: $isSecure)
                    
                    DropDownMenu(
                        title: "Category".localized(using: currentLanguage),
                        options: viewModel.categories.map { $0.name ?? "" },
                        selectedOption: $viewModel.categoryName
                    )
                    
                    DatePickerField(date: $viewModel.date, showDatePicker: $showDatePicker)
                    
                    CustomTextField(placeholder: "Description".localized(using: currentLanguage), text: $viewModel.description, isSecure: $isSecure)
                    
                    ImagePickerField(imageData: $viewModel.imageData, image: "", currentLanguage: currentLanguage)
                    
                    TransactionTypeSelector(selectedType: $viewModel.type, themeManager: themeManager,currentLanguage: currentLanguage)
                    
                    CustomButton(title: transaction == nil ? "Add".localized(using: currentLanguage) : "Save".localized(using: currentLanguage), action: {
                        
                        guard !viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            AlertManager.shared.showAlert(title: "Error", message: "Title is required!")
                            return
                        }
                        
                        guard let selectedCategory = viewModel.categories.first(where: { $0.name == viewModel.categoryName }) else {
                            AlertManager.shared.showAlert(title: "Error", message: "Category is required!")
                            return
                        }
                        
                        if let existing = transaction {
                            viewModel.updateTransaction(existing, in: viewContext, selectedCategory: selectedCategory)
                        } else {
                            viewModel.addTransaction( title: viewModel.title,
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
                    }) .padding(.top)
                    
                    Spacer()
                }
                .padding()
                .padding(.top,10)
                .background(.gray.opacity(0.15))
                .edgesIgnoringSafeArea(.bottom)
                .cornerRadius(32)
                .padding(.bottom, -50)
            }
        }
        .toolbar {
            ToolbarItem(placement: currentLanguage == "ar" ? .topBarTrailing : .topBarLeading) {
                CustomBackward(title: transaction == nil ? "AddTransaction".localized(using: currentLanguage) : "EditTransaction".localized(using: currentLanguage)) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
        .onAppear {
            viewModel.initialize(with: transaction)
            viewModel.fetchCategories(userId: userId)
        }
        .alert(isPresented: $alertManager.alertState.isPresented) {
            Alert(
                title: Text(alertManager.alertState.title),
                message: Text(alertManager.alertState.message),
                dismissButton: .default(Text("OK")))
        }
    }
}
