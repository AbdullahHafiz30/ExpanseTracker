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
    
    @Published var categories: [Category] = []
    @Published var searchText: String = ""
    @Published var selectedType: CategoryType? = nil
    
    private let context = PersistanceController.shared.context
    
    init() {
        loadCategories()
    }
    
    // MARK: - Load All Categories
    func loadCategories() {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            self.categories = entities.map { entity in
                Category(
                    id: entity.id ?? UUID().uuidString,
                    name: entity.name ?? "",
                    color: entity.color ?? "",
                    icon: entity.icon ?? "",
                    categoryType: CategoryType(rawValue: entity.categoryType ?? "") ?? .other,
                    budgetLimit: entity.budgetLimit ?? 0.0
                )
            }
        } catch {
            print("⚠️ Failed to fetch categories: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Add New Category
    func addCategory(_ category: Category) {
        let newEntity = CategoryEntity(context: context)
        newEntity.id = category.id
        newEntity.name = category.name
        newEntity.color = category.color
        newEntity.icon = category.icon
        newEntity.categoryType = category.categoryType?.rawValue ?? CategoryType.other.rawValue
        newEntity.budgetLimit = category.budgetLimit ?? 0.0
        
        PersistanceController.shared.saveContext()
        loadCategories()
        print("✅ Category added successfully")
    }
    
    // MARK: - Update Existing Category
    func updateCategory(_ category: Category) {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id ?? "")
        
        do {
            if let entity = try context.fetch(request).first {
                entity.name = category.name
                entity.color = category.color
                entity.icon = category.icon
                entity.categoryType = category.categoryType?.rawValue ?? CategoryType.other.rawValue
                entity.budgetLimit = category.budgetLimit ?? 0.0
                
                PersistanceController.shared.saveContext()
                loadCategories()
                print("✅ Category updated successfully")
            }
        } catch {
            print("⚠️ Failed to update category: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Category by ID
    func deleteCategory(withId id: String) {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                PersistanceController.shared.saveContext()
                loadCategories()
                print("🗑️ Category deleted successfully")
            }
        } catch {
            print("⚠️ Failed to delete category: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete All Categories
    func deleteAllCategories() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            PersistanceController.shared.saveContext()
            loadCategories()
            print("🧹 All categories deleted successfully")
        } catch {
            print("⚠️ Failed to delete all categories: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch Single Category by ID
    func getCategory(byId id: String) -> Category? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let result = try context.fetch(request).first {
                return Category(
                    id: result.id ?? UUID().uuidString,
                    name: result.name ?? "",
                    color: result.color ?? "",
                    icon: result.icon ?? "",
                    categoryType: CategoryType(rawValue: result.categoryType ?? "") ?? .other,
                    budgetLimit: result.budgetLimit ?? 0.0
                )
            }
        } catch {
            print("⚠️ Failed to fetch category by ID: \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: - Save Category to Core Data with User ID
    func saveCategoryToCoreData(category: Category, userId: String) {
        print("save category to core data")
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        do {
            if let existingUserEntity = try context.fetch(userRequest).first {
                let newCategory = CategoryEntity(context: context)
                newCategory.id = category.id
                newCategory.name = category.name
                newCategory.color = category.color
                newCategory.icon = category.icon
                newCategory.categoryType = category.categoryType?.rawValue
                newCategory.budgetLimit = category.budgetLimit ?? 0.0
                
                existingUserEntity.addToCategory(newCategory)
                print("✅ Added new category for the user.")
                
                PersistanceController.shared.saveContext()
            } else {
                print("No user found with id: \(userId)")
            }
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }
    
    // MARK: - Fetch All Categories from Core Data
    func fetchAllCategoriesFromCoreData() -> [Category] {
        print("fetching list of Categories from core data")
        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        let categoryData = (try! context.fetch(categoryRequest))
        
        let categoryMapping = categoryData.map {
            Category(
                id: $0.id ?? "",
                name: $0.name ?? "",
                color: $0.color ?? "",
                icon: $0.icon ?? "",
                categoryType: CategoryType(rawValue: $0.categoryType ?? "") ?? .other,
                budgetLimit: $0.budgetLimit
            )
        }
        
        print(categoryMapping)
        
        return categoryMapping
    }
    
    // MARK: - Fetch Category from Core Data by Category ID and User ID
    func fetchCategoryFromCoreDataWithId(categoryId: String, userId: String) -> Category? {
        print("Fetching category with id: \(categoryId)")
        
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        userRequest.fetchLimit = 1
        
        do {
            if let user = try context.fetch(userRequest).first {
                if let matchedCategory = user.category?
                    .compactMap({ $0 as? CategoryEntity })
                    .first(where: { $0.id == categoryId }) {
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
    
    // MARK: - Save Edited Category
    func saveEditedCategory(category: Category) {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id ?? "")
        
        do {
            if let entity = try context.fetch(request).first {
                entity.name = category.name
                entity.color = category.color
                entity.icon = category.icon
                entity.categoryType = category.categoryType?.rawValue ?? CategoryType.other.rawValue
                entity.budgetLimit = category.budgetLimit ?? 0.0
                
                PersistanceController.shared.saveContext()
                loadCategories()
                print("✅ Category updated successfully")
            }
        } catch {
            print("⚠️ Failed to update category: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Filtered Categories (for UI)
    var filteredCategories: [Category] {
        var filtered = categories
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
        
        if let type = selectedType {
            filtered = filtered.filter {
                $0.categoryType == type
            }
        }
        
        return filtered
    }
    
    // MARK: - Save Edited Category with User ID
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
                print("✅ Category updated successfully.")
            } else {
                print("No category found with id: \(category.id ?? "")")
            }
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }
    
    // MARK: - Delete All Categories
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
