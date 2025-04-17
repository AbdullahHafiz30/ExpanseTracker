//
//  File.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI
/// A reusable custom back-navigation view component.
/// `CustomBackward` displays a back arrow icon (`arrow.left`) and a title label.
/// Tapping on the arrow icon triggers a custom event closure, making it useful for navigation bars or custom headers.
///
/// - Parameters:
///   - title: The title text displayed next to the arrow.
///   - tapEvent: A closure executed when the arrow icon is tapped.
@ViewBuilder
func CustomBackward(title: String, tapEvent: @escaping () -> Void) -> some View {
    HStack{
        // Back icon with tap event to dimiss the view
        Image(systemName: "arrow.left")
            .font(.system(size: 22))
            .contentShape(Rectangle())
            .onTapGesture {
                tapEvent()
            }
        // Page title 
        Text(title)
            .font(.system(size: 22))
            .bold()
    }
}
