//
//  SwipeAction.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 20/10/1446 AH.
//

import SwiftUI

/// A reusable SwiftUI view that wraps content with a swipe-to-reveal action button.
/// Supports both leading and trailing swipe directions.
/// - Parameters:
///   - direction: The swipe direction to trigger the action (.leading or .trailing).
///   - cornerRadius: Corner radius for the swipeable content.
///   - action: Closure to execute when the button is tapped.
///   - icon: SF Symbol icon name to display inside the action button.
///   - tint: Background color of the action button.
///   - content: The content view to be wrapped with swipe gesture support.
struct SwipeAction<Content: View>: View {
    
    // MARK: - Configurable Properties
    var direction: SwipeDirection = .trailing
    var cornerRadius: CGFloat = 12
    var action: () -> Void
    var icon: String = "trash"
    var tint: Color = .red
    
    // MARK: - Gesture State
    @GestureState private var dragOffset: CGSize = .zero
    @State private var offsetX: CGFloat = 0
    
    // MARK: - Content Closure
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack(alignment: direction.alignment) {
            
            // MARK: - Swipe Action Button
            HStack {
                if direction == .trailing { Spacer() }
                
                Button {
                    withAnimation {
                        action()
                    }
                } label: {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(tint)
                        .clipShape(Circle())
                }
                .padding(.horizontal)
                
                if direction == .leading { Spacer() }
            }
            
            // MARK: - Foreground Content with Swipe Gesture
            content()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .offset(x: offsetX + dragOffset.width)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            // Track horizontal drag only in the correct direction
                            if direction == .trailing && value.translation.width < 0 {
                                state = value.translation
                            } else if direction == .leading && value.translation.width > 0 {
                                state = value.translation
                            }
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 80
                            // Trigger swipe if beyond threshold
                            if abs(value.translation.width) > threshold {
                                offsetX = direction == .trailing ? -100 : 100
                            } else {
                                offsetX = 0
                            }
                        }
                )
        }
    }
}

/// An enum representing the direction from which the swipe action should appear.
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }
}
