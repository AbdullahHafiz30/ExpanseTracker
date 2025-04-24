//
//  AddOrEditTransactionViewModel.swift
//  ExpanseTracker
//
//  Created by Rawan on 24/10/1446 AH.
//

import SwiftUI
import CoreData

/// A view model responsible for managing the state and logic for adding or editing a transaction.
class AddOrEditTransactionViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var title = ""
    @Published var description = ""
    @Published var amount: String = ""
    @Published var date = Date()
    @Published var type: TransactionType = .expense
    @Published var categoryName = ""
    @Published var imageData: Data? = nil
    @Published var categories: [CategoryEntity] = []
    
    let context = PersistanceController.shared.context

    // MARK: - Initialize ViewModel from Existing Transaction
    /// Loads the data of an existing transaction into the form.
    /// - Parameter transaction: The existing transaction to edit.
    func initialize(with transaction: TransacionsEntity?) {
        if let transaction = transaction {
            title = transaction.title ?? ""
            description = transaction.desc ?? ""
            amount = String(transaction.amount)

            // Parse the stored date string back to Date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            if let dateString = transaction.date,
               let parsedDate = formatter.date(from: dateString) {
                date = parsedDate
            }

            type = TransactionType(rawValue: transaction.transactionType ?? "") ?? .expense
            categoryName = transaction.category?.name ?? ""

            // Decode image data from Base64 string
            if let base64String = transaction.image,
               let data = Data(base64Encoded: base64String) {
                imageData = data
            }
        }
    }

    // MARK: - Fetch Categories for Logged-In User
    /// Loads categories associated with the current user.
    /// - Parameter userId: The ID of the logged-in user.
    func fetchCategories(userId: String) {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)]
        request.predicate = NSPredicate(format: "user.id == %@", userId)
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Failed to fetch categories for user \(userId): \(error.localizedDescription)")
        }
    }

    func addTransaction(
        title: String,
        description: String,
        amount: Double,
        date: Date,
        type: TransactionType,
        selectedCategoryName: String,
        imageData: Data?,
        userId: String
    ) {
        let newTransaction = TransacionsEntity(context: context)
        newTransaction.id = UUID().uuidString
        newTransaction.title = title
        newTransaction.desc = description
        newTransaction.amount = amount
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        newTransaction.date = formatter.string(from: date)
        newTransaction.transactionType = type.rawValue

        if let imageData = imageData {
            newTransaction.image = imageData.base64EncodedString()
        }

        // Fetch user and associate transaction with the correct user and category
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)

        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", selectedCategoryName)

        do {
            if let existingUserEntity = try context.fetch(userRequest).first {
                let results = try context.fetch(fetchRequest)
                if let matchedCategory = results.first {
                    newTransaction.category = matchedCategory
                }
                existingUserEntity.addToTransaction(newTransaction)
                PersistanceController.shared.saveContext()
            }
        } catch {
            print("Error fetching category or user: \(error.localizedDescription)")
        }

        do {
            try context.save()
            print("✅ Transaction saved.")
        } catch {
            print("❌ Error saving transaction: \(error.localizedDescription)")
        }
    }

    // MARK: - Update Existing Transaction
    /// Updates the specified existing transaction in the database.
    /// - Parameters:
    ///   - existing: The TransacionsEntity to update.
    ///   - context: The NSManagedObjectContext to use for saving.
    ///   - selectedCategory: The newly selected category to associate.
    func updateTransaction(
        _ existing: TransacionsEntity,
        in context: NSManagedObjectContext,
        selectedCategory: CategoryEntity
    ) {
        existing.title = title
        existing.desc = description
        existing.amount = Double(amount) ?? 0.0

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        existing.date = formatter.string(from: date)

        existing.transactionType = type.rawValue
        existing.category = selectedCategory

        if let updatedImageData = imageData {
            existing.image = updatedImageData.base64EncodedString()
        }

        PersistanceController.shared.saveContext()
        print("Transaction updated.")
    }
}
