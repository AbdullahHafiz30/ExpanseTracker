//
//  TransactionListView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI
import CoreData

/// The main home screen view that displays transaction data, filters, and navigation.
struct TransactionListView: View {
    
    // MARK: - Variable
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TransactionViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var userId: String
    
    // Dynamically filtered fetch request
    @FetchRequest private var transacions: FetchedResults<TransacionsEntity>
    
    // MARK: - Initializer with userId binding
    init(userId: String) {
        self.userId = userId
    
        let request: NSFetchRequest<TransacionsEntity> = TransacionsEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransacionsEntity.date, ascending: false)]
        request.predicate = NSPredicate(format: "user.id == %@", userId)
        
        _transacions = FetchRequest(fetchRequest: request)
    }
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        // Date Range Header
                        Text("\(viewModel.startDate.formatted(as: "dd - MMM yy")) **To** \(viewModel.endDate.formatted(as: "dd - MMM yy"))")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        // Summary Card
                        CardView(
                            income: viewModel.total(.income, transactions: transacions),
                            expense: viewModel.total(.expense, transactions: transacions)
                        )
                        
                        // Transaction Type Picker
                        Picker("Type", selection: $viewModel.selectedType) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 10)
                        
                        // Filtered Transactions List
                        ForEach(viewModel.filteredTransactions(transacions, filter: viewModel.selectedFilter), id: \.self) { transaction in
                            transactionRow(transaction)
                        }
                        
                    } header: {
                        // Sticky Header
                        HeaderView(
                            searchText: $viewModel.searchText,
                            selectedTab: $viewModel.selectedFilter
                        )
                    }
                }
                .padding(5)
            }
            .onChange(of: viewModel.selectedTab) {
                viewModel.startDate = viewModel.selectedTab.startDate(from: Date())
                viewModel.endDate = Date()
            }
        }
    }
    
    // MARK: - Transaction Row Builder
    @ViewBuilder
    private func transactionRow(_ transaction: TransacionsEntity) -> some View {
        NavigationLink {
            DetailsHomeView(transaction: transaction)
        } label: {
            SwipeAction(action: {
                viewModel.deleteTransaction(transaction, viewContext: viewContext)
            }) {
                TransactionCardView(transaction: transaction)
            }
        }
    }
}
