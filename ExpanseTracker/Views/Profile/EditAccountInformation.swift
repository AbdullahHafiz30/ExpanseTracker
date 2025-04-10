//
//  EditAccountInformation.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//


//
//  EditAccountInformation.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct EditAccountInformation: View {
    @State var showPassword: Bool = false
    @State var showEditPage: Bool = false
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
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
                                //change pic
                            }
                    
                }
                .padding(.top,25)
                .padding()
                
                Group{
                    Text("Name")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    CustomTextField(placeholder: "Example Name", text: $userName)
                    
                    Text("Email")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    CustomTextField(placeholder: "Example@gmail.com", text: $userEmail)
                    
                    Text("Password")
                        .font(.system(size: 22, weight: .medium, design: .default))
                    
                    CustomTextField(placeholder: "123456789", text: $userPassword, isSecure: true)

                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .frame(maxWidth:.infinity ,alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom,5)
                
                
                Spacer()
                
                CustomButton(title: "Save")
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EditAccountInformation()
}
