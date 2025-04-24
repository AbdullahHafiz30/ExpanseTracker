//
//  ListOfSpecificCategoryView.swift
//  ExpanseTracker
//
//  Created by Naif on 17/04/2025.
//

import SwiftUI
import CoreData

struct ListOfSpecificCategoryView: View {
    // The name of the category to filter transactions
    var category: Category
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TransactionViewModel()
    @State var selectedTransaction: TransacionsEntity? = nil
    var userId : String
    // FetchRequest to get transactions related to the specific category, sorted by date (newest first)
    @FetchRequest private var transactions: FetchedResults<TransacionsEntity>
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    // Custom initializer to apply the predicate based on the selected category name
    init(category: Category, userId: String) {
        self.category = category
        _transactions = FetchRequest<TransacionsEntity>(
            entity: TransacionsEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TransacionsEntity.date, ascending: false)],
            predicate: NSPredicate(format: "category.id == %@ AND user.id == %@", category.id ?? "", userId)
        )
        self.userId = userId
    }
    
    var body: some View {
        VStack(alignment: .leading)  {
            CustomBackward(title:"\(category.name ?? "")", tapEvent: { dismiss() })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            if transactions.isEmpty {
                Spacer()
                Text("NoTransaction".localized(using: currentLanguage))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(transactions, id: \.id) { transaction in
                            NavigationLink(destination: DetailsHomeView(currentLanguage: currentLanguage, transaction: transaction)){
                                HStack {
                                    SwipeAction(cornerRadius: 10, direction: .trailing, language: currentLanguage) {
                                        TransactionCardView(transaction: transaction, currentLanguage: currentLanguage, userId: userId)
                                    } actions: {
                                        // Swipe-to-delete action
                                        Action(tint: .red, icon: "trash") {
                                            viewModel.deleteTransaction(transaction, viewContext: viewContext)
                                        }
                                    }
                                    
                                }
                                .padding(.vertical,5)
                                .foregroundColor(.primary)
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
