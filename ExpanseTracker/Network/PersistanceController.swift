//
//  PersistanceController.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 15/10/1446 AH.
//


import CoreData

final class PersistanceController {
    static let shared = PersistanceController()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "ExpensesAppModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            }catch {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }
}
