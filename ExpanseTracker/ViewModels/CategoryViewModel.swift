//import SwiftUI
//import CoreData
//import Combine
//
//class CategoryViewModel: ObservableObject {
//    @Published var categories: [Category] = []
//    @Published var searchText: String = ""
//    @Published var selectedType: CategoryType? = nil
//    //@Published var filteredCategories: [Category] = []
//
//    private let context = PersistanceController.shared.context
//
//    init() {
//        loadCategories()
//    }
//
//<<<<<<< Updated upstream
//    // MARK: - Load All Categories
//    func loadCategories() {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//=======
//            let newCategory = CategoryEntity(context: context)
//            newCategory.id = category.id
//            newCategory.name = category.name
//            newCategory.color = category.color
//            newCategory.icon = category.icon
//        newCategory.categoryType = category.categoryType?.rawValue
//        newCategory.budgetLimit = category.budgetLimit ?? 0.0
//        
//        PersistanceController.shared.saveContext()
//    }
//    
//    
//    func fetchAllCategoriesFromCoreData() -> [Category] {
//        print ("fetching list of Categories from core data")
//        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        let categoryData = (try! context.fetch(categoryRequest))
//        
//        let categoryMapping = categoryData.map {
//            Category(
//                id: $0.id ?? "",
//                name: $0.name ?? "",
//                color: $0.color ?? "",
//                icon: $0.icon ?? "",
//                categoryType: CategoryType(rawValue:$0.categoryType  ?? "") ?? .other,
//                budgetLimit: $0.budgetLimit
//            )
//        }
//        
//        print(categoryMapping)
//        
//        return categoryMapping
//    }
//    
//    func fetchCategoryFromCoreDataWithId(id: String) -> Category? {
//        print("Fetching category with id: \(id)")
//        
//        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        categoryRequest.predicate = NSPredicate(format: "id == %@", id)
//        categoryRequest.fetchLimit = 1
//>>>>>>> Stashed changes
//
//        do {
//            let entities = try context.fetch(request)
//            self.categories = entities.map { entity in
//                Category(
//                    id: entity.id ?? UUID().uuidString,
//                    name: entity.name ?? "",
//                    color: entity.color ?? "",
//                    icon: entity.icon ?? "",
//                    categoryType: CategoryType(rawValue: entity.categoryType ?? "") ?? .other,
//                    budgetLimit: entity.budgetLimit
//                )
//            }
//        } catch {
//            print("⚠️ Failed to fetch categories: \(error.localizedDescription)")
//        }
//    }
//
//    // MARK: - Add New Category
//    func addCategory(_ category: Category) {
//        let newEntity = CategoryEntity(context: context)
//        newEntity.id = category.id
//        newEntity.name = category.name
//        newEntity.color = category.color
//        newEntity.icon = category.icon
//        newEntity.categoryType = category.categoryType.rawValue
//        newEntity.budgetLimit = category.budgetLimit
//
//        PersistanceController.shared.saveContext()
//        loadCategories()
//        print("✅ Category added successfully")
//    }
//
//    // MARK: - Update Existing Category
//    func updateCategory(_ category: Category) {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", category.id)
//
//        do {
//            if let entity = try context.fetch(request).first {
//                entity.name = category.name
//                entity.color = category.color
//                entity.icon = category.icon
//                entity.categoryType = category.categoryType.rawValue
//                entity.budgetLimit = category.budgetLimit
//
//                PersistanceController.shared.saveContext()
//                loadCategories()
//                print("✅ Category updated successfully")
//            }
//        } catch {
//            print("⚠️ Failed to update category: \(error.localizedDescription)")
//        }
//    }
//
//    // MARK: - Delete Category by ID
//    func deleteCategory(withId id: String) {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//
//        do {
//            if let entity = try context.fetch(request).first {
//                context.delete(entity)
//                PersistanceController.shared.saveContext()
//                loadCategories()
//                print("🗑️ Category deleted successfully")
//            }
//        } catch {
//            print("⚠️ Failed to delete category: \(error.localizedDescription)")
//        }
//    }
//
//    // MARK: - Delete All Categories
//    func deleteAllCategories() {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//            PersistanceController.shared.saveContext()
//            loadCategories()
//            print("🧹 All categories deleted successfully")
//        } catch {
//            print("⚠️ Failed to delete all categories: \(error.localizedDescription)")
//        }
//    }
//    
//
//    // MARK: - Fetch Single Category by ID
//    func getCategory(byId id: String) -> Category? {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//
//        do {
//            if let result = try context.fetch(request).first {
//                return Category(
//                    id: result.id ?? "",
//                    name: result.name ?? "",
//                    color: result.color ?? "",
//                    icon: result.icon ?? "",
//                    categoryType: CategoryType(rawValue: result.categoryType ?? "") ?? .other,
//                    budgetLimit: result.budgetLimit
//                )
//            }
//        } catch {
//            print("⚠️ Failed to fetch category by ID: \(error.localizedDescription)")
//        }
//        return nil
//    }
//<<<<<<< Updated upstream
//    func fetchCategoryFromCoreDataWithId(id: String) -> Category? {
//        // Create a fetch request for CategoryEntity from Core Data
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//=======
//
//    func saveEditedCategory(category: Category) {
//        // Fetch the Core Data object directly
//        let categoryRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        categoryRequest.predicate = NSPredicate(format: "id == %@", category.id ?? "")
//
//        do {
//            if let existingCategoryEntity = try context.fetch(categoryRequest).first {
//                // Update the Core Data object
//                existingCategoryEntity.name = category.name
//                existingCategoryEntity.icon = category.icon
//                existingCategoryEntity.color = category.color
//                existingCategoryEntity.categoryType = category.categoryType?.rawValue
//                existingCategoryEntity.budgetLimit = category.budgetLimit ?? 0.0
//
//                // Save the context
//                PersistanceController.shared.saveContext()
//                print("Category updated successfully.")
//            } else {
//                print("No category found with id: \(String(describing: category.id))")
//            }
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//    
//    
//    func deleteAll() {
//        let newsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: newsRequest)
//>>>>>>> Stashed changes
//        
//        // Add a filter to search by the category's ID
//        request.predicate = NSPredicate(format: "id == %@", id)
//
//        do {
//            // Fetch the objects that match the provided ID
//            if let result = try context.fetch(request).first {
//                // Convert the fetched data into a Category model
//                return Category(
//                    id: result.id ?? "",
//                    name: result.name ?? "",
//                    color: result.color ?? "",
//                    icon: result.icon ?? "",
//                    categoryType: CategoryType(rawValue: result.categoryType ?? "") ?? .other,
//                    budgetLimit: result.budgetLimit
//                )
//            }
//        } catch {
//            print("⚠️ Failed to fetch category by ID: \(error.localizedDescription)")
//        }
//
//        // Return nil if no matching category was found
//        return nil
//    }
//
//    
//    // MARK: - Save Edited Category
//    func saveEditedCategory(category: Category) {
//        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", category.id)
//
//        do {
//            if let entity = try context.fetch(request).first {
//                entity.name = category.name
//                entity.color = category.color
//                entity.icon = category.icon
//                entity.categoryType = category.categoryType.rawValue
//                entity.budgetLimit = category.budgetLimit
//
//                PersistanceController.shared.saveContext()
//                loadCategories()
//                print("✅ Category updated successfully")
//            }
//        } catch {
//            print("⚠️ Failed to update category: \(error.localizedDescription)")
//        }
//    }
//
//
//    // MARK: - Filtered Categories (for UI) 
//    var filteredCategories: [Category] {
//        var filtered = categories
//
//        if !searchText.isEmpty {
//            filtered = filtered.filter {
//                $0.name.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//
//        if let type = selectedType {
//            filtered = filtered.filter {
//                $0.categoryType == type
//            }
//        }
//
//        return filtered
//    }
//}
