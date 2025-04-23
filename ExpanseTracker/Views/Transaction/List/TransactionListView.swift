//
//  TransactionListView.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 11/10/1446 AH.
//

import SwiftUI
import CoreData

/// The main home screen view that displays the user's transaction history, filter controls, summary, and navigation.
struct TransactionListView: View {
    
    // MARK: - Environment and State
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TransactionViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    var userId: String
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"

    
    // MARK: - Core Data FetchRequest
    @FetchRequest private var transacions: FetchedResults<TransacionsEntity>
    
    // MARK: - Initializer with userId binding
    init(userId: String) {
        self.userId = userId
    
        let request: NSFetchRequest<TransacionsEntity> = TransacionsEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransacionsEntity.date, ascending: false)]
        request.predicate = NSPredicate(format: "user.id == %@", userId)
        
        _transacions = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        // Display selected date range
                        Text("\(viewModel.startDate.formatted(as: "dd - MMM yy")) **To** \(viewModel.endDate.formatted(as: "dd - MMM yy"))")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        // Summary card showing total income and expenses
                        CardView(
                            income: viewModel.total(.income, transactions: transacions, filter: viewModel.selectedTab),
                            expense: viewModel.total(.expense, transactions: transacions, filter: viewModel.selectedTab),
                            currentLanguage: currentLanguage
                        )
                        
                        // Segmented control to filter by transaction type
                        Picker("Type", selection: $viewModel.selectedType) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                Text(type.rawValue.localized(using: currentLanguage)).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 10)
                        
                        // List of filtered transactions
                        ForEach(viewModel.filteredTransactions(transacions, filter: viewModel.selectedTab), id: \.self) { transaction in
                            transactionRow(transaction)
                        }
                        
                    } header: {
                        // Sticky header containing the search bar and filter options
                        HeaderView(
                            searchText: $viewModel.searchText,
                            selectedTab: $viewModel.selectedTab,
                            currentLanguage: currentLanguage
                        )
                    }
                }
                .padding(5)
            }
            .onChange(of: viewModel.selectedTab) {
                // Update the date range when the selected tab changes
                viewModel.startDate = viewModel.selectedTab.startDate(from: Date())
                viewModel.endDate = Date()
            }
        }
    }
    
    // MARK: - Transaction Row Builder
    /// A view builder function that returns a navigation-enabled swipeable row for each transaction.
    @ViewBuilder
    private func transactionRow(_ transaction: TransacionsEntity) -> some View {
        NavigationLink {
            DetailsHomeView(currentLanguage: currentLanguage, transaction: transaction)
        } label: {
            SwipeAction(cornerRadius: 10, direction: .trailing, language: currentLanguage) {
                TransactionCardView(transaction: transaction, currentLanguage: currentLanguage, userId: userId)
            } actions: {
                // Swipe-to-delete action
                Action(tint: .red, icon: "trash") {
                    viewModel.deleteTransaction(transaction, viewContext: viewContext)
                }
            }
        }
    }
}
