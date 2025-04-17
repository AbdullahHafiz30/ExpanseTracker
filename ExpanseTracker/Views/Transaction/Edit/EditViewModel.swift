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

    // MARK: - Edit Transaction
    
    /// Applies the edited values to the given transaction and saves the changes.
        /// - Parameters:
        ///   - transaction: The Core Data entity to edit.
        ///   - viewContext: The current Core Data managed object context.
        ///   - dismiss: A closure to dismiss the editing view after saving.
    func editTransaction(_ transaction: TransacionsEntity, viewContext: NSManagedObjectContext, dismiss: @escaping () -> Void) {
        transaction.title = editedTitle
        transaction.desc = editedDescription
        transaction.amount = editedAmount
        
        // Format and assign the edited date as a string
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        transaction.date = formatter.string(from: editedDate)

        transaction.transactionType = editedType.rawValue

        // Convert and assign image data if available
        if let imageData = imageData {
            transaction.image = imageData.base64EncodedString()
        }

        // Fetch the CategoryEntity that matches the edited category name
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", editedCategoryName)
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let matchedCategory = results.first {
                transaction.category = matchedCategory
            }
        } catch {
            print("Error fetching category: \(error.localizedDescription)")
        }
        
        // Save context and dismiss view
        PersistanceController.shared.saveContext()
        dismiss()
    }

}
