//
//  EditAccountInformation.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI
import PhotosUI

struct EditAccountInformation: View {
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
    @Binding var userId: String
    @State var oldUserName: String = ""
    @State private var isPasswordSecure: Bool = true
    @StateObject private var alertManager = AlertManager.shared
    @StateObject var editViewModel = EditAccountInformationViewModel()
    var currentLanguage : String
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
                .padding(.vertical,20)
                .padding()
                
                Group{
                    Text("Name".localized(using: currentLanguage))
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
                    CustomTextField(placeholder: "", text: $userName, isSecure: .constant(false))
                    
                    Text("Email".localized(using: currentLanguage))
                        .font(.system(size: 22, weight: .medium, design: .default))
                    CustomTextField(placeholder: "", text: $userEmail, isSecure: .constant(false))
                        .disabled(true)
                    
                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth:.infinity ,alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
                // MARK: - Save edited account information button
                CustomButton(title: "Save".localized(using: currentLanguage), action: {
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
                    
                    CoreDataHelper().saveEditedUser(user: user)
                    dismiss()
                }).disabled(!isUserModified)
                .padding(.bottom, 20)
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: currentLanguage == "ar" ? .topBarTrailing : .topBarLeading) {
                    CustomBackward(title:"EditAccountInformation".localized(using: currentLanguage)){
                        dismiss()
                    }
                }
            }
            .photosPicker(
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
            }
            .onAppear {
                let userData = editViewModel.loadUserData(userId: userId)
                
                userName = userData.0
                oldUserName = userData.0
                userEmail = userData.1
                userPassword = userData.2
                self.imageData = userData.3
                self.imageURL = userData.4
            }
            .alert(isPresented: $alertManager.alertState.isPresented) {
                Alert(
                    title: Text(alertManager.alertState.title),
                    message: Text(alertManager.alertState.message),
                    dismissButton: .default(Text("OK".localized(using: currentLanguage))))
            }
            .navigationBarBackButtonHidden(true)
        }
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
    var isUserModified: Bool {
        return userName != oldUserName
        
    }
}
