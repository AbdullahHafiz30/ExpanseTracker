//
//  SetBudget.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

struct SetBudget: View {
    // MARK: - Variables
    @State var budget: String = ""
    @Binding var isPresented: Bool
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var budgetViewModel = BudgetViewModel()
    var userId: String
    var budgetAmount: Double
    @State private var showRepeatAlert = false
    @State private var budgetError: String?
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    // MARK: - UI Design
    var body: some View {
        NavigationStack {
            VStack{
                Text("SetBudget".localized(using: currentLanguage))
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                
                TextField("\(String(format: "%.1f", budgetAmount))", text: $budget)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60, alignment: .leading)
                    .background{
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                    }
                    .padding(.bottom, 20)
                    .onChange(of: budget) { _, newValue in
                        budgetError = budgetViewModel.validateAmount(text: newValue)
                    }
                
                if let error = budgetError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }
                // MARK: - Save budget amount button
                CustomButton(title: "Save".localized(using: currentLanguage), action: {
                    budgetError = budgetViewModel.validateAmount(text: budget)
                    
                    if budgetError != nil {
                        return
                    }
                    
                    if Double(budget) != nil {
                        if budgetAmount == 0 {
                            budgetViewModel.createBudget(repeated: true, userId: userId, budget: budget)
                            isPresented = false
                        } else {
                            showRepeatAlert = true
                        }
                    } else {
                        budgetError = "InvalidNumberFormat".localized(using: currentLanguage)
                    }
                })
                .padding(.bottom, 20)
            }
            .padding()
        }
        .alert("BudgetAsRepeated".localized(using: currentLanguage), isPresented: $showRepeatAlert) {
            Button("yes".localized(using: currentLanguage)) {
               
                budgetViewModel.createBudget(repeated: true, userId: userId, budget: budget)
                isPresented = false
            }
            
            Button("no".localized(using: currentLanguage)) {
                
                budgetViewModel.createBudget(repeated: false, userId: userId, budget: budget)
                isPresented = false
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
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
}

