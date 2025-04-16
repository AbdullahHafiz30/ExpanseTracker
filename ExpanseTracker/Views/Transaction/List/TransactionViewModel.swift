import Foundation

class HomeViewModel: ObservableObject {

    @Published var sampleTransactions: [Transaction] = []
    /// Calculates the total amount for a given transaction type within a specified date range.
    /// - Parameters:
    ///   - type: The transaction type to filter by.
    ///   - startDate: The beginning of the date range.
    ///   - endDate: The end of the date range.
    /// - Returns: The total amount of all transactions matching the type and date range.
    func total(for type: TransactionType, from startDate: Date, to endDate: Date) -> Double {
        sampleTransactions
            // Filter transactions by type and date range
            .filter {
               // $0.type?.rawValue == type.rawValue &&             // Match transaction type
                ($0.date ?? Date()) >= startDate &&               // On or after start date
                ($0.date ?? Date()) <= endDate                    // On or before end date
            }
            // Extract the amount from each matching transaction
            .map { $0.amount ?? 0.0 }
            // Sum all the amounts
            .reduce(0, +)
    }

}
