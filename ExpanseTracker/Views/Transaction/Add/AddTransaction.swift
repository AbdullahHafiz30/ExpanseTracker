
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
    @StateObject private var categoryVM: CategoryViewModel
    @State private var selectedCategory = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var imageData: Data?
    @State private var amountError: String?
    @StateObject private var transVM = AddTransactionViewModel()
    @State private var selectedType: TransactionType = .income
    @Binding var userId: String
    
    init(userId: Binding<String>) {
            self._userId = userId
            _categoryVM = StateObject(wrappedValue: CategoryViewModel(userId: userId.wrappedValue))
        }
    
    
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
                    CustomBackward(title: "Add transaction") {
                        dismiss()
                    }
                }
            }

        }.navigationBarBackButtonHidden(true)
        
    }
}

//MARK: - View extension
private extension AddTransaction {
    // Price section
    var priceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How much?")
                .font(.largeTitle)
                .foregroundColor(themeManager.textColor.opacity(0.2))
                .bold()
                .padding(.leading)
            
            HStack {
                Image(themeManager.isDarkMode ?  "riyalW":"riyalB")
                    .resizable()
                    .frame(width: 60, height: 60)
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
            }
            .padding(.leading)
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
                        CustomTextField(placeholder: "Title", text: $title,isSecure: .constant(false))
                            .environmentObject(themeManager)
                        // Categories
                        DropDownMenu(
                            title: "Category",
                            options:categoryVM.categories.map { $0.name ?? "" },
                            selectedOption: $selectedCategory
                        )
                        .environmentObject(themeManager)
                        // Date picker
                        DatePickerField(date: $date, showDatePicker: $showDatePicker)
                            .environmentObject(themeManager)
                        //Description
                        CustomTextField(placeholder: "Description", text: $description,isSecure: .constant(false))
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
            Text("Transaction type:")
                .font(.title2)
                .foregroundColor(themeManager.textColor.opacity(0.5))
                .padding(.leading, -60)
            
            HStack(spacing: 12) {
                ForEach(TransactionType.allCases) { type in
                    Text(type.rawValue.capitalized)
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
            title: "Add",
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
                        imageData: imageData
                    )
                    dismiss()
                }
            }
        )
        .padding(.top, 10)
    }

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
        let numberPattern = #"^[0-9.,]+$"#
        return text.range(of: numberPattern, options: .regularExpression) != nil
    }
    
}
