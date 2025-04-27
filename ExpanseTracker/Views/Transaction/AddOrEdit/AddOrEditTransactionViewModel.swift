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
    
    // MARK: - Variables
    
    @Published var title = ""
    @Published var description = ""
    @Published var amount: String = ""
    @Published var date = Date()
    @Published var type: TransactionType = .expense
    @Published var category: Category? = nil
    @Published var imageData: Data? = nil
    @Published var amountError: String?
    @Published var categories: [Category] = []
    let context = PersistanceController.shared.context

    // MARK: - Initialize ViewModel from Existing Transaction
    /// Loads the data of an existing transaction into the form.
    /// - Parameter transaction: The existing transaction to edit.
    func initialize(transaction: TransacionsEntity?) {
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
            category = transaction.category.map{
                Category(id: $0.id, name: $0.name, color: $0.color, icon: $0.icon, categoryType: CategoryType(rawValue: $0.categoryType ?? ""), budgetLimit: $0.budgetLimit)
            }

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
            categories = try context.fetch(request).map{
                Category(id: $0.id, name: $0.name, color: $0.color, icon: $0.icon, categoryType: CategoryType(rawValue: $0.categoryType ?? ""), budgetLimit: $0.budgetLimit)
            }
        } catch {
            print("Failed to fetch categories for user \(userId): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Add Transaction
    /// Creates a new transaction and saves it to CoreData
    /// - Parameters:
    ///   - title: Title of the transaction
    ///   - description: Description of the transaction
    ///   - amount: Amount of money involved
    ///   - date: Date of the transaction
    ///   - type: Type (income or expense)
    ///   - selectedCategoryName: Name of the selected category
    ///   - imageData: Optional image (e.g., receipt)
    ///   - userId: The ID of the user adding the transaction
    func addTransaction(
        title: String,
        description: String,
        amount: Double,
        date: Date,
        type: TransactionType,
        selectedCategoryId: String,
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
        fetchRequest.predicate = NSPredicate(format: "id == %@", selectedCategoryId)
        
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
            print("Transaction saved.")
        } catch {
            print("Error saving transaction: \(error.localizedDescription)")
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
        context: NSManagedObjectContext,
        selectedCategory: Category
    ) {
        existing.title = title
        existing.desc = description
        existing.amount = Double(amount) ?? 0.0

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        existing.date = formatter.string(from: date)

        existing.transactionType = type.rawValue
        
        let categoryFetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "id == %@", selectedCategory.id ?? "")

        if let matchedCategory = try? context.fetch(categoryFetchRequest).first {
                existing.category = matchedCategory
        }
        
        if let updatedImageData = imageData {
            existing.image = updatedImageData.base64EncodedString()
        }
        
        PersistanceController.shared.saveContext()
        print("Transaction updated.")
    }
    
    // MARK: - Validation
    /// Validates if the input string is a valid number format
    /// - Parameter text: The text to validate
    /// - Returns: Boolean indicating if the input is numeric
    func isValidNumber(_ text: String) -> Bool {
        let numberPattern = #"^[0-9.,]+$"#
        return text.range(of: numberPattern, options: .regularExpression) != nil
    }
    /// Validates the transaction amount and updates error message if needed
    /// - Parameter text: The amount string to validate
    func validateAmount(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            amountError = "Price is required."
            return
        }
        
        guard isValidNumber(trimmed) else {
            amountError = "Price must be a number only."
            return
        }
        
        let sanitized = trimmed.replacingOccurrences(of: ",", with: ".")
        if let value = Double(sanitized), value > 0 {
            amountError = nil
        } else {
            amountError = "Price must be greater than 0."
        }
    }
}
