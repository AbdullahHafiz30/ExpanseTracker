//
//  TransactionListView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI

/// The main home screen view that displays transaction data, filters, and navigation.
struct TransactionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TransactionViewModel()
    
    @FetchRequest(
        entity: TransacionsEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TransacionsEntity.date, ascending: false)]
    ) private var transacions: FetchedResults<TransacionsEntity>
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
               
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        
                        Text("\(viewModel.startDate.formatted(as: "dd - MMM yy")) **To** \(viewModel.endDate.formatted(as: "dd - MMM yy"))")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            
                            
                            // Income/Expense summary card
                            CardView(
                                income: viewModel.total(.income, transactions: transacions),
                                expense: viewModel.total(.expense, transactions: transacions)
                            )
                            
                            //Segmented control to switch between Income/Expense
                            Picker("Type", selection: $viewModel.selectedType) {
                                ForEach(TransactionType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.bottom, 10)
                            
                            // List of filtered transactions
                            
                            ForEach(viewModel.filteredTransactions(transacions)) { transaction in
                                NavigationLink {
                                    DetailsHomeView(transaction: transaction)
                                } label: {
                                    TransactionCardView(transaction: transaction)
                                    
                                    Button(action: {
                                        viewModel.deleteTransaction(transaction, viewContext: viewContext)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                            }

                        } header: {
                            // Sticky header with greeting and search/filter bar
                            HeaderView(
                                searchText: $viewModel.searchText,
                                selectedTab: $viewModel.selectedTab
                            )
                        }
                    }
                }
                .padding(15)
            
            
        }
        .onChange(of: viewModel.selectedTab) {
            viewModel.startDate = viewModel.selectedTab.startDate(from: Date())
            viewModel.endDate = Date()
        }
    }
}
