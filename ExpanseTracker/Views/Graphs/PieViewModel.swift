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

    @Published var dummyData: [Transaction] = [
        Transaction(
            id: "1",
            title: "Salary",
            description: "April salary",
            amount: 8000.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 1))!,
            transactionType: .income,
            category: Category(
                id: "1",
                name: "Salary",
                color: "#34C759",
                icon: "banknote",
                categoryType: .essential,
                budgetLimit: 10000.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "2",
            title: "Groceries",
            description: "Weekly shopping",
            amount: 300.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 27))!,
            transactionType: .expense,
            category: Category(
                id: "2",
                name: "Groceries",
                color: "#FF9500",
                icon: "cart",
                categoryType: .essential,
                budgetLimit: 1500.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "3",
            title: "Netflix",
            description: "Monthly subscription",
            amount: 50.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 5))!,
            transactionType: .expense,
            category: Category(
                id: "3",
                name: "Streaming",
                color: "#AF52DE",
                icon: "tv",
                categoryType: .entertainment,
                budgetLimit: 200.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "4",
            title: "Freelance",
            description: "App design project",
            amount: 2200.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 18))!,
            transactionType: .income,
            category: Category(
                id: "4",
                name: "Freelance",
                color: "#007AFF",
                icon: "laptopcomputer",
                categoryType: .other,
                budgetLimit: 0.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "5",
            title: "Doctor Visit",
            description: "Emergency check-up",
            amount: 600.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 22))!,
            transactionType: .expense,
            category: Category(
                id: "5",
                name: "Health",
                color: "#FF3B30",
                icon: "cross.case.fill",
                categoryType: .emergency,
                budgetLimit: 1200.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "6",
            title: "Salary",
            description: "March salary",
            amount: 8000.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 1))!,
            transactionType: .income,
            category: Category(
                id: "1",
                name: "Salary",
                color: "#34C759",
                icon: "banknote",
                categoryType: .essential,
                budgetLimit: 10000.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "7",
            title: "Groceries",
            description: "Weekly shopping",
            amount: 350.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 12))!,
            transactionType: .expense,
            category: Category(
                id: "2",
                name: "Groceries",
                color: "#FF9500",
                icon: "cart",
                categoryType: .essential,
                budgetLimit: 1500.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "8",
            title: "Spotify",
            description: "Music subscription",
            amount: 55.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 20))!,
            transactionType: .expense,
            category: Category(
                id: "6",
                name: "Music",
                color: "#AF52DE",
                icon: "music.note",
                categoryType: .entertainment,
                budgetLimit: 200.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "9",
            title: "Freelance Job",
            description: "Logo design",
            amount: 1800.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 10))!,
            transactionType: .income,
            category: Category(
                id: "4",
                name: "Freelance",
                color: "#007AFF",
                icon: "laptopcomputer",
                categoryType: .other,
                budgetLimit: 0.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "10",
            title: "ER Visit",
            description: "Emergency room charges",
            amount: 950.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 8))!,
            transactionType: .expense,
            category: Category(
                id: "5",
                name: "Health",
                color: "#FF3B30",
                icon: "cross.case.fill",
                categoryType: .emergency,
                budgetLimit: 1200.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "11",
            title: "Bonus",
            description: "End of year bonus",
            amount: 3000.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 28))!,
            transactionType: .income,
            category: Category(
                id: "7",
                name: "Bonus",
                color: "#5AC8FA",
                icon: "gift",
                categoryType: .other,
                budgetLimit: 0.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "12",
            title: "Gift Shopping",
            description: "Birthday gifts",
            amount: 480.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 17))!,
            transactionType: .expense,
            category: Category(
                id: "8",
                name: "Gifts",
                color: "#AF52DE",
                icon: "gift.fill",
                categoryType: .entertainment,
                budgetLimit: 500.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "13",
            title: "Rent",
            description: "Monthly apartment rent",
            amount: 2400.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
            transactionType: .expense,
            category: Category(
                id: "9",
                name: "Rent",
                color: "#66D2CE",
                icon: "house.fill",
                categoryType: .essential,
                budgetLimit: 3000.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "14",
            title: "Investment Return",
            description: "Dividend from stocks",
            amount: 1250.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 15))!,
            transactionType: .income,
            category: Category(
                id: "10",
                name: "Stocks",
                color: "#007AFF",
                icon: "chart.bar.xaxis",
                categoryType: .other,
                budgetLimit: 0.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "15",
            title: "Car Repair",
            description: "Fixing brake system",
            amount: 1100.00,
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5))!,
            transactionType: .expense,
            category: Category(
                id: "11",
                name: "Car",
                color: "#FF3B30",
                icon: "wrench.and.screwdriver",
                categoryType: .emergency,
                budgetLimit: 900.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "16",
            title: "ER Visit",
            description: "Emergency room charges",
            amount: 950.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 8))!,
            transactionType: .expense,
            category: Category(
                id: "5",
                name: "Health",
                color: "#FF3B30",
                icon: "cross.case.fill",
                categoryType: .emergency,
                budgetLimit: 1200.00
            ),
            receiptImage: ""
        ),
        Transaction(
            id: "17",
            title: "Investment Return",
            description: "Dividend from stocks",
            amount: 1250.00,
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 15))!,
            transactionType: .expense,
            category: Category(
                id: "10",
                name: "Stocks",
                color: "#007AFF",
                icon: "chart.bar.xaxis",
                categoryType: .other,
                budgetLimit: 0.00
            ),
            receiptImage: ""
        )
    ]
    
    
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

