////
////  EditTransaction.swift
////  ExpanseTracker
////
////  Created by Tahani Ayman on 15/10/1446 AH.
////
//
//import SwiftUI
//import PhotosUI
//import CoreData
//
//struct AddTransaction: View {
//    //MARK: - Variables
//    @Environment(\.dismiss) var dismiss
//    
//    @EnvironmentObject var themeManager: ThemeManager
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @State private var showDatePicker = false
//    @State private var isSecure: Bool = false
//    
//    @State private var title: String = ""
//    @State private var description: String = ""
//    @State private var amount: Double = 0.0
//    @State private var date: Date = Date()
//    @State private var type: TransactionType = .income
//    @State private var selectedCategoryName: String = "Food"
//    @State private var selectedImage: PhotosPickerItem? = nil
//    @State private var imageData: Data?
//    @State private var amountError: String?
//    //        init(userVM: UserViewModel) {
//    //            _transactionVM = StateObject(wrappedValue: TransactionViewModel(userVM: userVM))
//    //        }
//    
//    // Enum of the types of the transactions
//    enum transactionType: String, CaseIterable, Identifiable {
//        case income
//        case expense
//        var id: String { self.rawValue }
//    }
//    @State private var selectedType: transactionType = .income
//    var body: some View {
//        NavigationStack {
//            ScrollView(.vertical) {
//                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
//                    // Background
//                    ZStack{
//                        themeManager.backgroundColor
//                            .ignoresSafeArea()
//                        // Show the 3 sections of the page
//                        VStack(alignment: .leading) {
//                            headerSection
//                            priceSection
//                            formSection
//                            
//                        }
//                        
//                    }
//                }
//            }
//            // Load the image
//            .onChange(of: selectedImage) { _, newItem in
//                loadImage(from: newItem)
//            }
//            
//            VStack(alignment: .center, spacing: 15) {
//                CustomTextField(placeholder: "Title", text: $title, isSecure: $isSecure)
//                
//            
//                private extension AddTransaction {
//                    //MARK: - View
//                    // Header section
//                    var headerSection: some View {
//                        HStack {
//                            Button(action: {
//                                dismiss()
//                            }) {
//                                Image(systemName: "arrow.left")
//                                    .foregroundColor(themeManager.textColor)
//                                    .font(.system(size: 25))
//                            }
//                            .padding()
//                            
//                            Text("Add transaction")
//                                .bold()
//                                .font(.largeTitle)
//                                .foregroundColor(themeManager.textColor)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.top,10)
//                    }
//                    // Price section
//                    var priceSection: some View {
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text("How much?")
//                                .font(.largeTitle)
//                                .foregroundColor(themeManager.textColor.opacity(0.2))
//                                .bold()
//                                .padding(.leading)
//                            
//                            HStack {
//                                Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
//                                    .resizable()
//                                    .frame(width: 60, height: 60)
//                                VStack{
//                                    TextField("0", text: $amount)
//                                        .font(.system(size: 50))
//                                        .foregroundColor(themeManager.textColor)
//                                        .onChange(of: amount) { _ , newValue in
//                                            validateAmount(newValue)
//                                        }
//                                        .padding()
//                                        .ignoresSafeArea(edges: .bottom)
//                                        .background(.gray.opacity(0.15))
//                                        .cornerRadius(32)
//                                        .frame(maxWidth: 400)
//                                        .padding(.bottom, -35)
//                                }
//                            }
//                            
//                        }
//                        .padding(.leading)
//                    }
//                }
//                // Form section
//                var formSection: some View {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 32)
//                            .fill(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.15))
//                            .edgesIgnoringSafeArea(.bottom)
//                            .padding(.bottom,-35)
//                        
//                        ScrollView(showsIndicators: false) {
//                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 20)]) {
//                                VStack(spacing: 25){
//                                    // Title
//                                    CustomTextField(placeholder: "Title", text: $title,isSecure: .constant(false))
//                                        .environmentObject(themeManager)
//                                    // Categories
//                                    DropDownMenu(
//                                        title: "Category",
//                                        options: ["Food", "Transport", "Shopping", "Bills"],
//                                        selectedOption: $selectedCategory
//                                    )
//                                    .environmentObject(themeManager)
//                                    // Date picker
//                                    DatePickerField(date: $date, showDatePicker: $showDatePicker)
//                                        .environmentObject(themeManager)
//                                    //Description
//                                    CustomTextField(placeholder: "Description", text: $description,isSecure: .constant(false))
//                                        .environmentObject(themeManager)
//                                    // Image picker
//                                    ImagePickerField(imageData: $imageData, image: "")
//                                        .environmentObject(themeManager)
//                                    // Type selector
//                                    transactionTypeSelector
//                                    // The add button
//                                    addButton
//                                    Spacer()
//                                }
//                            }
//                            
//                            .frame(maxWidth: .infinity)
//                            .padding(.horizontal)
//                        }
//                        
//                    }
//                }
//                // The type selector section
//                var transactionTypeSelector: some View {
//                    VStack(alignment: .leading) {
//                        Text("Transaction type:")
//                            .font(.title2)
//                            .foregroundColor(themeManager.textColor.opacity(0.5))
//                            .padding(.leading, -60)
//                        
//                        HStack(spacing: 12) {
//                            ForEach(transactionType.allCases) { type in
//                                Text(type.rawValue.capitalized)
//                                    .padding(.horizontal, 24)
//                                    .padding(.vertical, 12)
//                                    .background(
//                                        Capsule()
//                                            .fill(selectedType == type ?
//                                                  themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4) :
//                                                    themeManager.backgroundColor
//                                                 )
//                                    )
//                                    .overlay(
//                                        Capsule()
//                                            .stroke(themeManager.textColor.opacity(0.4), lineWidth: selectedType == type ? 0 : 1)
//                                    )
//                                    .foregroundColor(themeManager.textColor)
//                                    .onTapGesture {
//                                        selectedType = type
//                                    }
//                            }
//                        }
//                        .padding(.leading)
//                    }
//                }
//                //add button section
//                var addButton: some View {
//                    CustomButton(
//                        title: "Add",
//                        action: {
//                            // Validate amount
//                            validateAmount(amount)
//                            if amountError == nil {
//                                // Add transaction
//                                transactionVM.addTransaction(
//                                    title: title,
//                                    description: description,
//                                    amount: amount,
//                                    date: date,
//                                    type: selectedType,
//                                    selectedCategoryName: selectedCategory,
//                                    imageData: imageData
//                                )
//                                dismiss()
//                            }
//                        }
//                    )
//                    .padding(.top, 10)
//                }
//                // Load image function
//                func loadImage(from item: PhotosPickerItem?) {
//                    Task {
//                        guard let item = item else { return }
//                        do {
//                            if let data = try await item.loadTransferable(type: Data.self) {
//                                imageData = data
//                            }
//                        } catch {
//                            print("Failed to load image data: \(error)")
//                        }
//                    }
//                }
//                // Validate error mesg for amount
//                func validateAmount(_ text: String) {
//                    if isValidNumber(text) {
//                        amountError = nil
//                    } else {
//                        amountError = "Price must be a number only."
//                    }
//                }
//                // Validate function
//                func isValidNumber(_ text: String) -> Bool {
//                    let numberPattern = "^[0-9]+$"
//                    return text.range(of: numberPattern, options: .regularExpression) != nil
//                }
//                
//                private func addTransaction() {
//                    let newTransaction = TransacionsEntity(context: viewContext)
//                    newTransaction.id = UUID().uuidString
//                    newTransaction.title = title
//                    newTransaction.desc = description
//                    newTransaction.amount = amount
//                    
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd"
//                    newTransaction.date = formatter.string(from: date)
//                    
//                    newTransaction.transactionType = type.rawValue
//                    
//                    // Convert image data to Base64 string
//                    if let imageData = imageData {
//                        newTransaction.receiptImage = imageData.base64EncodedString()
//                    }
//                    
//                    // Fetch category
//                    let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//                    fetchRequest.predicate = NSPredicate(format: "name == %@", selectedCategoryName)
//                    
//                    do {
//                        let results = try viewContext.fetch(fetchRequest)
//                        if let matchedCategory = results.first {
//                            newTransaction.category = matchedCategory
//                        }
//                    } catch {
//                        print("Error fetching category: \(error.localizedDescription)")
//                    }
//                    
//                    PersistanceController.shared.saveContext()
//                }
//            }
//        }
//    }
//}
