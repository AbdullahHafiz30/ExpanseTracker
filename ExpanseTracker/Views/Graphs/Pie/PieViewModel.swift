//
//  PieViewModel.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import CoreData


/// ViewModel responsible for loading, filtering, combining, and transforming
/// transaction data into slice-ready `Test` models for the pie chart.
class PieViewModel: ObservableObject {
    
    // Core Data context for performing fetches and updates
    private let context = PersistanceController.shared.context
    
    // MARK: - ID & Category Matching Helpers
    
    /// Finds the index of a transaction in `theArray` matching by category ID.
    /// - Parameters:
    ///   - theArray: Array of aggregated `Transaction` objects
    ///   - theItem: A single `Transaction` to search for
    /// - Returns: Index if found, otherwise `nil`
    func itemIdInArray(theArray: [Transaction], theItem: Transaction) -> Int? {
        
        for (i, item) in theArray.enumerated() {
            
            if item.category?.id == theItem.category?.id {
                
                return i
            }
        }
        return nil
    }
    
    /// Finds the index of a transaction in `theArray` matching by main category type.
    /// - Parameters:
    ///   - theArray: Array of aggregated `Transaction` objects
    ///   - theItem: A single `Transaction` to search for
    /// - Returns: Index if found, otherwise `nil`
    func itemCatNameInArray(theArray: [Transaction], theItem: Transaction) -> Int? {
        
        for (i, item) in theArray.enumerated() {
            
            if item.category?.categoryType == theItem.category?.categoryType {
                
                return i
            }
        }
        return nil
    }
    
    
    // MARK: - Transaction Filtering
    
    /// Filters transactions down to expenses in a specific main category (if provided).
    /// - Parameters:
    ///   - array: Original transactions
    ///   - selectedType: Optional main category filter (`nil` = all expenses)
    /// - Returns: Filtered expense-only transactions matching the category
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
            return array.filter { $0.transactionType == .expense}
        }
    }
    
    
    // MARK: - Combining Similar Transactions
    
    /// Aggregates transactions by exact category (ID), summing their amounts.
    /// - Parameter data: Transactions to combine
    /// - Returns: New array of transactions with unique category IDs
    func combineSameCategory(_ data: [Transaction]) -> [Transaction] {
        var myFilteredArray = [Transaction] ()
        for transaction in data {
            if let index = itemIdInArray(theArray: myFilteredArray, theItem: transaction) {    // Already exist
                
                var newItem = myFilteredArray[index]
                
                newItem.amount! += transaction.amount ?? 0.0
                
                myFilteredArray[index] = newItem
            } else {    // new one
                myFilteredArray.append(transaction)
            }
        }
        return myFilteredArray
    }
    
    /// Aggregates transactions by main category type, summing their amounts.
    /// - Parameter data: Transactions to combine
    /// - Returns: New array of transactions with unique main categories
    func combineSameType(_ data: [Transaction]) -> [Transaction] {
        var myFilArray = [Transaction] ()
        for transaction in data {
            if let index = itemCatNameInArray(theArray: myFilArray, theItem: transaction) {    // Already exist
                
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
    /// Maps a transaction’s main category type to a hex color string.
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
    
    
    // MARK: - Final Test Model Construction
    
    /// Builds the final array of `Test` slices for the chart, choosing between
    /// main-category breakdown or subcategory breakdown based on `allSelect`.
    /// - Parameters:
    ///   - allSelect: If true, group by main category; otherwise by subcategory
    ///   - filtData: Data aggregated by main category
    ///   - filteredData: Data aggregated by subcategory
    /// - Returns: Array of `Test` models containing slice text, color, value, and percentage
    func getFinalArray(_ allSelect: Bool, filtData: [Transaction], filteredData: [Transaction]) -> [Test] {
        var test : [Test] = []
        if allSelect == true {
            // Total expense across all main categories
            let totalAmount = filtData.reduce(0) { $0 + ($1.amount ?? 0.0)}
            for transaction in filtData {
                let catColor = getColor(transactionType: transaction)
                test.append(Test(text: (transaction.category?.categoryType?.rawValue ?? ""), color: catColor, number: transaction.amount ?? 0.0, percentage: (transaction.amount ?? 0.0) / totalAmount * 100))
            }
            return test
        } else {
            // Total expense across subcategories
            let totalAmount = filteredData.reduce(0) { $0 + ($1.amount ?? 0.0)}
            for transaction in filteredData {
                test.append(Test(text: transaction.category?.name ?? "", color: transaction.category?.color ?? "", number: transaction.amount ?? 0.0, percentage: (transaction.amount ?? 0.0) / totalAmount * 100))
            }
            return test
        }
    }
    

    // MARK: - Public Data Fetch & Filter
        
    /// Retrieves and processes transactions according to all UI filters.
    /// - Parameters:
    ///   - allSelect: Group by main categories if true
    ///   - selectedTab: Monthly vs. yearly aggregation
    ///   - selectedType: Specific main category filter
    ///   - selectedMonth: Month index (1–12)
    ///   - selectedYear: Year value
    ///   - userId: Current user identifier
    /// - Returns: Array of `Test` items ready for chart rendering
    func getData(
        allSelect: Bool,
        selectedTab: DateTab,
        selectedType: CategoryType?,
        selectedMonth: Int,
        selectedYear: Int,
        userId: String) -> [Test] {
            let cal = Calendar.current
            
            // Fetch all user transactions and apply main-category filter
            let catData = getType(array: getUserTransactions(userId: userId), selectedType: selectedType)
            
            // Filter by date range
            if DateTab.yearly == selectedTab {
                let data = catData.filter {
                    $0.transactionType == .expense && cal.component(.year, from: $0.date ?? Date()) == selectedYear
                }
                
                // First combine by exact category, then by main type
                let filteredData = combineSameCategory(data)
                let filtData = combineSameType(filteredData)
                
                // Build final Test slices
                let test = getFinalArray(allSelect, filtData: filtData, filteredData: filteredData)
                
                return test
                
            } else {
                let data = catData.filter {
                    $0.transactionType == .expense && cal.component(.month, from: $0.date ?? Date()) == selectedMonth + 1 && cal.component(.year, from: $0.date ?? Date()) == selectedYear
                }
                
                let filteredData = combineSameCategory(data)
                let filtData = combineSameType(filteredData)
                let test = getFinalArray(allSelect, filtData: filtData, filteredData: filteredData)
                
                return test
            }
        }
    
    // MARK: - Core Data Fetch
        
    /// Fetches all transactions belonging to the given user from Core Data.
    /// - Parameter userId: The user’s unique identifier
    /// - Returns: Array of `Transaction` models or empty if fetch fails
    func getUserTransactions(userId: String) -> [Transaction] {
        
        let transaction = [] as [Transaction]
        // Prepare fetch request for UserEntity matching userId
        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId)
        // Date formatter to parse stored date strings
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        do {
            if let user = try context.fetch(userRequest).first,
               let transactions = user.transaction?.allObjects as? [TransacionsEntity] {
                // Map Core Data entities to plain `Transaction` structs
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


    // MARK: - Pie Chart Slice Model

    /// Data model representing a single pie chart slice
struct Test: Identifiable, ShapeStyle {
    let text: String        // Display label (category or subcategory name)
    let color: String       // Hex string for slice color
    let number: Double      // Raw numeric value for this slice
    let percentage: Double  // Computed percentage of total
    
    let id = UUID()
    
    init(text: String, color: String, number: Double, percentage: Double) {
        self.text = text
        self.color = color
        self.number = number
        self.percentage = percentage
    }
    
}

