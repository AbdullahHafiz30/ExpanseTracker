//
//  CardView.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import SwiftUI

/// Custom card that shows the `net balance` and `income/expense trend `
struct CardView: View {
    
    // MARK: - Variable
    var income: Double
    var expense: Double
    var currentLanguage: String
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        
        ZStack {
            
            // Background card with rounded corners
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.15))
            
            VStack(spacing: 0) {
                
                //MARK: - Top section: balance and trend icon
                HStack(spacing: 12) {
                    
                    Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    // Net balance = income - expense
                    Text("\(NumberFormatterManager.shared.decimalString(from: income - expense))")
                        .font(.title.bold())
                    
                    // Show a trend icon based on whether net is positive or negative
                    Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 25)
                
                // MARK: - Bottom section: income and expense breakdown
                HStack(spacing: 0) {
                    ForEach(TransactionType.allCases, id: \.rawValue) { type in
                        // Define the system image and tint color for each type
                        let symbolImage = type == .income ? "arrow.down" : "arrow.up"
                        let tint = type == .income ? Color.green : Color.red
                        
                        HStack(spacing: 10) {
                            // Circle icon for income/expense
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width: 35, height: 35)
                                .background {
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            
                            // Labels: "Income" or "Expense" and the corresponding amount
                            VStack(alignment: .leading, spacing: 4) {
                                Text(type.rawValue.localized(using: currentLanguage))
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text(NumberFormatterManager.shared.decimalString(from: type == .income ? income : expense))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                            }
                            
                            // Push content for income to the left if needed
                            if type == .expense {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
        }
    }
}
