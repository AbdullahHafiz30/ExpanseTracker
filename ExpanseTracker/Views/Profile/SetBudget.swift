//
//  SetBudget.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct SetBudget: View {
    @State var budget: String = ""
    @Binding var isPresented: Bool
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        NavigationStack {
            VStack{
                Text("Set Budget")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                
                TextField("5000 Riyals", text: $budget)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60, alignment: .leading)
                    .background{
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                    }
                    .padding(.bottom, 20)
                
                CustomButton(title: "Save", action: {
                    isPresented = false
                })
                    .padding(.bottom, 20)
            }
            .padding()
        }
        .frame(height: 250)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(themeManager.isDarkMode ? .black: .white)
                .shadow(color: themeManager.isDarkMode ? .white.opacity(0.3) : .gray , radius: 5)
        )
        .padding()
    }
}

#Preview {
    SetBudget(isPresented: .constant(true))
}
