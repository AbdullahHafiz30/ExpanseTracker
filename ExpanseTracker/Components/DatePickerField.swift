//
//  DatePickerField.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

struct DatePickerField: View {
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        VStack(alignment: .leading) {
            //the field to pick the date
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
            //display the dates
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
    //function to format the date
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
