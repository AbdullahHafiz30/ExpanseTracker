//
//  UserViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 16/10/1446 AH.
//


//
//  createUser.swift
//  ExpensesMonthlyProjrct
//
//  Created by Rayaheen Mseri on 15/10/1446 AH.
//


import SwiftUI
import CoreData
import Combine

class   UserViewModel: ObservableObject {
    @Published var category: [Category] = []
    private let context = PersistanceController.shared.context

    
    func saveUserToCoreData(user: User) {
        print("save")

        let newUser = UserEntity(context: context)
        newUser.id = UUID().uuidString
        newUser.name = user.name
        newUser.email = user.email
        newUser.password = user.password
        newUser.imageURL = user.image
        
        PersistanceController.shared.saveContext()
        
        print(newUser.id ?? "")
        var myuser = fetchUserFromCoreDataWithId(id: newUser.id ?? "")
        print("my user is \(String(describing: myuser))")
    }
    
    
    func fetchUserFromCoreDataWithId(id: String) -> User? {
        print("Fetching user with id: \(id)")
        
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", id)
        userRequest.fetchLimit = 1

        do {
            if let result = try context.fetch(userRequest).first {
                let user = User(
                    id: result.id ?? "",
                    name: result.name ?? "",
                    email: result.email ?? "",
                    password: result.password ?? "",
                    image: result.imageURL ?? "",
                    transactions: [],
                    budgets: [],
                    categories: []
                )
                print("Fetched: \(user)")
                return user
            } else {
                print("No category found with id: \(id)")
                return nil
            }
        } catch {
            print("Error fetching category: \(error)")
            return nil
        }
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
    
    
    func deleteAll() {
        let newsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: newsRequest)
        
        do {
            // Execute the delete request
            try context.execute(deleteRequest)
            // Save the context after deletion
            PersistanceController.shared.saveContext()
            print("All categories deleted successfully.")
        } catch {
            print("Delete Error \(error)")
        }
    }

    func saveImageToDocuments(_ image: UIImage) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)

        if let imageData = image.jpegData(compressionQuality: 0.9) {
            do {
                try imageData.write(to: fileURL)
                return filename // ✅ فقط اسم الملف
            } catch {
                print("❌ Error saving image:", error)
            }
        }
        return nil
    }
}


