////
////  GraphHeaderView.swift
////  ExpanseTracker
////
////  Created by Abdullah Hafiz on 14/04/2025.
////
//
//
//import SwiftUI
//
//struct GraphHeaderView: View {
//    @Binding var selectedTab: DateTab
//    @Binding var selectedMonth: Int
//    @Binding var selectedYear: Int
//    @Binding var selectedCategoryType: CategoryType?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // 📅 Date, Mode, Month-Year 🎯 Filter by Type
//            DateModePicker(
//                selectedTab: $selectedTab,
//                selectedMonth: $selectedMonth,
//                selectedYear: $selectedYear
//                selectedType: $selectedCategoryType
//            )
//
//            
//            CategoryTypeMenuPicker(
//                
//            )
//            .padding(.horizontal)
//        }
//    }
//}
