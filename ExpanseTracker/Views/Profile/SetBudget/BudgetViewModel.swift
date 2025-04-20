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
    
    private var budgetDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    /// Saves or updates a budget in Core Data for a given user and month.
    /// If `repeated` is true, future budgets are updated or generated accordingly.
    ///
    /// - Parameters:
    ///   - budget: The `Budget` model containing budget data (amount, startDate, etc.).
    ///   - userId: The unique identifier for the user associated with the budget.
    ///   - repeated: A boolean flag indicating whether to repeat the budget for upcoming months.
    ///
    /// This method performs the following:
    /// 1. Fetches the user from Core Data using the given `userId`.
    /// 2. Converts the `budget.startDate` (String) to a `Date`, and then finds the first day of that month.
    /// 3. Calculates the last day of the month from the start date.
    /// 4. Checks if a budget already exists for that month/year:
    ///     - If exists: updates the existing budget.
    ///     - If not: creates a new budget entry.
    /// 5. If `repeated` is true:
    ///     - Updates future budgets that were created based on repetition.
    ///     - Generates new ones if needed (e.g., for the next 6 months).
    /// 6. Saves the context after all updates or creations.
    func saveBudgetToCoreData(budget: Budget, userId: String, repeated: Bool) {
        // Create a fetch request to find the user by id
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        // Filter the results
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        // Create calendar instance
        let calendar = Calendar.current
        
        // Create a date formatter to convert string to Date
        let dateFormatter = budgetDateFormatter
        
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
    
    /// Repeats a given budget for the next 6 months by creating new budget entries in Core Data.
    ///
    /// - Parameters:
    ///   - currentBudget: The original `BudgetEntity` to use as a template for future months.
    ///   - user: The `UserEntity` to whom the new repeated budgets will be added.
    ///
    /// This method performs the following:
    /// 1. Extracts the start and end date of the current budget.
    /// 2. Converts them from `String` to `Date` using the shared `budgetDateFormatter`.
    /// 3. Iterates 6 times to:
    ///     - Add one month to both start and end date.
    ///     - Create a new `BudgetEntity` with the updated dates and same amount.
    ///     - Attach the new budget to the user.
    ///     - Save the context after each new budget creation.
    /// 4. Updates the tracking variables (`currentStartDate`, `currentEndDate`) to move forward month by month.
    func repeatBudgetForUpcomingMonths(currentBudget: BudgetEntity, forUser user: UserEntity) {
        // Create calendar instance
        let calendar = Calendar.current
        // Get the current start and end dates from the provided budget
        var currentStartDate = currentBudget.startDate
        var currentEndDate = currentBudget.endDate
        
        // Create a date formatter to convert string to Date
        let dateFormatter = budgetDateFormatter
        
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
    
    /// Updates all future repeated budget entries based on a modified base budget.
    ///
    /// - Parameters:
    ///   - baseBudget: The original `BudgetEntity` that was updated (typically for the current month).
    ///   - allBudgets: A list of all `BudgetEntity` items linked to the user.
    ///   - newBudgetData: The `Budget` model containing the new budget data (e.g., updated amount).
    ///
    /// This method performs the following:
    /// 1. Ensures the `baseBudget` has a valid `startDate`.
    /// 2. Converts `startDate` strings to `Date` objects using `budgetDateFormatter`.
    /// 3. Finds all budgets that begin **after** the `baseBudget`'s start date (future months).
    /// 4. Updates their `amount` field to match the updated budget value.
    /// 5. Saves changes to Core Data via the shared persistence controller.
    func updateFutureBudgets(baseBudget: BudgetEntity, allBudgets: [BudgetEntity], newBudgetData: Budget) {
        // Create calendar instance
        let calendar = Calendar.current
        
        // Check if baseBudget has a valid start date
        guard let baseStartDateString = baseBudget.startDate else { return }
        
        // Create a date formatter to convert string to Date
        let dateFormatter = budgetDateFormatter
        
        
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
    
    /// Fetches the current month's budget for a specific user.
    ///
    /// If the current month's budget does not exist, this function attempts to create it based on the most recent past budget.
    /// If the current month has a budget but the **next month** doesn't, it generates future budgets using the current month as a base.
    ///
    /// - Parameter userId: The unique identifier (`String`) of the user.
    /// - Returns: A `BudgetEntity?` representing the budget for the current month, or `nil` if no applicable budget is found or can be created.
    ///
    /// This method performs the following:
    /// 1. Fetch the `UserEntity` using the given `userId`.
    /// 2. Loop through all associated budgets to:
    ///     - Find the current month's budget.
    ///     - Check if the next month's budget exists.
    ///     - Identify the most recent past budget.
    /// 3. If no current budget exists, use the latest past budget to generate budgets (via `repeatBudgetForUpcomingMonths`), then refetch.
    /// 4. If current exists but next month doesn't, auto-generate budgets for future months.
    func fetchCurrentMonthBudget(userId: String) -> BudgetEntity? {
        print("Fetching current month budget")
        
        // Create calendar instance
        let calendar = Calendar.current
        // Create a date formatter to convert string to Date
        let dateFormatter = budgetDateFormatter
        
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
    
    /// Deletes all budgets associated with a specific user
    ///
    /// - Parameter userId: The unique identifier (`String`) of the user whose budgets are to be deleted
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
    
    /// Returns the first day of the month for a given date.
    ///
    /// - Parameter date: The `Date` for which to determine the first day of the month.
    ///
    /// - Returns: A `Date` object representing the first day of the same month as the provided date, or `nil` if the date is invalid.
    func getFirstDayOfMonth(from date: Date) -> Date? {
        // Create calendar instance
        let calendar = Calendar.current
        // Get current month, and year
        let components = calendar.dateComponents([.year, .month], from: date)
        // Set the day component to the first day of the month
        return calendar.date(from: components)
    }

    /// Calculates the total spending (expenses) for a user within the current month.
    ///
    /// - Parameter userId: The unique identifier of the user for whom the spending is to be calculated.
    ///
    /// - Returns: A `Double` representing the total amount of expenses for the user in the current month. Returns `0.0` if no transactions are found, or an error occurs.
    func getUserSpending(userId: String) -> Double {
        let calendar = Calendar.current

        // Get first and last day of the current month
        guard let startDate = getFirstDayOfMonth(from: Date()) else { return 0.0 }

        guard let range = calendar.range(of: .day, in: .month, for: startDate),
              let endDate = calendar.date(bySetting: .day, value: range.count, of: startDate) else {
            return 0.0
        }

        // Formate the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Fetch user
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)

        do {
            if let user = try context.fetch(userRequest).first,
               let transactions = user.transaction?.allObjects as? [TransacionsEntity] {

                // Filter the transaction (current month , .expense)
                let filteredTransactions = transactions.filter { transaction in
                    guard let type = transaction.transactionType?.lowercased(),
                          let dateString = transaction.date,
                          let transactionDate = dateFormatter.date(from: dateString) else {
                        return false
                    }

                    return type == "expense" && transactionDate >= startDate && transactionDate <= endDate
                }

                // Sum the Total user spend using reduce
                let total = filteredTransactions.reduce(0.0) { $0 + Double($1.amount) }
                print("Total expense for user \(userId): \(total)")
                return total
            }
        } catch {
            print("Error fetching user: \(error)")
        }

        return 0.0
    }
    
    /// Validates the input string to ensure it is a valid number.
    ///
    /// - Parameter text: The input string representing the budget amount.
    ///
    /// - Returns: A string containing an error message if the input is not a valid number, or `nil` if the input is valid.
    func validateAmount(text: String) -> String?{
        var budgetError: String?
        if isValidNumber(text: text) {
            budgetError = nil
        } else {
            budgetError = "Budget must be a number only."
        }
        
        return budgetError
    }
    
    /// Checks if the input string is a valid number consisting only of digits.
    ///
    /// - Parameter text: The input string to be validated.
    ///
    /// - Returns: A Boolean value indicating whether the input string contains only digits.
    func isValidNumber(text: String) -> Bool {
        let numberPattern = "^[0-9]+$"
        return text.range(of: numberPattern, options: .regularExpression) != nil
    }
    
    /// Creates a new budget for the user with an optional repetition for future periods.
    ///
    /// - Parameters:
    ///   - repeated: A Boolean value indicating whether the budget is a repeated budget for the upcoming periods.
    ///   - userId: The unique identifier of the user for whom the budget is being created.
    ///   - budget: The amount of the budget, represented as a string, which will be converted to a `Double` for processing.
    func createBudget(repeated: Bool , userId: String, budget: String){
        let dateFormatter = budgetDateFormatter
        // Create new budget object
        let newBudget = Budget(
            id: UUID().uuidString,
            amount: Double(budget),
            startDate: dateFormatter.string(from: Date()),
            endDate: dateFormatter.string(from: Date().addingTimeInterval(30 * 24 * 60 * 60)))
        
        saveBudgetToCoreData(budget: newBudget, userId: userId, repeated: repeated)
    }
}
