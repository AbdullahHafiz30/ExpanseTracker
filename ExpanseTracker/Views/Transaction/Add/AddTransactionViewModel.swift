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
    //MARK: - Functions
    
    /// Adds a new transaction to Core Data.
    /// - Parameters:
    ///   - title: The title of the transaction.
    ///   - description: A short description of the transaction.
    ///   - amount: The monetary amount of the transaction.
    ///   - date: The date when the transaction occurred.
    ///   - type: The transaction type (e.g., income or expense).
    ///   - selectedCategoryName: The name of the category to associate with this transaction.
    ///   - imageData: Optional image data to be stored with the transaction.
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
 }

