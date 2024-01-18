//
//  BillViewModel.swift
//  OnePremium
//
//  Created by victor kabike on 2023/05/02.
//

import Foundation
import SwiftUI
import CoreData

final class BillsViewModel: ObservableObject {
    
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
    
    func CurrencyFormat(string: String) -> String {
        // Remove non-numeric characters from the string and convert to a Double
        let digits = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined()
        let value = (Double(digits) ?? 0) / 100.0
        
        // Create a NumberFormatter object with currency style and symbol for the current locale
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = (Locale.current as NSLocale).object(forKey: .currencySymbol) as? String ?? ""
        
        // Format the Double value as a string in the current locale's currency format
        let valueFormatted = currencyFormatter.string(from: NSNumber(value: value)) ?? ""
        return valueFormatted
    }
    func calculateDueDate(startDate: Date, billingCycle: String) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        switch billingCycle {
        case "weekly":
            dateComponents.weekOfYear = 1
        case "bi-weekly":
            dateComponents.weekOfYear = 2
        case "monthly":
            dateComponents.month = 1
        case "bi-monthly":
            dateComponents.month = 2
        case "quarterly":
            dateComponents.month = 3
        case "6 months":
            dateComponents.month = 6
        case "yearly":
            dateComponents.year = 1
        default:
            return nil
        }
        
        return calendar.date(byAdding: dateComponents, to: startDate)
    }
    
    // Define a helper function that checks if a given date is within the current month
    func isCurrentMonth(date: Date) -> Bool {
        // Get the current calendar
        let calendar = Calendar.current
        
        // Get the components of the current date
        let currentDateComponents = calendar.dateComponents([.year, .month], from: Date())
        
        // Get the components of the given date
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        
        // Compare the year and month components
        return currentDateComponents.year == dateComponents.year && currentDateComponents.month == dateComponents.month
    }
    
    // Create a function to fetch recurring Bills from Core Data
    func  fetchRecurringBills(viewContext: NSManagedObjectContext) -> [Bill] {
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@", Date() as NSDate)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "dueDate", ascending: true)
        ]
        do {
            let bills = try viewContext.fetch(fetchRequest)
            return bills
        } catch let error as NSError {
            print("Could not fetch nearest bills. \(error), \(error.userInfo)")
            return []
        }
    }
    
    // Create a function to add a new recurring Bills to the Core Data
    func addNewRecurringBill(name: String, amount: String, category: String?, notes: String?,startDate: Date ,billCycle: String?, image: String) {
        let bill =  Bill(context: PersistenceController.shared.viewContext)
        bill.id = UUID()
        bill.name = name
        // Remove currency symbol and convert to number
        let digits = amount.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let value = (Double(digits) ?? 0) / 100.0
        bill.amount = value
        bill.startDate = startDate
        bill.notes = notes
        bill.category = category
        bill.image = image
        bill.billCycle = billCycle
        // Save the new bill to the data store
        bill.dueDate = calculateDueDate(startDate: startDate, billingCycle: billCycle ?? "Monthly")
        PersistenceController.shared.saveData()
        // Notify views that the object is about to change
            objectWillChange.send()
    }
    func monthlySpending(context: NSManagedObjectContext) -> [Spending] {
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
        let bills: [Bill]
        do {
            bills = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching bills: \(error)")
            bills = []
        }
        
        var monthlySpendings: [Spending] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        let groupedBills = Dictionary(grouping: bills) { bill -> String in
            dateFormatter.string(from: bill.dueDate ?? Date())
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        for i in 0..<6 {
            guard let monthDate = calendar.date(byAdding: .month, value: -i, to: now) else { continue }
            let monthString = dateFormatter.string(from: monthDate)
            let amount = groupedBills[monthString]?.reduce(0) { $0 + $1.amount } ?? 0.0
            let monthlySpending = Spending(month: monthString, amount: amount)
            monthlySpendings.append(monthlySpending)
        }
        
        return monthlySpendings.reversed()
    }
    
    func weeklySpending(context: NSManagedObjectContext) -> [(week: String, amount: Double)] {
            let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
            do {
                let bills = try context.fetch(fetchRequest)
                var spending = [String: Double]()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "w"
                
                for bill in bills {
                    if let dueDate = bill.dueDate {
                        let week = dateFormatter.string(from: dueDate)
                        spending[week, default: 0] += bill.amount
                    }
                }
                
                return spending.map { (week: $0.key, amount: $0.value) }
            } catch {
                print("Error fetching bills: \(error)")
                return []
            }
    }
    
    func calculateMonthlySpending(viewContext: NSManagedObjectContext) -> Double{
        // Initialize a variable to store the total spending
        var spending = 0.0
        
        let fetchRequest = NSFetchRequest<Bill>(entityName: "Bill")
        
        // Try to execute the fetch request and get an array of SubscriptionServices objects
        do {
            let bills = try viewContext.fetch(fetchRequest)
            
            // Loop through the fetched objects
            for bill in bills {
                // Check if the nextbilldate is within the current month
                if isCurrentMonth(date: bill.dueDate ?? Date()) {
                    // Add the price to the total spending
                    spending += bill.amount
                }
            }
            // Return the total spending
            return spending
            
        } catch {
            // Handle any errors
            print("Error fetching Bills: \(error)")
            return 0.0
        }
        
    }
    
    func calculateSpendingIncrease(context: NSManagedObjectContext) -> String {
        // Initialize a variable to store the total spending by month
        var monthlySpending = [String: Double]()
        
        // Create a NSFetchRequest for SubscriptionServices entity
        let fetchRequest = NSFetchRequest<Bill>(entityName: "Bill")
        // Get the month component of the nextbilldate using a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        // Try to execute the fetch request and get an array of SubscriptionServices objects
        do {
            let bills = try context.fetch(fetchRequest)
            
            // Loop through the fetched objects
            for bill in bills {
                let month = dateFormatter.string(from: bill.dueDate ?? Date())
                
                // Add the price to the monthly spending dictionary
                monthlySpending[month, default: 0.0] += bill.amount
            }
            
            // Get the current month and last month using a date formatter
            let currentMonth = dateFormatter.string(from: Date())
            let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            let lastMonth = dateFormatter.string(from: lastMonthDate)
            
            // Get the total spending of this month and last month from the dictionary
            let thisMonthSpending = monthlySpending[currentMonth] ?? 0.0
            let lastMonthSpending = monthlySpending[lastMonth] ?? 0.0
            
            // Check if last month's spending is zero
            if lastMonthSpending == 0 {
                return "No data for last month"
            }
            
            // Calculate the difference between this month and last month
            let difference = thisMonthSpending - lastMonthSpending
            
            // Calculate the percentage increase using the formula
            var percentageIncrease = (difference / abs(lastMonthSpending))
            
            // Ensure that the percentage increase is within the range of 0% to 100%
            percentageIncrease = max(0, min(percentageIncrease, 100))
            
            // Format the percentage increase as a string
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .percent
            numberFormatter.maximumFractionDigits = 0
            return numberFormatter.string(from: NSNumber(value: percentageIncrease)) ?? "0%"
        } catch {
            print("Error fetching data: \(error)")
            return "Error fetching data"
        }
    }

}
