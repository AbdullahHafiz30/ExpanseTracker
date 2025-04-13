//
//  CustomSegmentedControl.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI

/// A custom segmented control to switch between different `TransactionType` cases.
/// - Parameters:
///   - selectedType: A binding to the currently selected transaction type.
///   - animation: A matched geometry namespace to smoothly animate the selection capsule.
@ViewBuilder
func CustomSegmentedControl(selectedType: Binding<TransactionType>, animation: Namespace.ID) -> some View {
    HStack(spacing: 0) {
        // Iterate over all transaction types and render a segment for each
        ForEach(TransactionType.allCases, id: \.rawValue) { type in
            SegmentItem(type: type, selectedType: selectedType, animation: animation)
        }
    }
    // Add capsule-shaped background with slight gray opacity
    .background(.gray.opacity(0.15), in: Capsule())
    .padding(.top, 5)
}

/// A single segment item used in the custom segmented control.
struct SegmentItem: View {
    let type: TransactionType                     // Current type this segment represents
    @Binding var selectedType: TransactionType   // Bound to the selected type in parent
    var animation: Namespace.ID                  // Matched geometry animation namespace

    var body: some View {
        Text(type.rawValue)
            .hSpacing() // Expands to take horizontal space equally
            .padding(.vertical, 10)
            .background {
                // If this segment is selected, show the animated capsule
                if type == selectedType {
                    Capsule()
                        .fill(.background)
                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                }
            }
            .contentShape(Capsule()) // Increases tap area to full capsule shape
            .onTapGesture {
                // Animate the change when the user taps a new segment
                withAnimation(.snappy) {
                    selectedType = type
                }
            }
    }
}
