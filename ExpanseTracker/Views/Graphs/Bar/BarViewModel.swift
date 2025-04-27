//
//  BarViewModel.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 22/04/2025.
//

import SwiftUI
import CoreData


/// ViewModel for preparing bar chart data by combining and filtering
/// transactions according to the selected date range and category.
class BarViewModel: ObservableObject {
    
    // Core Data context for fetching user and transactions
    private let context = PersistanceController.shared.context
    
    
    // MARK: - Matching Helpers
        
    /// Finds the index of a transaction in `theArray` that shares the same
    /// month & category (or category type) as `theItem`.
    /// - Parameters:
    ///   - theArray: Already combined transactions to search within
    ///   - theItem: New transaction to match against
    ///   - allSelected: If true, match by main category type; otherwise by unique category ID
    /// - Returns: Index of a matching transaction if found; otherwise `nil`
    func itemMonthAndCategoryInArray(theArray: [Transaction], theItem: Transaction, allSelected: Bool) -> Int? {
        
        let cal = Calendar.current
        for (i, item) in theArray.enumerated() {
            
            
            if allSelected {
                // Match by main category type
                if cal.component(.month, from: item.date ?? Date()) == cal.component(.month, from: theItem.date ?? Date()) && item.category?.categoryType == theItem.category?.categoryType {
                    
                    return i
                }
            } else {
                // Match by unique category ID
                if cal.component(.month, from: item.date ?? Date()) == cal.component(.month, from: theItem.date ?? Date()) && item.category?.id == theItem.category?.id {
                    
                    return i
                }
            }
        }
        return nil
    }
    
    
    /// Finds the index of a transaction in `theArray` that shares the same
    /// day & category (or category type) as `theItem`.
    /// - See `itemMonthAndCategoryInArray` for parameter behavior.
    func itemDayAndCategoryInArray(theArray: [Transaction], theItem: Transaction, allSelected: Bool) -> Int? {
        
        let cal = Calendar.current
        for (i, item) in theArray.enumerated() {
            
            if allSelected {
                if cal.component(.day, from: item.date ?? Date()) == cal.component(.day, from: theItem.date ?? Date()) && item.category?.categoryType == theItem.category?.categoryType {
                    
                    return i
                }
            } else {
                if cal.component(.day, from: item.date ?? Date()) == cal.component(.day, from: theItem.date ?? Date()) && item.category?.id == theItem.category?.id {
                    
                    return i
                }
            }
        }
        return nil
    }
    
    
    // MARK: - Category Filtering

    /// Filters an array of transactions down to expenses of a specific
    /// main category type (or all expenses if `nil`).
    func getType(array: [Transaction], selectedType: CategoryType?) -> [Transaction] {
        switch selectedType {
        case .essential?:
            return array.filter { $0.category?.categoryType == .essential && $0.transactionType == .expense}
        case .entertainment?:
            return array.filter { $0.category?.categoryType == .entertainment && $0.transactionType == .expense}
        case .emergency?:
            return array.filter { $0.category?.categoryType == .emergency && $0.transactionType == .expense}
        case .other?:
            return array.filter { $0.category?.categoryType == .other && $0.transactionType == .expense}
        default:
            // All expenses
            return array.filter { $0.transactionType == .expense}
        }
    }
    
    
    // MARK: - Combining Transactions
        
    /// Combines transactions that fall in the same month & category (or type),
    /// summing their amounts.
    func combineSameMonthsAndCategory(_ data: [Transaction], allSelected: Bool) -> [Transaction] {
        var myFilteredArray = [Transaction] ()
        for transaction in data {
            if let index = itemMonthAndCategoryInArray(theArray: myFilteredArray, theItem: transaction, allSelected: allSelected) {
            
                // Aggregate amount if match found
                var newItem = myFilteredArray[index]
                
                newItem.amount! += transaction.amount ?? 0.0
                
                myFilteredArray[index] = newItem
            } else {    // new one
                myFilteredArray.append(transaction)
            }
        }
        return myFilteredArray
    }
    
    /// Combines transactions that fall on the same day & category (or type).
    func combineSameDayAndCategory(_ data: [Transaction], allSelected: Bool) -> [Transaction] {
        var myFilArray = [Transaction] ()
        for transaction in data {
            if let index = itemDayAndCategoryInArray(theArray: myFilArray, theItem: transaction, allSelected: allSelected) {    // Already exist
                
                var newItem = myFilArray[index]
                
                newItem.amount! += transaction.amount ?? 0.0
                
                myFilArray[index] = newItem
            } else {    // new one
                myFilArray.append(transaction)
            }
        }
        return myFilArray
    }
    
