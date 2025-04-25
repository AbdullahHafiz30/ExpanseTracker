//
//  DropDownMenu.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

/// A custom drop-down menu that allows users to select one option from a list.
/// This component uses a button to toggle the visibility of the options and updates the selected value.
struct DropDownMenu: View {
    
    //MARK: - Variables
    let title: String
    let options: [Category]
    @Binding var selectedOption: Category?
    @State private var isExpanded = false
    @EnvironmentObject var themeManager: ThemeManager
    
    //MARK: - View
    var body: some View {
        VStack(spacing: 4) {
            // The drop down menu it will expand
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text((selectedOption == nil ? title : selectedOption?.name) ?? "")
                        .foregroundColor(
                            selectedOption == nil
                            ? themeManager.isDarkMode ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
                            : themeManager.textColor
                        )
                    
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(themeManager.textColor)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 7).stroke(themeManager.textColor, lineWidth: 1))
            }
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option.name ?? "")
                                    .foregroundColor(themeManager.textColor)
                                Spacer()
                            }
                            .padding()
                        }
                        
                        if option != options.last {
                            Divider()
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 7).stroke(themeManager.textColor, lineWidth: 1))
            }
        }
    }
}
