//
//  EditViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 18/10/1446 AH.
//

import SwiftUI
import PhotosUI
import CoreData

/// ViewModel responsible for editing a transaction entity.
final class EditTransactionViewModel: ObservableObject {
    
    // MARK: - Published Variable
    @Published var editedTitle: String = ""
    @Published var editedDescription: String = ""
    @Published var editedAmount: Double = 0.0
    @Published var editedDate: Date = Date()
    @Published var editedCategoryName: String = ""
    @Published var editedType: TransactionType = .income
    @Published var selectedImage: PhotosPickerItem? = nil
    @Published var imageData: Data?
    @Published var categories: [CategoryEntity] = []
    let context = PersistanceController.shared.context
    
    // MARK: - Initialization from Existing Entity
    
    // Initializes the editable fields from an existing transaction.
    /// - Parameter transaction: The Core Data TransacionsEntity to edit.
    func initialize(transaction: TransacionsEntity) {
        editedTitle = transaction.title ?? ""
        editedDescription = transaction.desc ?? ""
        editedAmount = transaction.amount

        // Format and parse the saved date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        if let dateString = transaction.date, let parsedDate = formatter.date(from: dateString) {
            editedDate = parsedDate
        }
        
        editedCategoryName = transaction.category?.name ?? ""
        editedType = TransactionType(rawValue: transaction.transactionType ?? "") ?? .income

        // Convert base64 image string back to Data
        if let base64String = transaction.image,
           let data = Data(base64Encoded: base64String) {
            imageData = data
        }
    }
    
    func fetchCategories(userId: String) {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)]
        
        // Filter categories where the related user.id matches the provided userId
        request.predicate = NSPredicate(format: "user.id == %@", userId)
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("❌ Failed to fetch categories for user \(userId): \(error.localizedDescription)")
        }
    }

    // MARK: - Edit Transaction
    
    /// Applies the edited values to the given transaction and saves the changes.
        /// - Parameters:
        ///   - transaction: The Core Data entity to edit.
        ///   - viewContext: The current Core Data managed object context.
        ///   - dismiss: A closure to dismiss the editing view after saving.
    func editTransaction(_ entity: TransacionsEntity, updated: Transaction) {
        entity.title = updated.title ?? ""
        entity.desc = updated.description ?? ""
        entity.amount = updated.amount ?? 0.0

        if let date = updated.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            entity.date = formatter.string(from: date)
        }

        entity.transactionType = updated.transactionType?.rawValue ?? ""

        if let image = updated.receiptImage {
            entity.image = image
        }
        
        if let categoryName = updated.category?.name {
            let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
            categoryRequest.predicate = NSPredicate(format: "name == %@", categoryName)

            if let matchedCategory = try? context.fetch(categoryRequest).first {
                entity.category = matchedCategory
            }
        }

        PersistanceController.shared.saveContext()
        print("Transaction updated.")
    }

}