    // MARK: - Color Mapping
        
    /// Returns a hex color string for each main category type.
    func getColor(transactionType: Transaction) -> String {
        switch  transactionType.category?.categoryType{
        case .essential:
            return "#7ead9d"
        case .emergency:
            return "#db8d8e"
        case .entertainment:
            return "#ebc17d"
        case .other:
            return "#d1d1d1"
        case .none:
            return "#CCCCCC"
        }
    }
    
    
    // MARK: - Final Bar Model Creation
        
    /// Builds the array of `Bar` models for chart rendering, formatting
    /// the x-axis labels based on `selectedTab`.
    func getFinalArray(_ allSelect: Bool, data: [Transaction], selectedTab: DateTab) -> [Bar] {
        var test : [Bar] = []
        
        let formatter = DateFormatter()
        
        // Use month abbreviation for yearly or day+month for monthly
        formatter.dateFormat = (selectedTab == .yearly) ? "MMM" : "d MMM"
        
        if allSelect == true {
            for transaction in data {
                let label = formatter.string(from: transaction.date ?? Date())
                let catColor = getColor(transactionType: transaction)
                test.append(Bar(text: label, color: catColor, number: transaction.amount ?? 0.0))
            }
            return test
        } else {
            for transaction in data {
                let label = formatter.string(from: transaction.date ?? Date())
                test.append(Bar(text: label, color: transaction.category?.color ?? "", number: transaction.amount ?? 0.0))
            }
            return test
        }
    }
    
    
    // MARK: - Public Data Fetch
        
    /// Fetches, filters, combines, and formats transaction data for the bar chart.
    func getData(
        allSelect: Bool,
        selectedTab: DateTab,
        selectedType: CategoryType?,
        selectedMonth: Int,
        selectedYear: Int,
        userId: String) -> [Bar] {
            
            let cal = Calendar.current
            
            // 1. Fetch & filter by category type
            let catData = getType(array: getUserTransactions(userId: userId), selectedType: selectedType)
            
            // 2. Filter by date range
            if DateTab.yearly == selectedTab {
                let data = catData.filter {
                    cal.component(.year, from: $0.date ?? Date()) == selectedYear
                }
                
                // 3. Combine by month & category
                let sameMonthAndCategoryData = combineSameMonthsAndCategory(data, allSelected: allSelect)
                
                // 4. Format into Bar models
                let test = getFinalArray(allSelect, data: sameMonthAndCategoryData, selectedTab: selectedTab)
                
                return test
                
            } else {
                let data = catData.filter {
                    $0.transactionType == .expense && cal.component(.month, from: $0.date ?? Date()) == selectedMonth + 1 && cal.component(.year, from: $0.date ?? Date()) == selectedYear
                }
                
                // 3. Combine by day & category
                let sameDayAndCategoryData = combineSameDayAndCategory(data, allSelected: allSelect)
                
                // 4. Format into Bar models
                let test = getFinalArray(allSelect, data: sameDayAndCategoryData, selectedTab: selectedTab)
                
                return test
            }
        }
    
    // MARK: - Core Data Fetch
        
    /// Retrieves all transactions for the specified user from Core Data.
    func getUserTransactions(userId: String) -> [Transaction] {
 
        let transaction = [] as [Transaction]
        // Fetch user
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        do {
            if let user = try context.fetch(userRequest).first,
               let transactions = user.transaction?.allObjects as? [TransacionsEntity] {

                return transactions.map {
                    Transaction(
                        id: $0.id ?? UUID().uuidString,
                        title: $0.title ?? "",
                        description: $0.desc,
                        amount: $0.amount,
                        date: formatter.date(from: $0.date ?? ""),
                        transactionType: TransactionType(rawValue: $0.transactionType ?? ""),
                        category: $0.category.map{ Category(from: $0) },
                        receiptImage: $0.image ?? ""
                    )
                }
            }
        } catch {
            print("Error fetching user: \(error)")
        }
        return transaction
    }
    
}


/// Model representing a single bar in the chart.
struct Bar: Identifiable {
    let id = UUID()
    let text: String        // X-axis label (date or month)
    let color: String       // Hex color for the bar
    let number: Double      // Y-axis value (amount)
    let categoryID: String? // Optional subcategory ID for filtering/highlighting
    
    init(text: String, color: String, number: Double, categoryID: String? = nil) {
        self.text = text
        self.color = color
        self.number = number
        self.categoryID = categoryID
    }
}

