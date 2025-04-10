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
    
    @State private var selectedType: TransactionType = .expense // Currently selected transaction type (income/expense)
    
    @Namespace private var animation // Namespace for matchedGeometryEffect animations
    
    @StateObject private var viewModel = HomeViewModel() // ViewModel containing transaction data
    
    @State private var searchText: String = ""
    @State private var selectedTab: Tab = .monthly
    
    @State var index = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        
                        Section {
                            
                            Text("\(format(date: startDate, format: "dd - MMM yy")) **to** \(format(date: endDate, format: "dd - MMM yy"))")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            
                            // Income/Expense summary card
                            CardView(
                                income: viewModel.total(for: .income, from: startDate, to: endDate),
                                expense: viewModel.total(for: .expense, from: startDate, to: endDate)
                            )
                            
                            // Custom segmented control to switch between Income/Expense
                            CustomSegmentedControl(selectedType: $selectedType, animation: animation)
                                .padding(.bottom, 10)
                            
                            // List of filtered transactions
                            ForEach(viewModel.sampleTransactions.filter {
                                (searchText.isEmpty ||
                                 $0.title.localizedCaseInsensitiveContains(searchText) ||
                                 $0.description.localizedCaseInsensitiveContains(searchText)) &&
                                $0.type == selectedType.rawValue &&
                                $0.date >= startDate &&
                                $0.date <= endDate
                            }) { transaction in
                                NavigationLink {
                                    DetailsHomeView()
                                } label: {
                                    TransactionCardView(transaction: transaction)
                                }
                                .buttonStyle(.plain)
                            }

                        } header: {
                            // Sticky header with greeting and search/filter bar
                            HeaderView(
                                size,
                                searchText: $searchText,
                                selectedTab: $selectedTab
                            )
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                
                CustomTabBar(index: $index)
            }
            .onChange(of: selectedTab) {
                startDate = selectedTab.startDate(from: Date())
                endDate = Date()
            }
        }
    }
}
