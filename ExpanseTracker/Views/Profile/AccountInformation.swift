//
//  AccountInformatio.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct AccountInformation: View {
    @State var showPassword: Bool = false
    @State var showEditPage: Bool = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        NavigationStack{
            VStack (spacing:10){
                ZStack{
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 180, height: 180)
                    
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .foregroundColor(themeManager.isDarkMode ? .white :.black.opacity(0.7))
                }
                .padding(.top,25)
                .padding()
                Spacer()
                
                Group{
                    Text("Name")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    Text("Example Name")
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    
                    Text("Email")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    Text(verbatim: "Example@gmail.com")
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                    
                    Text("Password")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    Text("***********")
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))
                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth:.infinity ,alignment: .leading)
                .padding(.horizontal)
                
                
                Spacer()
                
                NavigationLink(destination: EditAccountInformation()){
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

#Preview {
    AccountInformation()
}
