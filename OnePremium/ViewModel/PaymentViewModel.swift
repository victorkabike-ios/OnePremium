//
//  PaymentViewModel.swift
//  OnePremium
//
//  Created by victor kabike on 2023/05/04.
//

import Foundation
import SwiftUI
import CoreData

final class PaymentViewModel: ObservableObject {
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()
// Currency Formating on Price
func CurrencyPrice(price: Double) -> String {
    return currencyFormatter.string(from: NSNumber(value: price)) ?? ""
    
}
    //function that calculates the current month’s spending based on data from the Payment entity in Core Data:
    func currentMonthSpending(in context: NSManagedObjectContext) -> Double {
        let fetchRequest = NSFetchRequest<Payments>(entityName: "Payments")
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfMonth as NSDate, endOfMonth as NSDate)
        
        let payments = try? context.fetch(fetchRequest)
        let totalSpending = payments?.reduce(0) { $0 + $1.amount } ?? 0
        return totalSpending
    }
    func monthlySpending(context: NSManagedObjectContext) -> [(month: String, amount: Double)] {
        let fetchRequest: NSFetchRequest<Payments> = Payments.fetchRequest()
        
        do {
            let payments = try context.fetch(fetchRequest)
            
            var spending = [String: Double]()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            
            for payment in payments {
                let month = dateFormatter.string(from: payment.date!)
                spending[month, default: 0] += payment.paid
            }
            
            return spending.map { (month: $0.key, amount: $0.value) }
        } catch {
            print("Error fetching payments: \(error)")
            return []
        }
    }
}
