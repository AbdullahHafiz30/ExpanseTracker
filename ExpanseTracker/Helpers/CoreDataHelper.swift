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
        // Create a new UserEntity instance in the context
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
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", uid)
        userRequest.fetchLimit = 1
        // Specifying which related objects should be prefetched along with the object being fetched
        userRequest.relationshipKeyPathsForPrefetching = ["budget", "transaction", "category"]
        
        do {
            // Fetch the first user that matches the predicate
            if let result = try context.fetch(userRequest).first {
                // Create user object to be returned
                let user = User(
                    id: result.id ?? "",
                    name: result.name ?? "",
                    email: result.email ?? "",
                    password: result.password ?? "",
                    image: result.imageURL ?? "",
                    transactions: Array((result.transaction as? Set<TransacionsEntity>)?.map { Transaction(from: $0) } ?? []),
                    budgets: Array((result.budget as? Set<BudgetEntity>)?.map { Budget(from: $0) } ?? []), // Cast result.budget to a Set<BudgetEntity> and use map function to iterate over each BudgetEntity in the set and transform it into a Budget
                    // Explicitly convert the result of the map operation into an array
                    categories: Array((result.category as? Set<CategoryEntity>)?.map { Category(from: $0) } ?? [])
                    // Cast result.category to a Set<CategoryEntity> and use map function to iterate over each CategoryEntity in the set and transform it into a Category
                   // Explicitly convert the result of the map operation into an array
                )
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
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", user.id ?? "")
        userRequest.fetchLimit = 1
        
        do {
            // Fetch the first user that matches the predicate
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
    
    /// Deletes a user from Core Data by their user ID
    /// - Parameter userId: The ID of the user to be deleted from Core Data
    func deleteUser(userId: String) {
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        userRequest.fetchLimit = 1
        do {
            // Fetch the first user that matches the predicate
            if let userToDelete = try context.fetch(userRequest).first{
                // Delete user
                context.delete(userToDelete)
                PersistanceController.shared.saveContext()
                print("✅ User deleted successfully.")
            } else {
                print("User not found.")
            }
        } catch {
            print("❌ Failed to delete user: \(error)")
        }
    }
    
    /// Save an image to the Documents directory
    /// - Parameter image: The `UIImage` to be saved.
    /// - Returns: The filename of the saved image, or `nil` if the save fails.
    func saveImageToDocuments(_ image: UIImage) -> String? {
        // Generates a unique filename for the image using a UUID
        let filename = UUID().uuidString + ".jpg"
        // Retrieves the URL for the app document directory using FileManager
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // Append the file name to the documentsDirectory
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        // Convert the UIImage to a JPEG o turn the image into a format suitable for storage as a file
        if let imageData = image.jpegData(compressionQuality: 0.9) {
            do {
                // Save image to documentsDirectory
                try imageData.write(to: fileURL)
                return filename
            } catch {
                print("❌ Error saving image:", error)
            }
        }
        return nil
    }
    
}
