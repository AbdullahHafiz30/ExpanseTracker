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
    var categoryName: String
    @Environment(\.dismiss) var dismiss
    @State var selectedTransaction: TransacionsEntity? = nil
    var userId : String
    // FetchRequest to get transactions related to the specific category, sorted by date (newest first)
    @FetchRequest private var transactions: FetchedResults<TransacionsEntity>
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    // Custom initializer to apply the predicate based on the selected category name
    init(categoryName: String,userId: String) {
        self.categoryName = categoryName
        _transactions = FetchRequest<TransacionsEntity>(
            entity: TransacionsEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TransacionsEntity.date, ascending: false)],
            predicate: NSPredicate(format: "category.name == %@", categoryName)
        )
        self.userId = userId
    }
    
    var body: some View {
        VStack(alignment: .leading)  {
            CustomBackward(title:"\(categoryName)", tapEvent: { dismiss() })
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
                            Button {
                                selectedTransaction =  transaction
                            } label: {
                                HStack {
                                    TransactionCardView(transaction: transaction, currentLanguage: currentLanguage, userId: userId)
                                        .environmentObject(ThemeManager())
                                        .padding(.vertical, 8)
                                }
                                
                            }
                            .buttonStyle(.plain)
                            
                        }
                    }
                }.padding()
                    .navigationDestination(item: $selectedTransaction) { transaction in
                        DetailsHomeView(currentLanguage: currentLanguage, transaction: transaction)
                    }
            }
        }
            .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
            .navigationBarBackButtonHidden(true)
    }
}
