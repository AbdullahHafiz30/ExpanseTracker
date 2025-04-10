//
//  File.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//


//
//  CustomBackward.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI

@ViewBuilder
func CustomBackward(title: String, tapEvent: @escaping () -> Void) -> some View {
    HStack{
        Image(systemName: "arrow.left")
            .font(.system(size: 22))
            .onTapGesture {
                tapEvent()
            }
        
        Text(title)
            .font(.system(size: 22))
            .bold()
    }
}
