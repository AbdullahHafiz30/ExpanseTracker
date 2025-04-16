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
    @State private var isPasswordSecure: Bool = true
    @StateObject private var alertManager = AlertManager.shared
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
                        .offset(x: 60, y: 70)
                    
                    Image(systemName: "camera.fill")
                        .resizable()
                        .foregroundColor(themeManager.isDarkMode ? .black : .white)
                        .frame(width: 25,height: 20)
                        .offset(x: 60, y: 70)
                        .onTapGesture {
                            showPhotoLibrary = true
                        }
                    
                }
                .padding(.top,10)
                .padding()
                
                Group{
                    Text("Name")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
                    CustomTextField(placeholder: "", text: $userName, isSecure: .constant(false))
                    
                    Text("Email")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    CustomTextField(placeholder: "", text: $userEmail, isSecure: .constant(false))
                        .disabled(true)
                    
                    
                    Text("Password")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
                    ZStack(alignment: .trailing) {
                        CustomTextField(
                            placeholder: "123456789",
                            text: $userPassword,
                            isSecure: $isPasswordSecure
                        )
                        .disabled(true)
                        
                        Button(action: {
                            isPasswordSecure.toggle()
                        }) {
                            Image(systemName: isPasswordSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 16)
                        }
                    }
                    
                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth:.infinity ,alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
                // MARK: - Save edited account information button
                CustomButton(title: "Save", action: {
                    guard !userName.trimmingCharacters(in: .whitespaces).isEmpty else {
                        let message = "Name is required"
                        AlertManager.shared.showAlert(title: "Error", message: message)
                        return
                    }
                    
                    guard isValidEmail(userEmail) else {
                        let message = "Invalid email address"
                        AlertManager.shared.showAlert(title: "Error", message: message)
                        return
                    }
                    
                    guard userPassword.count >= 6 else {
                        let message = "Password must be at least 6 characters"
                        AlertManager.shared.showAlert(title: "Error", message: message)
                        return
                    }
                    
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
                })
                .padding(.bottom, 20)
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CustomBackward(title:"Edit Account Information"){
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
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        self.imageData = data
                        
                        if let uiImage = UIImage(data: data),
                           let filename = CoreDataHelper().saveImageToDocuments(uiImage) {
                            
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let savedURL = documentsDirectory.appendingPathComponent(filename)
                            
                            self.imageURL = savedURL
                            print("✅ Image saved to documents at: \(savedURL)")
                        }
                    }
                }
            }
            .onAppear {
                loadUserData()
            } .alert(isPresented: $alertManager.alertState.isPresented) {
                Alert(
                    title: Text(alertManager.alertState.title),
                    message: Text(alertManager.alertState.message),
                    dismissButton: .default(Text("OK")))
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Functions
    private func loadUserData() {
        let userInfo = CoreDataHelper().fetchUserFromCoreData(uid: userId)
        
        userName = userInfo?.name ?? ""
        userEmail = userInfo?.email ?? ""
        userPassword = userInfo?.password ?? ""
        
        if let imageFilename = userInfo?.image {
            print("Saved image filename: \(imageFilename)")
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(imageFilename)
            
            print("Full file path: \(fileURL.path)")
            
            if FileManager.default.fileExists(atPath: fileURL.path),
               let data = try? Data(contentsOf: fileURL) {
                self.imageData = data
                self.imageURL = fileURL
                print("Image data loaded from documents")
            } else {
                print("File not found in documents")
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
