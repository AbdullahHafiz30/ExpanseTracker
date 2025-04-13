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

    
    func saveCategoryToCoreData(category: Category) {
        print("save")

            let newCategory = CategoryEntity(context: context)
            newCategory.id = category.id
            newCategory.name = category.name
            newCategory.color = category.color
            newCategory.icon = category.icon
            newCategory.categoryType = category.categoryType.rawValue
            newCategory.budgetLimit = category.budgetLimit
        
        PersistanceController.shared.saveContext()
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
    
    func fetchCategoryFromCoreDataWithId(id: String) -> Category? {
        print("Fetching category with id: \(id)")
        
        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "id == %@", id)
        categoryRequest.fetchLimit = 1

        do {
            if let result = try context.fetch(categoryRequest).first {
                let category = Category(
                    id: result.id ?? "",
                    name: result.name ?? "",
                    color: result.color ?? "",
                    icon: result.icon ?? "",
                    categoryType: CategoryType(rawValue: result.categoryType ?? "") ?? .other,
                    budgetLimit: result.budgetLimit
                )
                print("Fetched: \(category)")
                return category
            } else {
                print("No category found with id: \(id)")
                return nil
            }
        } catch {
            print("Error fetching category: \(error)")
            return nil
        }
    }

    func saveEditedCategory(category: Category) {
        // Fetch the Core Data object directly
        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "id == %@", category.id)

        do {
            if let existingCategoryEntity = try context.fetch(categoryRequest).first {
                // Update the Core Data object
                existingCategoryEntity.name = category.name
                existingCategoryEntity.icon = category.icon
                existingCategoryEntity.color = category.color
                existingCategoryEntity.categoryType = category.categoryType.rawValue
                existingCategoryEntity.budgetLimit = category.budgetLimit

                // Save the context
                PersistanceController.shared.saveContext()
                print("Category updated successfully.")
            } else {
                print("No category found with id: \(category.id)")
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

    

}


