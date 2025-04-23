//
//  BarViewModel.swift
//  ExpanseTracker
//
//  Created by Abdullah Hafiz on 22/04/2025.
//

import SwiftUI
import CoreData

class BarViewModel: ObservableObject {
    
    private let context = PersistanceController.shared.context
    
    //MARK: - Check Same Month & Category
    //function to pass that filtered array and compare id number
    func itemMonthAndCategoryInArray(theArray: [Transaction], theItem: Transaction, allSelected: Bool) -> Int? {
        
        let cal = Calendar.current
        for (i, item) in theArray.enumerated() {
            
            
            if allSelected {
                if cal.component(.month, from: item.date ?? Date()) == cal.component(.month, from: theItem.date ?? Date()) && item.category?.categoryType == theItem.category?.categoryType {
                    
                    return i
                }
            } else {
                if cal.component(.month, from: item.date ?? Date()) == cal.component(.month, from: theItem.date ?? Date()) && item.category?.id == theItem.category?.id {
                    
                    return i
                }
            }
        }
        return nil
    }
    
    //MARK: - Check Same Day & Category
    // function to check is the same four main category are repeated in the array
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
    // this function will combine similer array elements based on the same month & category
    func combineSameMonthsAndCategory(_ data: [Transaction], allSelected: Bool) -> [Transaction] {
        var myFilteredArray = [Transaction] ()
        for transaction in data {
            if let index = itemMonthAndCategoryInArray(theArray: myFilteredArray, theItem: transaction, allSelected: allSelected) {    // Already exist
                
                var newItem = myFilteredArray[index]
                
                newItem.amount! += transaction.amount ?? 0.0
                
                myFilteredArray[index] = newItem
            } else {    // new one
                myFilteredArray.append(transaction)
            }
        }
        return myFilteredArray
    }
    
    // this function will combine similer array element based on the same day & category
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
    
    // get the color for the four main categories
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
    func getFinalArray(_ allSelect: Bool, data: [Transaction], selectedTab: DateTab) -> [Bar] {
        var test : [Bar] = []
        
        let formatter = DateFormatter()
        
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
    
    //MARK: - get Data for All Filters
    func getData(
        allSelect: Bool,
        selectedTab: DateTab,
        selectedType: CategoryType?,
        selectedMonth: Int,
        selectedYear: Int,
        userId: String) -> [Bar] {
            
            let cal = Calendar.current
            
            let catData = getType(array: getUserTransactions(userId: userId), selectedType: selectedType)
            
            if DateTab.yearly == selectedTab {
                let data = catData.filter {
                    cal.component(.year, from: $0.date ?? Date()) == selectedYear
                }
                
                let sameMonthAndCategoryData = combineSameMonthsAndCategory(data, allSelected: allSelect)
                
                let test = getFinalArray(allSelect, data: sameMonthAndCategoryData, selectedTab: selectedTab)
                
                return test
                
            } else {
                let data = catData.filter {
                    $0.transactionType == .expense && cal.component(.month, from: $0.date ?? Date()) == selectedMonth + 1 && cal.component(.year, from: $0.date ?? Date()) == selectedYear
                }
                
                let sameDayAndCategoryData = combineSameDayAndCategory(data, allSelected: allSelect)
                
                let test = getFinalArray(allSelect, data: sameDayAndCategoryData, selectedTab: selectedTab)
                
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


struct Bar: Identifiable {
    let id = UUID()
    let text: String
    let color: String
    let number: Double
    let categoryID: String?
    
    init(text: String, color: String, number: Double, categoryID: String? = nil) {
        self.text = text
        self.color = color
        self.number = number
        self.categoryID = categoryID
    }
}

