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
    @StateObject var budgetViewModel = BudgetViewModel()
    @Binding var userId: String
    @Binding var budgetAmount: Double
    @State private var showRepeatAlert = false
    @State private var budgetError: String?
    var body: some View {
        NavigationStack {
            VStack{
                Text("Set Budget")
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
                        validateAmount(newValue)
                    }
                
                if let error = budgetError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }
                
                CustomButton(title: "Save", action: {
                    validateAmount(budget)
              
                    if budgetError != nil {
                        return
                    }
                    
                    if let amount = Double(budget) {
                        if budgetAmount == 0 {
                            let newBudget = Budget(
                                id: UUID().uuidString,
                                amount: amount,
                                startDate: convertDateToString(date: Date()),
                                endDate: convertDateToString(date:Date().addingTimeInterval(30 * 24 * 60 * 60)))
                            
                            budgetViewModel.saveBudgetToCoreData(budget: newBudget, userId: userId, repeated: true)
                            isPresented = false
                        } else {
                            showRepeatAlert = true
                        }
                    } else {
                        budgetError = "Invalid number format."
                    }
                    //budgetViewModel.deleteAll(userId: userId)
                })
                .padding(.bottom, 20)
            }
            .padding()
        }
        .alert("Do you want to set this budget as repeated?", isPresented: $showRepeatAlert) {
            Button("yes") {
                let newBudget = Budget(
                    id: UUID().uuidString,
                    amount: Double(budget),
                    startDate: convertDateToString(date: Date()),
                    endDate: convertDateToString(date:Date().addingTimeInterval(30 * 24 * 60 * 60)))
                
                budgetViewModel.saveBudgetToCoreData(budget: newBudget, userId: userId, repeated: true)
                
                isPresented = false
            }
            
            Button("no") {
                let newBudget = Budget(
                    id: UUID().uuidString,
                    amount: Double(budget),
                    startDate: convertDateToString(date: Date()),
                    endDate: convertDateToString(date:Date().addingTimeInterval(30 * 24 * 60 * 60)))
                
                budgetViewModel.saveBudgetToCoreData(budget: newBudget, userId: userId, repeated: false)
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
    }
        func convertDateToString(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            return formatter.string(from: date)

    }
    
    //validate error mesg for amount
    func validateAmount(_ text: String) {
        if isValidNumber(text) {
            budgetError = nil
        } else {
            budgetError = "Budget must be a number only."
        }
    }
    //validate function
    func isValidNumber(_ text: String) -> Bool {
        let numberPattern = "^[0-9]+$"
        return text.range(of: numberPattern, options: .regularExpression) != nil
    }
}

#Preview {
    SetBudget(isPresented: .constant(true), userId: .constant("E5076426-D308-4CD1-9385-1DA8C928068F"), budgetAmount: .constant(0.0))
}
