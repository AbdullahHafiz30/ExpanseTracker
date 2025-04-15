//
//  BudgetViewModel.swift
//  ExpanseTracker
//
//  Created by Rayaheen Mseri on 17/10/1446 AH.
//

import SwiftUI
import CoreData
import Combine

class BudgetViewModel: ObservableObject {
    private let context = PersistanceController.shared.context
 
    func saveBudgetToCoreData(budget: Budget, userId: String, repeated: Bool) {
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        do {
            if let existingUserEntity = try context.fetch(userRequest).first {
                // Convert start_date string to Date
                if let startDateString = budget.startDate,
                   let originalStartDate = dateFormatter.date(from: startDateString),
                   let startDate = getFirstDayOfMonth(from: originalStartDate) {
                    
                    let startDateString = dateFormatter.string(from: startDate)

                    // Find the last day of the month from startDate
                    let range = calendar.range(of: .day, in: .month, for: startDate)
                    let lastDay = range?.count ?? 0
                    let lastDateOfMonth = calendar.date(bySetting: .day, value: lastDay, of: startDate)

                    // Convert lastDateOfMonth to string
                    let endDateString = dateFormatter.string(from: lastDateOfMonth ?? startDate)

                    // Extract month and year from startDate
                    let budgetMonth = calendar.component(.month, from: startDate)
                    let budgetYear = calendar.component(.year, from: startDate)

                    // Check if a budget for the current month already exists
                    let existingBudgets = existingUserEntity.budget?.allObjects as? [BudgetEntity] ?? []
                    
                    if let existingBudget = existingBudgets.first(where: {
                        guard let date = $0.startDate else { return false }
                        if let budgetStartDate = dateFormatter.date(from: date) {
                            let month = calendar.component(.month, from: budgetStartDate)
                            let year = calendar.component(.year, from: budgetStartDate)
                            return month == budgetMonth && year == budgetYear
                        }
                        return false
                    }) {
                        // Update existing budget
                        existingBudget.amount = budget.amount ?? 0
                        existingBudget.startDate = startDateString
                        existingBudget.endDate = endDateString // Use the calculated last day of the month
                        print("Updated existing budget for current month.")
                        PersistanceController.shared.saveContext()
                        if repeated {
                            let allBudgets = existingUserEntity.budget?.allObjects as? [BudgetEntity] ?? []
                               updateFutureBudgets(from: existingBudget, in: allBudgets, with: budget)
                        }
                    } else {
                        // No existing budget, create a new one
                        let newBudget = BudgetEntity(context: context)
                        newBudget.id = UUID().uuidString
                        newBudget.amount = budget.amount ?? 0
                        newBudget.startDate = startDateString
                        newBudget.endDate = endDateString // Use the calculated last day of the month
                        
                        existingUserEntity.addToBudget(newBudget)
                        print("Added new budget for the user.")

                        // Save context
                        PersistanceController.shared.saveContext()
                            repeatBudgetForUpcomingMonths(currentBudget: newBudget, forUser: existingUserEntity, context: context)
                        
                    }
                }
            } else {
                print("No user found with id: \(userId)")
            }
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    
    func repeatBudgetForUpcomingMonths(currentBudget: BudgetEntity, forUser user: UserEntity, context: NSManagedObjectContext) {
        let calendar = Calendar.current
        var currentStartDate = currentBudget.startDate
        var currentEndDate = currentBudget.endDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for _ in 1...6 {
            if let startDate = currentStartDate, let endDate = currentEndDate {
                let newStartDate = calendar.date(byAdding: .month, value: 1, to: dateFormatter.date(from: startDate)!)
                let newEndDate = calendar.date(byAdding: .month, value: 1, to: dateFormatter.date(from: endDate)!)
                
                let repeatedBudget = BudgetEntity(context: context)
                repeatedBudget.id = UUID().uuidString
                repeatedBudget.amount = currentBudget.amount
                repeatedBudget.startDate = dateFormatter.string(from: newStartDate!)
                repeatedBudget.endDate = dateFormatter.string(from: newEndDate!)
                
                user.addToBudget(repeatedBudget)
                PersistanceController.shared.saveContext()
                currentStartDate = dateFormatter.string(from: newStartDate!)
                currentEndDate = dateFormatter.string(from: newEndDate!)
            }
        }
    }
    
    func updateFutureBudgets(from baseBudget: BudgetEntity, in allBudgets: [BudgetEntity], with newBudgetData: Budget) {
        let calendar = Calendar.current
        guard let baseStartDateString = baseBudget.startDate else { return }
        
        // Create a DateFormatter to convert the string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Convert baseStartDateString to a Date object
        guard let baseStartDate = dateFormatter.date(from: baseStartDateString) else {
            print("Failed to convert baseStartDate to Date.")
            return
        }
        
        // Normalize baseStartDate by setting the time to midnight
        let baseStartDateMidnight = calendar.startOfDay(for: baseStartDate)
        
        for budget in allBudgets {
            if let startDateString = budget.startDate {
                // Convert startDateString to a Date object
                guard let startDate = dateFormatter.date(from: startDateString) else {
                    print("Failed to convert startDate to Date.")
                    continue
                }
                
                // Normalize startDate of each budget by setting the time to midnight
                let budgetStartDateMidnight = calendar.startOfDay(for: startDate)
                
                // Compare the dates, ignoring time
                if budgetStartDateMidnight > baseStartDateMidnight {
                    // Update the amount of future budgets
                    budget.amount = newBudgetData.amount ?? 0
                }
            }
        }
        
        // Save changes to Core Data
        PersistanceController.shared.saveContext()
        print("Future repeated budgets updated.")
    }

    func fetchCurrentMonthBudget(userId: String) -> BudgetEntity? {
        print("fetching current month budget")
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)

        do {
            if let user = try context.fetch(userRequest).first,
               let budgets = user.budget?.allObjects as? [BudgetEntity] {

                for budget in budgets {
                    guard let startDateStr = budget.startDate,
                          let startDate = dateFormatter.date(from: startDateStr) else {
                        continue
                    }

                    let budgetMonth = calendar.component(.month, from: startDate)
                    let budgetYear = calendar.component(.year, from: startDate)

                    if budgetMonth == currentMonth && budgetYear == currentYear {
                        return budget
                    }
                }
            }
        } catch {
            print("Error fetching budget: \(error)")
        }

        return nil
    }

    func deleteAll(userId: String) {
        let context = PersistanceController.shared.container.viewContext
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        do {
            if let existingUserEntity = try context.fetch(userRequest).first {
                if let budgets = existingUserEntity.budget as? Set<BudgetEntity> {
                    for budget in budgets {
                        context.delete(budget)
                    }
                    PersistanceController.shared.saveContext()
                    print("All budget deleted successfully.")
                }
            }
        }catch {
            print("Delete Error \(error)")
        }
    }
    
    func getFirstDayOfMonth(from date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)
    }

}
