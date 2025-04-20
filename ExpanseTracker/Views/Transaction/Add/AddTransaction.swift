
import SwiftUI
import PhotosUI
import CoreData

struct AddTransaction: View {
    
    //MARK: - Variables
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var amount: String = ""
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date = Date()
    @State private var showDatePicker = false
    @State private var selectedCategory = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var imageData: Data?
    @State private var amountError: String?
    @StateObject private var transVM = AddTransactionViewModel()
    @State private var selectedType: TransactionType = .income
    @Binding var userId: String
    @StateObject private var categoryVM = CategoryViewModel()
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    //MARK: - View
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    // Background
                    ZStack{
                        themeManager.backgroundColor
                            .ignoresSafeArea()
                        // Show the 2 sections of the page
                        VStack(alignment: .leading) {
                            priceSection
                            formSection
                            
                        }
                        
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CustomBackward(title: "Addtransaction".localized(using: currentLanguage)) {
                        dismiss()
                    }
                }
            }
            // Load the image
//            .onChange(of: imageData) { _, newItem in
//                loadImage(from: newItem)
//            }

        }.navigationBarBackButtonHidden(true)
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
        
    }
}

//MARK: - View extension
private extension AddTransaction {
    // Price section
    var priceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("howMuch".localized(using: currentLanguage))
                .font(.largeTitle)
                .foregroundColor(themeManager.textColor.opacity(0.2))
                .bold()
                .padding(.leading)
            
            HStack {
                if currentLanguage == "en" {
                    Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
               
                VStack{
                    TextField("0", text: $amount)
                        .font(.system(size: 50))
                        .foregroundColor(themeManager.textColor)
                        .onChange(of: amount) { _ , newValue in
                            validateAmount(newValue)
                        }
                    
                    if let error = amountError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                if currentLanguage == "ar" {
                    Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
            }
            .padding(currentLanguage == "en" ? .leading : .trailing)
        }
    }
    // Form section
    var formSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.15))
                .edgesIgnoringSafeArea(.bottom)
                .padding(.bottom,-35)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 20)]) {
                    VStack(spacing: 25){
                        // Title
                        CustomTextField(placeholder: "Title".localized(using: currentLanguage), text: $title,isSecure: .constant(false))
                            .environmentObject(themeManager)
                        // Categories
                        DropDownMenu(
                            title: "Category".localized(using: currentLanguage),
                            options: categoryVM.categories.map{$0.name ?? ""},
                            selectedOption: $selectedCategory
                        )
                        .environmentObject(themeManager)
                        // Date picker
                        DatePickerField(date: $date, showDatePicker: $showDatePicker)
                            .environmentObject(themeManager)
                        //Description
                        CustomTextField(placeholder: "Description".localized(using: currentLanguage), text: $description,isSecure: .constant(false))
                            .environmentObject(themeManager)
                        // Image picker
                        ImagePickerField(imageData: $imageData, image: "")
                            .environmentObject(themeManager)
                        // Type selector
                        transactionTypeSelector
                        // The add button
                        addButton
                        Spacer()
                    }
                    .padding(.top,10)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            
        }
    }
    // The type selector section
    var transactionTypeSelector: some View {
        VStack(alignment: .leading) {
            Text("Transactiontype".localized(using: currentLanguage))
                .font(.title2)
                .foregroundColor(themeManager.textColor.opacity(0.5))
                .padding(.leading, -60)
            
            HStack(spacing: 12) {
                ForEach(TransactionType.allCases) { type in
                    Text(type.rawValue.capitalized.localized(using: currentLanguage))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(selectedType == type ?
                                      themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4) :
                                        themeManager.backgroundColor
                                     )
                        )
                        .overlay(
                            Capsule()
                                .stroke(themeManager.textColor.opacity(0.4), lineWidth: selectedType == type ? 0 : 1)
                        )
                        .foregroundColor(themeManager.textColor)
                        .onTapGesture {
                            selectedType = type
                        }
                }
            }
            .padding(.leading)
        }
    }
    //add button section
    var addButton: some View {
        CustomButton(
            title: "Add".localized(using: currentLanguage),
            action: {
                // Validate amount
                validateAmount(amount)
                if amountError == nil {
                    // Add transaction
                    AddTransactionViewModel().addTransaction(
                        title: title,
                        description: description,
                        amount: Double(amount) ?? 0,
                        date: date,
                        type: selectedType,
                        selectedCategoryName: selectedCategory,
                        imageData: imageData,
                        userId: userId
                    )
                    dismiss()
                }
            }
        )
        .padding(.top, 10)
    }
    // Load image function
//    func loadImage(from item: Data?) {
//        Task {
//            guard let item = item else { return }
//            do {
//                if let data = try await item.loadTransferable(type: Data.self) {
//                    imageData = data
//                }
//            } catch {
//                print("Failed to load image data: \(error)")
//            }
//        }
//    }
    // Validate error mesg for amount
    func validateAmount(_ text: String) {
        if isValidNumber(text) {
            amountError = nil
        } else {
            amountError = "Price must be a number only."
        }
    }
    // Validate function
    func isValidNumber(_ text: String) -> Bool {
        let numberPattern = "^[0-9]+$"
        return text.range(of: numberPattern, options: .regularExpression) != nil
    }
    
}
