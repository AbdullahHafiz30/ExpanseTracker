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
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        // Create calendar instance
        let calendar = Calendar.current
        
        // Create a date formatter to convert string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        do {
            // Fetch the first user that matches the predicate
            if let existingUserEntity = try context.fetch(userRequest).first {
                // Convert the budget start date from String to Date then get the first day of the month
                if let startDateString = budget.startDate,
                   let originalStartDate = dateFormatter.date(from: startDateString),
                   let startDate = getFirstDayOfMonth(from: originalStartDate) {
                    
                    // Convert the start date back to String
                    let startDateString = dateFormatter.string(from: startDate)
                    
                    // Find the last day of the month from startDate
                    let range = calendar.range(of: .day, in: .month, for: startDate) // Get the number of days in the start date month
                    let lastDay = range?.count ?? 0 // Get the last day number of the month
                    let lastDateOfMonth = calendar.date(bySetting: .day, value: lastDay, of: startDate) // Get the last day of the month

                    // Convert lastDateOfMonth to string
                    let endDateString = dateFormatter.string(from: lastDateOfMonth ?? startDate)
                    
                    // Extract month and year from startDate
                    let budgetMonth = calendar.component(.month, from: startDate)
                    let budgetYear = calendar.component(.year, from: startDate)
                    
                    // Get all budgets linked to the user
                    let existingBudgets = existingUserEntity.budget?.allObjects as? [BudgetEntity] ?? []
                    
                    // Loop list of budgets to check if a budget for the current month already exists
                    if let existingBudget = existingBudgets.first(where: {
                        guard let date = $0.startDate else { return false } // If there is no start Date ignore it

                        if let budgetStartDate = dateFormatter.date(from: date) { // Convert start date to Date object
                            let month = calendar.component(.month, from: budgetStartDate)
                            // Get the month of this budget
                            let year = calendar.component(.year, from: budgetStartDate)
                            // Get the year of this budget
                            return month == budgetMonth && year == budgetYear
                            // Check if the budget matches the same month and year (if true update this budget)
                        }
                        return false // Continue
                    }) {
                        // Update existing budget if there is a matching budget for the same month and year
                        existingBudget.amount = budget.amount ?? 0
                        existingBudget.startDate = startDateString
                        existingBudget.endDate = endDateString // Use the calculated last day of the month
                        print("Updated existing budget for current month.")
                        PersistanceController.shared.saveContext()
                        if repeated {
                            let allBudgets = existingUserEntity.budget?.allObjects as? [BudgetEntity] ?? []
                            // Get all budgets for the user
                            updateFutureBudgets(baseBudget: existingBudget, allBudgets: allBudgets, newBudgetData: budget)
                            // Update future budgets based on the new data
                        }
                    } else {
                        // No existing budget found for the current month, create a new one
                        let newBudget = BudgetEntity(context: context) // Create a new BudgetEntity in Core Data
                        newBudget.id = UUID().uuidString
                        newBudget.amount = budget.amount ?? 0
                        newBudget.startDate = startDateString
                        newBudget.endDate = endDateString // Use the calculated last day of the month
                        
                        existingUserEntity.addToBudget(newBudget)
                        print("Added new budget for the user.")
                        
                        // Save context
                        PersistanceController.shared.saveContext()
                        // Generate repeated budgets for future months (6 months)
                        repeatBudgetForUpcomingMonths(currentBudget: newBudget, forUser: existingUserEntity)
                        
                    }
                }
            } else {
                print("No user found with id: \(userId)")
            }
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    
    func repeatBudgetForUpcomingMonths(currentBudget: BudgetEntity, forUser user: UserEntity) {
        // Create calendar instance
        let calendar = Calendar.current
        // Get the current start and end dates from the provided budget
        var currentStartDate = currentBudget.startDate
        var currentEndDate = currentBudget.endDate
        
        // Create a date formatter to convert string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Loop to create 6 future monthly budgets
        for _ in 1...6 {
            // Check if start and end dates is valid
            if let startDate = currentStartDate, let endDate = currentEndDate {
                // Add 1 month to the current start date
                let newStartDate = calendar.date(byAdding: .month, value: 1, to: dateFormatter.date(from: startDate)!)
                // Add 1 month to the current end date
                let newEndDate = calendar.date(byAdding: .month, value: 1, to: dateFormatter.date(from: endDate)!)
                
                // Create a new BudgetEntity object
                let repeatedBudget = BudgetEntity(context: context)
                repeatedBudget.id = UUID().uuidString
                repeatedBudget.amount = currentBudget.amount
                repeatedBudget.startDate = dateFormatter.string(from: newStartDate!)
                repeatedBudget.endDate = dateFormatter.string(from: newEndDate!)
                
                // Add budget to user
                user.addToBudget(repeatedBudget)
                PersistanceController.shared.saveContext()
                
                // Update the currentStartDate and currentEndDate
                currentStartDate = dateFormatter.string(from: newStartDate!)
                currentEndDate = dateFormatter.string(from: newEndDate!)
            }
        }
    }
    
    func updateFutureBudgets(baseBudget: BudgetEntity, allBudgets: [BudgetEntity], newBudgetData: Budget) {
        // Create calendar instance
        let calendar = Calendar.current
        
        // Check if baseBudget has a valid start date
        guard let baseStartDateString = baseBudget.startDate else { return }
        
        // Create a date formatter to convert string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        // Convert baseBudget start date to Date object
        guard let startDate = dateFormatter.date(from: baseStartDateString) else {
            print("Failed to convert baseStartDate to Date.")
            return
        }
        
        // Get the start of the day for baseBudget start date
        let baseStartDate = calendar.startOfDay(for: startDate)
        
        // Loop through all the budgets
        for budget in allBudgets {
            // Check if start date is valid
            if let startDateString = budget.startDate {
                
                // Convert start date to Date object
                guard let startDate = dateFormatter.date(from: startDateString) else {
                    print("Failed to convert startDate to Date.")
                    continue
                }
                
                // Get the start of the day for this budget date
                let budgetStartDate = calendar.startOfDay(for: startDate)
            
                // Check if the budget is in the future
                if budgetStartDate > baseStartDate {
                    // Update the budget amount
                    budget.amount = newBudgetData.amount ?? 0
                }
            }
        }
        
        // Save changes to Core Data
        PersistanceController.shared.saveContext()
        print("Future repeated budgets updated.")
    }
    
    func fetchCurrentMonthBudget(userId: String) -> BudgetEntity? {
        print("Fetching current month budget")
        
        // Create calendar instance
        let calendar = Calendar.current
        // Create a date formatter to convert string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var hasNextMonthBudget = false
        
        // Get current date, month, and year
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        // Calculate next month and year
        var nextMonth = currentMonth + 1
        var nextYear = currentYear
        // check if the next month is greater then 12 then the next month will be 1 and we add 1 year
        if nextMonth > 12 {
            nextMonth = 1
            nextYear += 1
        }
        
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        do {
            // Fetch the first user that matches the predicate
            if let user = try context.fetch(userRequest).first,
               let budgets = user.budget?.allObjects as? [BudgetEntity] { // fetch all user budgets
                
                var currentMonthBudget: BudgetEntity?
                var mostRecentPastBudget: BudgetEntity?
                var mostRecentPastDate: Date?
                
                // Loop through budgets to find current, next, and most recent past budget
                for budget in budgets {
                    // Check if start date is valid and Convert start date to Date object
                    guard let startDateStr = budget.startDate,
                          let startDate = dateFormatter.date(from: startDateStr) else {
                        continue
                    }
                    
                    // Get the month from the budget start date
                    let budgetMonth = calendar.component(.month, from: startDate)
                    // Get the year from the budget start date
                    let budgetYear = calendar.component(.year, from: startDate)
                    
                    // Check if this budget is for the current month
                    if budgetMonth == currentMonth && budgetYear == currentYear {
                        currentMonthBudget = budget
                    }
                    
                    // Check if there is a budget for next month
                    if budgetMonth == nextMonth && budgetYear == nextYear {
                        hasNextMonthBudget = true
                    }
                    
                    // Check if the budget is from a past date
                    if startDate < now {
                        // Check if mostRecentPastDate is nil or if startDate is greater than mostRecentPastDate
                        if mostRecentPastDate == nil || startDate > mostRecentPastDate! { // If ttue set the current budget as the most recent past budget
                            mostRecentPastBudget = budget
                            mostRecentPastDate = startDate
                        }
                    }
                }
                
                // If no budget exists for this month
                if currentMonthBudget == nil {
                    // If a past budget exists repeat it
                    if let lastBudget = mostRecentPastBudget {
                        print("No budget found for current month. Creating one from last available budget.")
                        repeatBudgetForUpcomingMonths(currentBudget: lastBudget, forUser: user)
                        
                        // Refetch the current month budget again after repeating
                        return fetchCurrentMonthBudget(userId: userId)
                        
                    } else {
                        print("No past budgets found to copy from.")
                        return nil
                    }
                }
                
                // If current month has budget but next month doesn't have then generate budgets for upcoming months
                if currentMonthBudget != nil && !hasNextMonthBudget {
                    print("Next month's budget not found. Repeate")
                    repeatBudgetForUpcomingMonths(currentBudget: currentMonthBudget!, forUser: user)
                }
                
                return currentMonthBudget
            }
        } catch {
            print("Error fetching budget: \(error)")
        }
        
        return nil
    }
    
    func deleteAll(userId: String) {
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
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
        // Create calendar instance
        let calendar = Calendar.current
        // Get current month, and year
        let components = calendar.dateComponents([.year, .month], from: date)
        // Set the day component to the first day of the month
        return calendar.date(from: components)
    }
    
}
