//
//  DropDownMenu.swift
//  ExpanseTracker
//
//  Created by Rawan on 12/10/1446 AH.
//


import SwiftUI

struct DropDownMenu: View {
    let title: String
    let options: [String]
    @Binding var selectedOption: String
    @State private var isExpanded = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: 4) {
            //the drop down menu it will expand
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedOption.isEmpty ? title : selectedOption)
                        .foregroundColor(selectedOption.isEmpty ? .black.opacity(0.6) : .black)
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
                                Text(option)
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
                .background(RoundedRectangle(cornerRadius: 7).stroke(themeManager.backgroundColor, lineWidth: 1))
            }
        }
    }
}
