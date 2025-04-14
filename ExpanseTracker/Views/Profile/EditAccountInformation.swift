//
//  EditAccountInformation.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI
import PhotosUI

struct EditAccountInformation: View {
    @State var showPassword: Bool = false
    @State var showEditPage: Bool = false
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
<<<<<<< Updated upstream
=======
    
    @State private var imageData: Data? = nil
    @State private var showPhotoLibrary = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var imageURL: URL? = nil
    
    @StateObject var userViewModel = UserViewModel()
    @Binding var userId: String
    @State private var isPasswordSecure: Bool = true
    
>>>>>>> Stashed changes
    var body: some View {
        NavigationStack{
            VStack (spacing:10){
                ZStack{
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 180, height: 180)
                    
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 100, height: 100)
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
<<<<<<< Updated upstream
                    CustomTextField(placeholder: "Example Name", text: $userName)
                    
                    Text("Email")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    CustomTextField(placeholder: "Example@gmail.com", text: $userEmail)
=======
                    CustomTextField(placeholder: "", text: $userName, isSecure: .constant(false))
                    
                    Text("Email")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    CustomTextField(placeholder: "", text: $userEmail, isSecure: .constant(false))
>>>>>>> Stashed changes
                    
                    Text("Password")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
<<<<<<< Updated upstream
                    CustomTextField(placeholder: "123456789", text: $userPassword, isSecure: true)
=======
                    ZStack(alignment: .trailing) {
                        CustomTextField(placeholder: "", text: $userPassword, isSecure: $isPasswordSecure)
                        
                        Button(action: {
                            isPasswordSecure.toggle()
                        }) {
                            Image(systemName: isPasswordSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 16)
                        }
                    }
>>>>>>> Stashed changes

                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth:.infinity ,alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom,5)
                
                
                Spacer()
                
                CustomButton(title: "Save", action: {
                    
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

                    userViewModel.saveEditedUser(user: user)
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
                           let filename = userViewModel.saveImageToDocuments(uiImage) {
                            
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let savedURL = documentsDirectory.appendingPathComponent(filename)

                            self.imageURL = savedURL
                            print("✅ Image saved to documents at: \(savedURL)")
                        }
                    }
                }
            }
            .onAppear {
                let userInfo = userViewModel.fetchUserFromCoreDataWithId(id: userId)

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
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EditAccountInformation(userId: .constant(""))
}
