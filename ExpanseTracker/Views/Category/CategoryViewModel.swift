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
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @Published var userId: String

    
    private let context = PersistanceController.shared.context
    
    
    init(userId: String) {
        self.userId = userId
        loadCategories()
    }
    
    // MARK: - Load All Categories
    func loadCategories() {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "user.id == %@", userId)
        
        do {
            let entities = try context.fetch(request)
            self.categories = entities.map { entity in
                Category(
                    id: entity.id ?? UUID().uuidString,
                    name: entity.name ?? "",
                    color: entity.color ?? "",
                    icon: entity.icon ?? "",
                    categoryType: CategoryType(rawValue: entity.categoryType ?? "") ?? .other,
                    budgetLimit: entity.budgetLimit
                )
            }
        } catch {
            print("⚠️ Failed to fetch categories: \(error.localizedDescription)")
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
                    budgetLimit: result.budgetLimit
                )
            }
        } catch {
            print("⚠️ Failed to fetch category by ID: \(error.localizedDescription)")
        }
        return nil
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
}
