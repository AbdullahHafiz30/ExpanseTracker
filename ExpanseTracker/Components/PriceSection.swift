//
//  PriceSection.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 12/10/1446 AH.
//

import SwiftUI

/// A view that displays a price input section, either as an editable field or read-only value.
/// - Parameters:
///   - viewModel: The view model managing amount validation and error handling.
///   - amountText: An optional binding to a string representing the amount (editable mode).
///   - readOnlyAmount: A fixed amount used when the section is in read-only mode.
///   - themeManager: An environment object controlling theming and color logic.
///   - currentLanguage: The current language code for localization.
struct PriceSection: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: AddOrEditTransactionViewModel
    @State var readOnlyAmount: Double?
    var amountText: Binding<String>?
    var currentLanguage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: - Section Title ("How Much?")
            Text("HowMuch".localized(using: currentLanguage))
                .font(.largeTitle)
                .foregroundColor(themeManager.textColor.opacity(0.2))
                .bold()
            
            HStack {
                
                // MARK: - Currency Icon (adaptive to light/dark theme)
                Image(themeManager.isDarkMode ? "riyalW" : "riyalB")
                    .resizable()
                    .frame(width: 60, height: 60)
                
                // MARK: - Editable or Read-only Amount Field
                if let amountBinding = amountText {
                    // Editable mode: User inputs amount
                    TextField("0", text: amountBinding)
                        .foregroundColor(themeManager.textColor)
                        .font(.system(size: 50))
                        .keyboardType(.decimalPad)
                    
                } else {
                    // Read-only mode: Display formatted amount
                    Text(NumberFormatterManager.shared.decimalString(from: readOnlyAmount ?? 0.0))
                        .font(.system(size: 50))
                        .foregroundColor(themeManager.textColor)
                }
            }
        }
        .padding(.leading)
    }
}
