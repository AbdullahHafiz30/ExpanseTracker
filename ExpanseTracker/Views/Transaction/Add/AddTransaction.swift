import SwiftUI
import PhotosUI
import CoreData
struct AddTransaction: View {
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
    @StateObject private var transactionVM: TransactionViewModel
//        init(userVM: UserViewModel) {
//            _transactionVM = StateObject(wrappedValue: TransactionViewModel(userVM: userVM))
//        }
    
    //enum of the types of the transactions
    enum transactionType: String, CaseIterable, Identifiable {
        case income
        case expense
        var id: String { self.rawValue }
    }
    @State private var selectedType: transactionType = .income
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    //background
                    ZStack{
                        themeManager.backgroundColor
                            .ignoresSafeArea()
                        //show the 3 sections of the page
                        VStack(alignment: .leading) {
                            headerSection
                            priceSection
                            formSection
                            
                        }
                        
                    }
                }
            }
            //load the image
            .onChange(of: selectedImage) { _, newItem in
                loadImage(from: newItem)
            }

        }.navigationBarBackButtonHidden(true)
        
    }
}

private extension AddTransaction {
    //header section
    var headerSection: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(themeManager.textColor)
                    .font(.system(size: 25))
            }
            .padding()
            
            Text("Add transaction")
                .bold()
                .font(.largeTitle)
                .foregroundColor(themeManager.textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top,10)
    }
    //price section
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
    // form section
    var formSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.15))
                .edgesIgnoringSafeArea(.bottom)
                .padding(.bottom,-35)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 20)]) {
                    VStack(spacing: 25){
                        //title
                        CustomTextField(placeholder: "Title", text: $title,isSecure: .constant(false))
                            .environmentObject(themeManager)
                        //categories
                        DropDownMenu(
                            title: "Category",
                            options: ["Food", "Transport", "Shopping", "Bills"],
                            selectedOption: $selectedCategory
                        )
                        .environmentObject(themeManager)
                        //date picker
                        DatePickerField(date: $date, showDatePicker: $showDatePicker)
                            .environmentObject(themeManager)
                        //Description
                        CustomTextField(placeholder: "Description", text: $description,isSecure: .constant(false))
                            .environmentObject(themeManager)
                        //image picker
                        ImagePickerField(imageData: $imageData, image: "")
                            .environmentObject(themeManager)
                        //type selector
                        transactionTypeSelector
                        //the add button
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
    //the type selector section
    var transactionTypeSelector: some View {
        VStack(alignment: .leading) {
            Text("Transaction type:")
                .font(.title2)
                .foregroundColor(themeManager.textColor.opacity(0.5))
                .padding(.leading, -60)
            
            HStack(spacing: 12) {
                ForEach(transactionType.allCases) { type in
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
                //validate amount
                validateAmount(amount)
                if amountError == nil {
                    // Add transaction
                    transactionVM.addTransaction(
                        title: title,
                        description: description,
                        amount: amount,
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
    //load image function
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
    //validate error mesg for amount
    func validateAmount(_ text: String) {
        if isValidNumber(text) {
            amountError = nil
        } else {
            amountError = "Price must be a number only."
        }
    }
    //validate function
    func isValidNumber(_ text: String) -> Bool {
        let numberPattern = "^[0-9]+$"
        return text.range(of: numberPattern, options: .regularExpression) != nil
    }
    
}
