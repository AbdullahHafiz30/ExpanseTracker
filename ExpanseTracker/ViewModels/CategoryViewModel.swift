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

    func fetchCategoryFromCoreDataWithId(id: String) -> Category? {
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
}
