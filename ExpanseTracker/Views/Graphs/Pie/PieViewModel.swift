//
//  PieViewModel.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 15/04/2025.
//

import SwiftUI
import CoreData

class PieViewModel: ObservableObject {
    
    private let context = PersistanceController.shared.context
    
    //MARK: - Check Same ID
    //function to pass that filtered array and compare id number
    func itemIdInArray(theArray: [Transaction], theItem: Transaction) -> Int? {
        
        for (i, item) in theArray.enumerated() {
            
            if item.category?.id == theItem.category?.id {
                
                return i
            }
        }
        return nil
    }
    
    //MARK: - Check Same Category
    // function to check is the same four main category are repeated in the array
    func itemCatNameInArray(theArray: [Transaction], theItem: Transaction) -> Int? {
        
        for (i, item) in theArray.enumerated() {
            
            if item.category?.categoryType == theItem.category?.categoryType {
                
                return i
            }
        }
        return nil
    }
    
    
    //MARK: - Get The Four Main Types or All
    // this will give all the expenses elements in the array based on the category type
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
    
    
    //MARK: - Combine Items In The Array
    // this function will combine similer array elements based on category id
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
    
    // this function will combine similer array element based on the main categories
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
    
    
    //MARK: - get category name (Main or sub categories)
    func getFinalArray(_ allSelect: Bool, filtData: [Transaction], filteredData: [Transaction]) -> [Test] {
        var test : [Test] = []
        if allSelect == true {
            let totalAmount = filtData.reduce(0) { $0 + ($1.amount ?? 0.0)}
            for transaction in filtData {
                let catColor = getColor(transactionType: transaction)
                test.append(Test(text: (transaction.category?.categoryType?.rawValue ?? ""), color: catColor, number: transaction.amount ?? 0.0, percentage: (transaction.amount ?? 0.0) / totalAmount * 100))
            }
            return test
        } else {
            let totalAmount = filteredData.reduce(0) { $0 + ($1.amount ?? 0.0)}
            for transaction in filteredData {
                test.append(Test(text: transaction.category?.name ?? "", color: transaction.category?.color ?? "", number: transaction.amount ?? 0.0, percentage: (transaction.amount ?? 0.0) / totalAmount * 100))
            }
            return test
        }
    }
    
    //MARK: - get Data for All Filters
    func getData(
        allSelect: Bool,
        selectedTab: DateTab,
        selectedType: CategoryType?,
        selectedMonth: Int,
        selectedYear: Int,
        userId: String) -> [Test] {
            let cal = Calendar.current

            let catData = getType(array: getUserTransactions(userId: userId), selectedType: selectedType)

            if DateTab.yearly == selectedTab {
                let data = catData.filter {
                    $0.transactionType == .expense && cal.component(.year, from: $0.date ?? Date()) == selectedYear
                }
                
                let filteredData = combineSameCategory(data)
                let filtData = combineSameType(filteredData)
                
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


//MARK: - Charts Return Arcitechture
struct Test: Identifiable, ShapeStyle {
    let text: String
    let color: String
    let number: Double
    let percentage: Double
    
    let id = UUID()
    
    init(text: String, color: String, number: Double, percentage: Double) {
        self.text = text
        self.color = color
        self.number = number
        self.percentage = percentage
    }
    
}

