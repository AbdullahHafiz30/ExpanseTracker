//
//  AccountInformatio.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct AccountInformation: View {
    // MARK: - Variables
    @State var showPassword: Bool = false
    @State var showEditPage: Bool = false
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var userId: String
    @State private var imageURL: URL? = nil
    @State private var imageData: Data? = nil
    @State private var isPasswordSecure: Bool = true
    // MARK: - UI Design
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
                }
                .padding(.top,25)
                .padding()
                Spacer()
                
                Group{
                    Text("Name")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    Text(name)
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    
                    Text("Email")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    Text(verbatim: email)
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    
                    Text("Password")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
                    HStack{
                        Text(isPasswordSecure ? "**********" : password)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: {
                            isPasswordSecure.toggle()
                        }) {
                            Image(systemName: isPasswordSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 16)
                        }
                    }
                    Divider()
                        .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth:.infinity ,alignment: .leading)
                .padding(.horizontal)
                
                
                Spacer()
                
                NavigationLink(destination: EditAccountInformation(userId: $userId)){
                    Text("Edit")
                        .frame(width: 170, height: 50)
                        .background(
                            Rectangle()
                                .fill(themeManager.isDarkMode ? .white : .black)
                                .cornerRadius(8)
                        )
                        .foregroundColor(themeManager.isDarkMode ? .black : .white)
                        .font(.headline)
                        .padding(.bottom, 20)
                }
                Spacer()
                
            }.onAppear{
                // MARK: - Get user information from core
                // Fetch the user from Core Date using user id
                let userInfo =  CoreDataHelper().fetchUserFromCoreData(uid: userId)
                // Assign its properties to local state variables
                name = userInfo?.name ?? ""
                email = userInfo?.email ?? ""
                password = userInfo?.password ?? ""
                
                if let imageFilename = userInfo?.image {
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
                        print("Image data loaded from documents")
                    } else {
                        print("❌ File not found in documents")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CustomBackward(title:"Account Information"){
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}
