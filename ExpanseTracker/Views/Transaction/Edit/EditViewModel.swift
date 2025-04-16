//
//  EditViewModel.swift
//  ExpanseTracker
//
//  Created by Tahani Ayman on 18/10/1446 AH.
//

import SwiftUI
import PhotosUI
import CoreData

final class EditTransactionViewModel: ObservableObject {
    @Published var editedTitle: String = ""
    @Published var editedDescription: String = ""
    @Published var editedAmount: Double = 0.0
    @Published var editedDate: Date = Date()
    @Published var editedCategoryName: String = ""
    @Published var editedType: TransactionType = .income
    @Published var selectedImage: PhotosPickerItem? = nil
    @Published var imageData: Data?

    func initialize(from transaction: TransacionsEntity) {
        editedTitle = transaction.title ?? ""
        editedDescription = transaction.desc ?? ""
        editedAmount = transaction.amount

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dateString = transaction.date, let parsedDate = formatter.date(from: dateString) {
            editedDate = parsedDate
        } else {
            editedDate = Date()
        }

        editedCategoryName = transaction.category?.name ?? ""
        editedType = TransactionType(rawValue: transaction.transactionType ?? "") ?? .income

        if let base64String = transaction.receiptImage,
           let data = Data(base64Encoded: base64String) {
            imageData = data
        }
    }

    func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                await MainActor.run {
                    self.imageData = data
                }
            }
        } catch {
            print("Failed to load image data: \(error)")
        }
    }

    func editTransaction(_ transaction: TransacionsEntity, in viewContext: NSManagedObjectContext, dismiss: @escaping () -> Void) {
        transaction.title = editedTitle
        transaction.desc = editedDescription
        transaction.amount = editedAmount

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        transaction.date = formatter.string(from: editedDate)

        transaction.transactionType = editedType.rawValue

        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", editedCategoryName)

        if let imageData = imageData {
            transaction.receiptImage = imageData.base64EncodedString()
        }

        do {
            let results = try viewContext.fetch(fetchRequest)
            if let matchedCategory = results.first {
                transaction.category = matchedCategory
            }
        } catch {
            print("Error fetching category: \(error.localizedDescription)")
        }

        PersistanceController.shared.saveContext()
        dismiss()
    }
}
