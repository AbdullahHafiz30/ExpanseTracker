//
//  TransactionViewModel.swift
//  ExpanseTracker
//
//  Created by Rawan on 16/10/1446 AH.
//
//import SwiftUI
//import CoreData
//
//class TransactionViewModel: ObservableObject{
//    private let context = PersistanceController.shared.context
//
//    func addTransaction(
//           title: String,
//           description: String,
//           amount: String,
//           date: Date,
//           type: AddTransaction.transactionType,
//           selectedCategoryName: String,
//           imageData: Data?
//       ) {
//           // Get UID from UIDManager 
//           guard let userId = UIDManager.loadUID() else {
//               print("❌ User ID not found in UIDManager")
//               return
//           }
//
//           let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
//           userRequest.predicate = NSPredicate(format: "id == %@", userId)
//
//           do {
//               if let existingUser = try context.fetch(userRequest).first {
//                   guard let selectedCategory = (existingUser.category as? Set<Category>)?.first(where: { $0.name == selectedCategoryName }) else {
//                       print("Category not found")
//                       return
//                   }
//
//                   let newTransaction = TransacionsEntity(context: context)
//                   newTransaction.id = UUID().uuidString
//                   newTransaction.title = title
//                   newTransaction.desc = description
//                   newTransaction.amount = amount
//                   newTransaction.date = convertDateToString(date: date)
//                   newTransaction.transactionType = type.rawValue
//                   newTransaction.image = imageData
//                   //newTransaction.category = selectedCategory 
//
//                   existingUser.addToTransaction(newTransaction)
//
//                   try context.save()
//                   print("Transaction added successfully.")
//               } else {
//                   print("User not found with ID: \(userId)")
//               }
//           } catch {
//               print("Error adding transaction: \(error.localizedDescription)")
//           }
//       }
//       
//       private func convertDateToString(date: Date) -> String {
//           let formatter = DateFormatter()
//           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//           return formatter.string(from: date)
//       }
////    func addTransaction(title: String, description: String, amount: String, date: Date, type: AddTransaction.transactionType, selectedCategoryName: String, imageData: Data?) {
////        guard let userId = userVM.uid else {
////            print("❌ User ID is nil in addTransaction()")
////            return
////        }
////
////        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
////        userRequest.predicate = NSPredicate(format: "id == %@", userId)
////
////        do {
////            if let existingUser = try context.fetch(userRequest).first {
////                guard let selectedCategory = (existingUser.category as? Set<Category>)?.first(where: { $0.name == selectedCategoryName }) else {
////                    print("Category not found")
////                    return
////                }
////
////                let newTransaction = TransacionsEntity(context: context)
////                newTransaction.id = UUID().uuidString
////                newTransaction.title = title
////                newTransaction.desc = description
////                newTransaction.amount = amount
////                newTransaction.date = convertDateToString(date: date)
////                newTransaction.transactionType = type.rawValue
////                newTransaction.image = imageData
////
////                existingUser.addToTransaction(newTransaction)
////
////                try context.save()
////                print("Transaction added successfully.")
////            } else {
////                print("User not found with ID: \(userId)")
////            }
////        } catch {
////            print("Error adding transaction: \(error.localizedDescription)")
////        }
////    }
////    private func convertDateToString(date: Date) -> String {
////        let formatter = DateFormatter()
////        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
////        return formatter.string(from: date)
////    }
//
//}
