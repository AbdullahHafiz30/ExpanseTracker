//
//  HomeView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI

/// The main home screen view that displays transaction data, filters, and navigation.
struct HomeView: View {
    
    @State private var startDate: Date = Tab.monthly.startDate(from: Date())
    @State private var endDate: Date = Date()
    
    @State private var selectedType: TransactionType = .income  // Currently selected transaction type (income/expense)
    
    @Namespace private var animation // Namespace for matchedGeometryEffect animations
    
    @StateObject private var viewModel = HomeViewModel() // ViewModel containing transaction data
    
    @State private var searchText: String = ""
    @State private var selectedTab: Tab = .monthly
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        
                        Text("\(format(date: startDate, format: "dd - MMM yy")) **to** \(format(date: endDate, format: "dd - MMM yy"))")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        // Income/Expense summary card
                        CardView(
                            income: viewModel.total(for: .income, from: startDate, to: endDate),
                            expense: viewModel.total(for: .expense, from: startDate, to: endDate)
                        )
                        
                        //Segmented control to switch between Income/Expense
                        Picker("Type", selection: $selectedType) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 10)

                        // List of filtered transactions
                        ForEach(filteredTransactions) { transaction in
                            NavigationLink {
                                DetailsHomeView(transaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }

                    } header: {
                        // Sticky header with greeting and search/filter bar
                        HeaderView(
                            searchText: $searchText,
                            selectedTab: $selectedTab
                        )
                    }
                }
                .padding(15)
            }
            
        }
//        .onChange(of: selectedTab) {
//            startDate = selectedTab.startDate(from: Date())
//            endDate = Date()
//        }
    }
    
    private var filteredTransactions: [Transaction] {
        viewModel.sampleTransactions.filter { transaction in
            let matchesSearch = searchText.isEmpty ||
            ((transaction.title?.localizedCaseInsensitiveContains(searchText)) != nil) ||
            ((transaction.description?.localizedCaseInsensitiveContains(searchText)) != nil)

            let matchesType = transaction.type == selectedType
            let matchesDate = transaction.date ?? Date() >= startDate && transaction.date ?? Date() <= endDate

            return matchesSearch && matchesType && matchesDate
        }
    }

}
