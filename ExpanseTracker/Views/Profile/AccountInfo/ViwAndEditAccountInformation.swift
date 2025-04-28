////
////  AccountInformatio.swift
////  ExpensesMonthlyProjrct
////
////  Created by Rayaheen Mseri on 12/10/1446 AH.
////
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ViwAndEditAccountInformation: View {
    // MARK: - Variables
    @State var showPassword: Bool = false
    @State var showEditPage: Bool = false
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var imageData: Data? = nil
    @State private var showPhotoLibrary = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var imageURL: URL? = nil
    var userId: String
    @State var oldUserName: String = ""
    @State var oldImageURL: URL? = nil
    @State private var isPasswordSecure: Bool = true
    @StateObject private var alertManager = AlertManager.shared
    @StateObject var editViewModel = ViwAndEditAccountInformationViewModel()
    var currentLanguage : String
    @Binding var user: User?
    @State var isEdit: Bool
    var coreViewModel = CoreDataHelper()
    @State var saveError = false
    // MARK: - UI Design
    var body: some View {
        NavigationStack{
            VStack (spacing:10){
                ZStack{
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 170, height: 170)
                    
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .foregroundColor(themeManager.isDarkMode ? .white :.black.opacity(0.7))
                    }
                    
                    if isEdit {
                        Circle()
                            .fill(themeManager.isDarkMode ? .white : .black)
                            .frame(width: 50, height: 50)
                            .offset(x: 55, y: 70)
                        
                        Image(systemName: "camera.fill")
                            .resizable()
                            .foregroundColor(themeManager.isDarkMode ? .black : .white)
                            .frame(width: 25,height: 20)
                            .offset(x: 55, y: 70)
                            .onTapGesture {
                                showPhotoLibrary = true
                            }
                    }
                }
                .padding(.vertical,20)
                .padding()
                
                Group{
                    Text("Name".localized(using: currentLanguage))
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
                    CustomTextField(placeholder: "", text: $userName, isSecure: .constant(false))
                        .disabled(isEdit ? false : true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(isEdit ? themeManager.textColor : .gray, lineWidth: 1)
                        )
                    
                    
                    Text("Email".localized(using: currentLanguage))
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
                    
                    CustomTextField(placeholder: "", text: $userEmail, isSecure: .constant(false))
                        .disabled(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(isEdit ? themeManager.textColor : .gray , lineWidth: 1)
                        )
                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth:.infinity ,alignment: .leading)
                .padding(.horizontal)
                
                
                Spacer()
                
                CustomButton(title: isEdit ? "Save" : "Edit", action: {
                    if isEdit {
                        guard !userName.trimmingCharacters(in: .whitespaces).isEmpty else {
                            let message = "NameRequired".localized(using: currentLanguage)
                            AlertManager.shared.showAlert(title: "Error".localized(using: currentLanguage), message: message)
                            return
                        }
                        
                        // Create user object
                        let user = User(
                            id: userId,
                            name: userName,
                            email: userEmail,
                            password: userPassword,
                            image: imageURL?.lastPathComponent ?? "",
                            transactions: [],
                            budgets: [],
                            categories: []
                        )
                        
                        coreViewModel.saveEditedUser(user: user)
                        dismiss()
                    } else {
                        isEdit.toggle()
                    }
                })
                .disabled(isEdit && !isUserModified)
                .onTapGesture {
                    if isEdit && !isUserModified {
                        saveError.toggle()
                    }
                }
                
                if saveError {
                    Text("There are no changes to save.")
                        .foregroundColor(.red)
                        .font(.callout)
                    
                }
                
                Spacer()
                
            }.photosPicker(
                isPresented: $showPhotoLibrary,
                selection: $selectedPhoto,
                matching: .images
            )
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    // Load the data representation of that selected item.
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        self.imageData = data
                        
                        // Converts the raw data into a UIImage
                        if let uiImage = UIImage(data: data),
                           let filename = CoreDataHelper().saveImageToDocuments(uiImage) {
                            
                            // Retrieves the URL for the app document directory using FileManager
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            
                            // Append the file name to the documentsDirectory
                            let savedURL = documentsDirectory.appendingPathComponent(filename)
                            
                            self.imageURL = savedURL
                            print("✅ Image saved to documents at: \(savedURL)")
                        }
                    }
                }
            }.onAppear{
                if let imageFilename = user?.image {
                    print("Saved image filename: \(imageFilename)")
                    // Retrieves the URL for the app document directory using FileManager
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    // Append the file name to the documentsDirectory
                    let fileURL = documentsDirectory.appendingPathComponent(imageFilename)
                    
                    print("Full file path: \(fileURL.path)")
                    
                    // Check if the file exists
                    if FileManager.default.fileExists(atPath: fileURL.path),
                       let data = try? Data(contentsOf: fileURL) {
                        self.imageData = data
                        self.imageURL = fileURL
                        self.oldImageURL = fileURL
                        print("Image data loaded from documents")
                    } else {
                        print("❌ File not found in documents")
                    }
                }
                
                userName = user?.name ?? ""
                oldUserName = user?.name ?? ""
                userEmail = user?.email ?? ""
                
            }
            .toolbar {
                ToolbarItem(placement: currentLanguage == "ar" ? .topBarTrailing : .topBarLeading) {
                    CustomBackward(title:"AccountInformation".localized(using: currentLanguage)){
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
        
    }
    
    var isUserModified: Bool {
        return userName != oldUserName || imageURL != oldImageURL
    }
}
