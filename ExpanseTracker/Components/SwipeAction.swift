//
//  SwipeAction.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 20/10/1446 AH.
//

import SwiftUI

/// A custom swipeable container that reveals contextual actions when swiped horizontally.
/// Supports leading/trailing directions, corner radius styling, and localization-based refresh behavior.
/// - Parameters:
///   - cornerRadius: The corner radius of the swipe container.
///   - direction: The swipe direction (.leading or .trailing).
///   - language: A unique string used to trigger view refresh (for language changes).
///   - content: The main view content.
///   - actions: The list of swipe actions to be shown when swiped.
struct SwipeAction<Content: View>: View {
    
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    var language: String
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    
    // Unique ID to manage scroll position for each view
    let viewID = UUID()
    
    @State private var isEnabled: Bool = true
    @State private var scrollOffset: CGFloat = .zero
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    
                    // MARK: - Main content view
                    content
                        .rotationEffect(.degrees(direction == .leading ? -180 : 0))
                        .containerRelativeFrame(.horizontal)
                        .background {
                            // Show swipe background tint when active
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            // Track horizontal scroll offset using GeometryReader + PreferenceKey
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    
                    // MARK: - Action buttons shown after swipe
                    ActionButtons {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    // ScrollView offset for visual effect
                    content.offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                // Show tint background for final swipe position
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.degrees(direction == .leading ? 180 : 0))
            
            // Force rebuild on language or localization changes
            .id(language + viewID.uuidString)
            .onChange(of: language) { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut) {
                        scrollProxy.scrollTo(viewID, anchor: .leading)
                    }
                }
            }
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }

    /// Renders a horizontal row of buttons based on the filtered swipe actions.
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(filteredActions) { button in
                        Button(action: {
                            Task {
                                // Temporarily disable interaction while resetting
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                button.action()
                                try? await Task.sleep(for: .seconds(0.25))
                                isEnabled = true
                            }
                        }, label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxWidth: .infinity)
                                .contentShape(.rect)
                        })
                        .buttonStyle(.plain)
                        .background(button.tint)
                        .rotationEffect(.degrees(direction == .leading ? -180 : 0))
                    }
                }
            }
    }

    /// Calculates horizontal offset based on the current scroll position.
    nonisolated func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return (minX > 0 ? -minX : 0)
    }

    /// Filters the list of actions to only include enabled ones.
    var filteredActions: [Action] {
        return actions.filter { $0.isEnbled }
    }
}


/// A key used to observe scroll offset changes via GeometryReader.
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// Custom transition that masks view vertically based on scroll phase.
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

/// Enum representing swipe direction.
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

/// Represents a single swipe action.
struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnbled: Bool = true
    var action: () -> ()
}

/// Result builder for combining multiple Action views.
@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}
