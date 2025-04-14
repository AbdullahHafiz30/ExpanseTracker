//
//  Add.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI
import PhotosUI

struct AddTransaction: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var price: String = ""
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var date = Date()
    @State private var showDatePicker = false
    @State private var selectedCategory = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var imageData: Data?
    //enum of the types of the transactions
    enum transactionType: String, CaseIterable, Identifiable {
        case income
        case expense
        var id: String { self.rawValue }
    }
    @State private var selectedType: transactionType = .income
    var body: some View {
        NavigationStack {
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
                
                .padding(.horizontal)
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
        .padding(.top,20)
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
                
                TextField("0", text: $price)
                    .font(.system(size: 50))
                    .foregroundColor(themeManager.textColor)
            }
            .padding(.leading)
        }
    }
    // form section
    var formSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.15))
                .frame(width: 397, height: 650)
                .edgesIgnoringSafeArea(.bottom)
            
            VStack() {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 20)]) {
                        VStack(spacing: 25){
                            //categories
                            DropDownMenu(
                                title: "Category",
                                options: ["Food", "Transport", "Shopping", "Bills"],
                                selectedOption: $selectedCategory
                            )
                            .environmentObject(themeManager)
                            //amount
                            CustomTextField(placeholder: "Amount", text: $amount)
                                .environmentObject(themeManager)
                            //date picker
                            DatePickerField(date: $date, showDatePicker: $showDatePicker)
                                .environmentObject(themeManager)
                            //Description
                            CustomTextField(placeholder: "Description", text: $description)
                                .environmentObject(themeManager)
                            //image picker
                            ImagePickerField(imageData: $imageData, image: "")
                                .environmentObject(themeManager)
                            //type selector
                            transactionTypeSelector
                            //the add button
                            addButton
                            Spacer()
                        }.padding(.bottom,30)
                    }.frame(maxWidth: .infinity)
                }
                .padding(.top, 30)
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
            action: {}
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
}
