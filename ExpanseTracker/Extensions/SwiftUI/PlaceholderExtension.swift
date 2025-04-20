//
//  PlaceholderExtension.swift
//  ExpanseTracker
//
//  Created by Rawan on 18/10/1446 AH.
//

import SwiftUI
/// Extension on View to allow custom placeholder overlays on any SwiftUI view.
/// Useful for customizing placeholder colors in TextFields and SecureFields.
extension View {
    
    /// Displays a placeholder view over the current view when the given condition is true.
      ///
      /// - Parameters:
      ///   - shouldShow: Whether the placeholder should be shown.
      ///   - alignment: The alignment for the placeholder. Default is `.leading`.
      ///   - placeholder: A closure returning the view to display as a placeholder.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}
