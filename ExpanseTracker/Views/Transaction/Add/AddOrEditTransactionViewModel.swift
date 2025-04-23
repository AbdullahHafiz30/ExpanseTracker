//
//  AddOrEditTransactionViewModel.swift
//  ExpanseTracker
//
//  Created by Rawan on 24/10/1446 AH.
//
import SwiftUI
import CoreData

class AddOrEditTransactionViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var amount: String = ""
    @Published var date = Date()
    @Published var type: TransactionType = .expense
    @Published var categoryName = ""
    @Published var imageData: Data?
    @Published var amountError: String?
    @Published var categories: [CategoryEntity] = []
    let context = PersistanceController.shared.context
    
    func initialize(with transaction: TransacionsEntity?) {
        if let transaction = transaction {
            title = transaction.title ?? ""
            description = transaction.desc ?? ""
            amount = String(transaction.amount)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            if let dateString = transaction.date, let parsedDate = formatter.date(from: dateString) {
                date = parsedDate
            }
            type = TransactionType(rawValue: transaction.transactionType ?? "") ?? .expense
            categoryName = transaction.category?.name ?? ""
            if let base64String = transaction.image,
               let data = Data(base64Encoded: base64String) {
                imageData = data
            }

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

        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
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
            print("Error fetching category: \(error.localizedDescription)")
        }

        do {
            try context.save()
            print("Transaction saved")
        } catch {
            print("Error saving transaction: \(error.localizedDescription)")
        }
    }
    
    func updateTransaction(_ existing: TransacionsEntity, in context: NSManagedObjectContext, selectedCategory: CategoryEntity) {
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
    
//    func validateAmount(_ input: String) -> String? {
//        let sanitized = input.replacingOccurrences(of: ",", with: ".")
//        if let value = Double(sanitized), value >= 0 {
//            return nil  // Valid input
//        } else {
//            return "Please enter a valid number"
//        }
//    }
//    func validateAmount(_ text: String) {
//        if isValidNumber(text) {
//            amountError = nil
//        } else {
//            amountError = "Price must be a number only."
//        }
//    }
    func isValidNumber(_ text: String) -> Bool {
        let numberPattern = #"^[0-9.,]+$"#
        return text.range(of: numberPattern, options: .regularExpression) != nil
    }
    func validateAmount(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            amountError = "Price can not be empty."
            return
        }

        guard isValidNumber(trimmed) else {
            amountError = "Price must be a number only."
            return
        }

        let sanitized = trimmed.replacingOccurrences(of: ",", with: ".")
        if let value = Double(sanitized), value >= 0 {
            amountError = nil
        } else {
            amountError = "Price must be a valid positive number."
        }
    }

}
