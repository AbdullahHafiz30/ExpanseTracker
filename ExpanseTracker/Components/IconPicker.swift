//
//  IconPicker.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 12/10/1446 AH.
//

import SwiftUI
/// A view that presents a searchable  system icons for selection.
/// Selected icon is highlighted with the user-selected color and automatically dismissed after selection.
struct IconPicker: View {
    @StateObject var viewModel = IconModel()
    @Binding var selectedIcon: String
    @Binding var color: Color
    @Environment(\.dismiss) var dismiss
    @Namespace var animation
    @State private var searchText: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 10) {
                    ForEach(viewModel.iconFilter(text: searchText), id: \.self) { icon in
                        ZStack {
                            if selectedIcon == icon {
                                Capsule()
                                    .fill(color)
                                    .matchedGeometryEffect(id: "icon", in: animation)
                                    .frame(width: 40, height: 40)
                            }
                            
                            Image(systemName: icon)
                                .foregroundColor(selectedIcon == icon ? .white : .black)
                                .frame(width: 40, height: 40)
                                .background{
                                    Capsule()
                                        .fill(.gray.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                }
                            
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedIcon = icon
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    dismiss()
                                }
                            }
                        }
                    }
                    
                }
                .searchable(text: $searchText)
                .navigationTitle("Icons")
            }
        }
    }
}

#Preview {
    IconPicker(selectedIcon: .constant("star"), color: .constant(.blue))
}
