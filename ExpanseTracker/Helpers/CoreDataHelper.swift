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
struct CoreDataHelper {
    private let context = PersistanceController.shared.context
    
    func saveUserToCoreData(user: User, uid: String) {
        let newUser = UserEntity(context: context)
        newUser.id = uid
        newUser.name = user.name
        newUser.email = user.email
        newUser.password = user.password
        newUser.imageURL = user.image
        
        PersistanceController.shared.saveContext()
        UIDManager.saveUID(uid)
    }
    
    func fetchUserFromCoreData(uid: String) -> User? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uid)
        
        do {
            if let result = try context.fetch(request).first {
                return User(
                    id: result.id,
                    name: result.name,
                    email: result.email,
                    password: result.password,
                    image: result.imageURL,
                    transactions: [],
                    budgets: [],
                    categories: []
                )
            }
        } catch {
            print("Error fetching user: \(error)")
        }
        return nil
    }
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
    
    func saveImageToDocuments(_ image: UIImage) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
