//
//  DatePickerField.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

/// A custom view that mimics a styled text field and toggles a graphical calendar picker.
/// Useful for forms where users need to select a date, with theme support and animation.

struct DatePickerField: View {
    //MARK: - Variables
    
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    //MARK: - View
    
    var body: some View {
        VStack(alignment: .leading) {
            // The field to pick the date
            RoundedRectangle(cornerRadius: 7)
                .stroke(themeManager.textColor, lineWidth: 1)
                .frame(height: 48)
                .overlay(
                    HStack {
                        Text(dateFormatted(date))
                            .foregroundColor(themeManager.textColor)
                            .padding(.leading)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(themeManager.textColor)
                            .padding(.trailing)
                    }
                )
                .onTapGesture {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }
            // Display the dates
            if showDatePicker {
                DatePicker(
                    "Pick a date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .transition(.opacity)
                .onChange(of: date) {
                    withAnimation {
                        showDatePicker = false
                    }
                }
            }
        }
    }
    
    /// Formats the selected date to a readable string format.
    /// - Parameter date: The date to format.
    /// - Returns: A string representing the date in "MMM d, yyyy" style.
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
