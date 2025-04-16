//
//  Extensions.swift
//  ExpenseTest1
//
//  Created by Tahani Ayman on 06/10/1446 AH.
//

import SwiftUI

extension View {
    
    /// Applies horizontal spacing by expanding the view's width to fill the available space.
    /// - Parameter alignment: The alignment for the view.
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

