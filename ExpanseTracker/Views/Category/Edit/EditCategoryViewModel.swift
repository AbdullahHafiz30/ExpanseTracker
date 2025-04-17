//
//  EditCategoryViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 18/10/1446 AH.
//

import SwiftUI
import CoreData
import Combine

class EditCategoryViewModel: ObservableObject {
    private let context = PersistanceController.shared.context
    
    func fetchCategoryFromCoreDataWithId(categoryId: String, userId: String) -> Category? {
        print("Fetching category with id: \(categoryId)")
        
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        userRequest.fetchLimit = 1
        
        do {
            // Fetch the first user that matches the predicate
            if let user = try context.fetch(userRequest).first {
              // Check if the user has categories and find the category and then finds the first category whose id matches the categoryId
                if let matchedCategory = user.category?
                                                .compactMap({ $0 as? CategoryEntity })
                                                .first(where: { $0.id == categoryId }) {
                    
                    // Create Category object
                    let category = Category(
                        id: matchedCategory.id ?? "",
                        name: matchedCategory.name ?? "",
                        color: matchedCategory.color ?? "",
                        icon: matchedCategory.icon ?? "",
                        categoryType: CategoryType(rawValue: matchedCategory.categoryType ?? "") ?? .other,
                        budgetLimit: matchedCategory.budgetLimit
                    )
                    
                    print("✅ Found category: \(category.name ?? "")")
                    return category
                } else {
                    print("❌ Category with id \(categoryId) not found in user's categories")
                    return nil
                }
            } else {
                print("❌ User with id \(userId) not found")
                return nil
            }
        } catch {
            print("❌ Error fetching user or category: \(error)")
            return nil
        }
    }
    
    func saveEditedCategory(category: Category, userId: String) {
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        userRequest.fetchLimit = 1
        
        do {
            // Fetch the first user that matches the predicate
            if let user = try context.fetch(userRequest).first {
              // Check if the user has categories and find the category and then finds the first category whose id matches the categoryId
                if let matchedCategory = user.category?
                                                .compactMap({ $0 as? CategoryEntity })
                                                .first(where: { $0.id == category.id }) {
                    
                    // Update the Core Data object
                    matchedCategory.name = category.name
                    matchedCategory.icon = category.icon
                    matchedCategory.color = category.color
                    matchedCategory.categoryType = category.categoryType?.rawValue
                    matchedCategory.budgetLimit = category.budgetLimit ?? 0.0
                    
                    // Save the context
                    PersistanceController.shared.saveContext()
                    print("✅ Category updated successfully.")
                }
            } else {
                print("No category found with id: \(category.id ?? "")")
            }
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }
    
}
