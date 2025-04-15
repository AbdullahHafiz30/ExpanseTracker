
//
//  CategoryViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 15/10/1446 AH.
//

import SwiftUI
import CoreData
import Combine

class CategoryViewModel: ObservableObject {
    
    @Published var category: [Category] = []
    private let context = PersistanceController.shared.context

    func saveCategoryToCoreData(category: Category, userId: String) {
        print("save category to core data")
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        do{
            if let existingUserEntity = try context.fetch(userRequest).first {
                let newCategory = CategoryEntity(context: context)
                newCategory.id = category.id
                newCategory.name = category.name
                newCategory.color = category.color
                newCategory.icon = category.icon
                newCategory.categoryType = category.categoryType?.rawValue
                newCategory.budgetLimit = category.budgetLimit ?? 0.0
                
                existingUserEntity.addToCategory(newCategory)
                print("Added new category for the user.")
                
                PersistanceController.shared.saveContext()
            }
            else {
                print("No user found with id: \(userId)")
            }
        }catch {
        print("❌ Failed to save context: \(error)")
    }
}
    
    
    func fetchAllCategoriesFromCoreData() -> [Category] {
        print ("fetching list of Categories from core data")
        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        let categoryData = (try! context.fetch(categoryRequest))
        
        let categoryMapping = categoryData.map {
            Category(
                id: $0.id ?? "",
                name: $0.name ?? "",
                color: $0.color ?? "",
                icon: $0.icon ?? "",
                categoryType: CategoryType(rawValue:$0.categoryType  ?? "") ?? .other,
                budgetLimit: $0.budgetLimit
            )
        }
        
        print(categoryMapping)
        
        return categoryMapping
    }
    
    func fetchCategoryFromCoreDataWithId(categoryId: String, userId: String) -> Category? {
        print("Fetching category with id: \(categoryId)")
        
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        userRequest.fetchLimit = 1

        do {
            if let user = try context.fetch(userRequest).first {
                let categories = user.category?.allObjects as? [CategoryEntity] ?? []

                if let matchedCategory = category.first(where: { $0.id == categoryId }) {
                    let category = Category(
                        id: matchedCategory.id ?? "",
                        name: matchedCategory.name ?? "",
                        color: matchedCategory.color ?? "",
                        icon: matchedCategory.icon ?? "",
                        categoryType: CategoryType(rawValue: matchedCategory.categoryType?.rawValue ?? "") ?? .other,
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
        // Fetch the Core Data object directly
        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "id == %@", category.id ?? "")

        do {
            if let existingCategoryEntity = try context.fetch(categoryRequest).first {
                // Update the Core Data object
                existingCategoryEntity.name = category.name
                existingCategoryEntity.icon = category.icon
                existingCategoryEntity.color = category.color
                existingCategoryEntity.categoryType = category.categoryType?.rawValue
                existingCategoryEntity.budgetLimit = category.budgetLimit ?? 0.0

                // Save the context
                PersistanceController.shared.saveContext()
                print("Category updated successfully.")
            } else {
                print("No category found with id: \(category.id ?? "")")
            }
        } catch {
            print("❌ Failed to save context: \(error)")
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

    

}
