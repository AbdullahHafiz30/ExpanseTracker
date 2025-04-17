//
//  CoreDataHelper.swift
//  ExpanseTracker
//
//  Created by Rawan on 17/10/1446 AH.
//

import CoreData
import FirebaseAuth
import CoreData
import Combine
import UIKit

/// CoreDataHelper is a helper class to handle Core Data operations for saving, fetching, and updating user data.
struct CoreDataHelper {
    
    //MARK: - Variables
    private let context = PersistanceController.shared.context
    
    // MARK: - Functions
    
    /// Save user data to Core Data
    /// - Parameters:
    ///   - user: The `User` object that holds the data to be saved.
    ///   - uid: The unique identifier for the user.
    func saveUserToCoreData(user: User, uid: String) {
        let newUser = UserEntity(context: context)
        newUser.id = uid
        newUser.name = user.name
        newUser.email = user.email
        newUser.password = user.password
        newUser.imageURL = user.image
        
        PersistanceController.shared.saveContext()
        // Save the UID using UserDefaults
        UIDManager.saveUID(uid)
    }
    
    /// Fetch user data from Core Data based on the UID
    /// - Parameter uid: The unique identifier for the user.
    /// - Returns: A `User` object populated with data from Core Data, or `nil` if not found.
    func fetchUserFromCoreData(uid: String) -> User? {
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", uid)
        userRequest.fetchLimit = 1
        userRequest.relationshipKeyPathsForPrefetching = [
            "budget",
            "transaction",
            "category"
        ]
        
        do {
            if let result = try context.fetch(userRequest).first {
                let user = User(
                    id: result.id ?? "",
                    name: result.name ?? "",
                    email: result.email ?? "",
                    password: result.password ?? "",
                    image: result.imageURL ?? "",
                    transactions: Array(
                        result.transaction as? Set<Transaction> ?? []
                    ),
                    budgets: Array(
                        (result.budget as? Set<BudgetEntity>)?.map { Budget(
                            from: $0
                        )
                        } ?? []),
                    categories: Array(result.category as? Set<Category> ?? [])
                )
                print("=========\(String(describing: result.budget))")
                if let budgetsSet = result.budget as? Set<Budget> {
                    for budget in budgetsSet {
                        print(
                            "Budget: \(budget.id ?? "no id") - Amount: \(String(describing: budget.amount))"
                        )
                    }
                } else {
                    print("budget is nil or not a Set")
                }
                print("Fetched: \(user)")
                return user
            } else {
                print("No user found with id: \(uid)")
                return nil
            }
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    
    /// Save edited user data to Core Data
    /// - Parameter user: The updated `User` object that holds the data to be saved.
    func saveEditedUser(user: User) {
        // Fetch the Core Data object directly
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", user.id ?? "")
        
        do {
            if let existingUserEntity = try context.fetch(userRequest).first {
                // Update the Core Data object
                existingUserEntity.name = user.name
                existingUserEntity.email = user.email
                existingUserEntity.password = user.password
                existingUserEntity.imageURL = user.image
                
                // Save the context
                PersistanceController.shared.saveContext()
                print("User updated successfully.")
            } else {
                print("No User found with id: \(user.id ?? "")")
            }
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    /// Save an image to the Documents directory
    /// - Parameter image: The `UIImage` to be saved.
    /// - Returns: The filename of the saved image, or `nil` if the save fails.
    func saveImageToDocuments(_ image: UIImage) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        if let imageData = image.jpegData(compressionQuality: 0.9) {
            do {
                try imageData.write(to: fileURL)
                return filename
            } catch {
                print("❌ Error saving image:", error)
            }
        }
        return nil
    }
    
}
