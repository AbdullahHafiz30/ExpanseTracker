//
//  AddTransactionViewModel.swift
//  ExpanseTracker
//
//  Created by Rawan on 18/10/1446 AH.
//
import SwiftUI
import CoreData

class AddTransactionViewModel: ObservableObject {
    
    private let context = PersistanceController.shared.context

     func addTransaction(
         title: String,
         description: String,
         amount: Double,
         date: Date,
         type: TransactionType,
         selectedCategoryName: String,
         imageData: Data?
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

         let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "name == %@", selectedCategoryName)

         do {
             let results = try context.fetch(fetchRequest)
             if let matchedCategory = results.first {
                 newTransaction.category = matchedCategory
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
 }

