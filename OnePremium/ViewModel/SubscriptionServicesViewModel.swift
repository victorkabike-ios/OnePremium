//
//  SubscriptionServicesViewModel.swift
//  OnePremium
//
//  Created by victor kabike on 2023/03/07.
//
//
//import Foundation
//import SwiftUI
//import CoreData
//
//// This class is responsible for managing the data and behavior of the subscription services view.
//final class SubscriptionServicesViewModel: ObservableObject {
//    
//    private let currencyFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale.current
//        return formatter
//    }()
//    
//    // MARK: Published Properties
//    
//    // The price of the subscription as a formatted string.
//    @Published  var subscriptionPrice:String = ""
//    
//    // Whether the subscription's subtitle should be hidden.
//    @Published var isSubtitleHidden = false
//    
//    // The name of the subscription.
//    @Published  var subscriptionName: String = ""
//    
//    // The logo of the subscription as a base64-encoded string.
//    @Published var logoData: String = ""
//    
//    // The Plan of the Subscription.
//    @Published var subscriptionPlan = SubscriptionPlans.Basic
//    // The category of the subscription.
//    @Published var subscriptionCategory = SubscriptionCategory.Entertainment
//    // The currency used for the subscription price.
//    @Published var currency : Locale = Locale(identifier: "en_US")
//    
//    @Published var firstPaymentDate = Date()
//    // The next bill date of the subscription.
//    @Published var isRecurring: Bool = false
//    @Published  var paymentCycle  = RenewalCycle.weekly
//    @Published var  recurringPeriod = 0
//
//    // Whether the user wants to be reminded of the next bill date.
//    @Published var remindme : Bool = false
//    
//    // The description of the subscription.
//    @Published var descriptionTxt:String = ""
//    
//    // MARK: Public Methods
//    
//    // Returns whether the subscription price is valid.
//    func isPriceValid() -> Bool {
//        return subscriptionPrice.isEmpty || firstPaymentDate <= Date()
//    }
//    // Create a function to fetch subscription services from Core Data
//    func fetchSubscriptionServices() -> [SubscriptionServices]? {
//        let fetchRequest: NSFetchRequest<SubscriptionServices> = SubscriptionServices.fetchRequest()
//        do {
//            let subscriptionServices = try PersistenceController.shared.viewContext.fetch(fetchRequest)
//            return subscriptionServices
//        } catch {
//            print("Error fetching subscription services: \(error)")
//            return nil
//        }
//    }
//    
//    /**
//     Adds a new subscription service to the app's data store.
//     */
//    func AddNewSubscription(){
//        // Create a new SubscriptionServices object and set its properties
//        let  newSubscription = SubscriptionServices(context: PersistenceController.shared.viewContext)
//        newSubscription.id = UUID().uuidString
//        newSubscription.logoData = logoData
//        newSubscription.name = subscriptionName
//        newSubscription .descriptionText = descriptionTxt
//        newSubscription.category  = subscriptionCategory.rawValue
//        newSubscription.billCategory = "Phone and Internet"
//        
//        newSubscription.isRecurring = isRecurring
//        newSubscription.recurringCycle = paymentCycle.rawValue
//        newSubscription.recurringPeriod = Int64(recurringPeriod)
//        newSubscription.firstPaymentDate = firstPaymentDate
//        newSubscription.paymentHistory = {}
//        
//        newSubscription.remindme = remindme
//
//        // Remove currency symbol and convert to number
//        let digits = subscriptionPrice.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        let value = (Double(digits) ?? 0) / 100.0
//        newSubscription.price = value
//        
//        // Save the new subscription to the data store
//        PersistenceController.shared.saveData()
//        // Notify views that the object is about to change
//            objectWillChange.send()
//        
//        
//    }
//    /**
//     Delete a  subscription service from the app's data store.
//     */
//    func deleteSubscription(subscriptionID: String) {
//        let fetchRequest: NSFetchRequest<SubscriptionServices> = SubscriptionServices.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", subscriptionID)
//        
//        do {
//            let subscriptions = try PersistenceController.shared.viewContext.fetch(fetchRequest)
//            guard let subscription = subscriptions.first else {
//                print("No subscription found with ID \(subscriptionID)")
//                return
//            }
//            PersistenceController.shared.viewContext.delete(subscription)
//            PersistenceController.shared.saveData()
//            print("Subscription with ID \(subscriptionID) deleted")
//        } catch {
//            print("Error fetching subscription with ID \(subscriptionID): \(error.localizedDescription)")
//        }
//    }
//    
//    
//    
//    /**
//     Formats a string representing a monetary value into a localized currency string.
//     - Parameter string: The string representing the monetary value to format.
//     - Returns: A localized string representing the monetary value in the current locale's currency format.
//     */
//    func CurrencyFormat(string: String) -> String {
//        // Remove non-numeric characters from the string and convert to a Double
//        let digits = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined()
//        let value = (Double(digits) ?? 0) / 100.0
//        
//        // Create a NumberFormatter object with currency style and symbol for the current locale
//        let currencyFormatter = NumberFormatter()
//        currencyFormatter.numberStyle = .currency
//        currencyFormatter.currencySymbol = (Locale.current as NSLocale).object(forKey: .currencySymbol) as? String ?? ""
//        
//        // Format the Double value as a string in the current locale's currency format
//        let valueFormatted = currencyFormatter.string(from: NSNumber(value: value)) ?? ""
//        return valueFormatted
//    }
//    
//    func fetchNearestSubscriptions(context: NSManagedObjectContext) -> [SubscriptionServices] {
//        let fetchRequest: NSFetchRequest<SubscriptionServices> = SubscriptionServices.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "nextBillDate >= %@", Date() as NSDate)
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "nextBillDate", ascending: true)
//        ]
//        fetchRequest.fetchLimit = 8
//        
//        do {
//            let subscriptions = try context.fetch(fetchRequest)
//            return subscriptions
//        } catch let error as NSError {
//            print("Could not fetch nearest subscriptions. \(error), \(error.userInfo)")
//            return []
//        }
//    }
//    
//    
//    // Currency Formating on Price
//    func CurrencyPrice(price: Double) -> String {
//        return currencyFormatter.string(from: NSNumber(value: price)) ?? ""
//        
//    }
//    
//    
//    // Next, we'll fetch all the subscription services from Core Data
//    func fetchCategorySubscriptions(context: NSManagedObjectContext) -> [CategorySpending]{
//        let fetchRequest: NSFetchRequest<SubscriptionServices> = SubscriptionServices.fetchRequest()
//        let services = try! context.fetch(fetchRequest) 
//        
//        // We'll use a dictionary to keep track of the total spending for each category
//        var categorySpendingDict = [String: Double]()
//        
//        // Loop through all the subscription services and add up the total spending for each category
//        for service in services {
//            let category = service.category ?? "Unknown"
//            let price = service.price
//            if let currentTotal = categorySpendingDict[category] {
//                categorySpendingDict[category] = currentTotal + price
//            } else {
//                categorySpendingDict[category] = price
//            }
//        }
//        
//        // Convert the dictionary into an array of CategorySpending structs
//        let categorySpending = categorySpendingDict.map { CategorySpending(category: $0.key, totalSpending: $0.value) }
//        
//        return categorySpending
//        
//    }
//    
//    func fetchMonthlySpending(context: NSManagedObjectContext) -> [MonthlySpending] {
//        let fetchRequest: NSFetchRequest<SubscriptionServices> = SubscriptionServices.fetchRequest()
//        
//        let services: [SubscriptionServices]
//        do {
//            services = try context.fetch(fetchRequest)
//        } catch {
//            print("Error fetching data: \(error.localizedDescription)")
//            return []
//        }
//        var monthlySpendings: [MonthlySpending] = []
//        _ = Calendar.current
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM"
//            let groupedServices = Dictionary(grouping: services) { service -> String in
//                dateFormatter.string(from: service.nextBillDate ?? Date())
//            }
//            for (month, services) in groupedServices {
//                let spending = services.reduce(0) { $0 + $1.price }
//                let monthlySpending = MonthlySpending(month: month, spending: spending)
//                monthlySpendings.append(monthlySpending)
//            }
//            return monthlySpendings
//        
//        
//    }
//    
//    // MARK: Define a function that takes a NSManagedObjectContext as a parameter
//    func calculateMonthlySpending(context: NSManagedObjectContext) -> Double {
//        // Initialize a variable to store the total spending
//        var totalSpending = 0.0
//        
//        // Create a NSFetchRequest for SubscriptionServices entity
//        let fetchRequest = NSFetchRequest<SubscriptionServices>(entityName: "SubscriptionServices")
//        
//        // Try to execute the fetch request and get an array of SubscriptionServices objects
//        do {
//            let subscriptionServices = try context.fetch(fetchRequest)
//            
//            // Loop through the fetched objects
//            for service in subscriptionServices {
//                // Check if the nextbilldate is within the current month
//                if isCurrentMonth(date: service.nextBillDate ?? Date()) {
//                    // Add the price to the total spending
//                    totalSpending += service.price
//                }
//            }
//            
//            // Return the total spending
//            return totalSpending
//            
//        } catch {
//            // Handle any errors
//            print("Error fetching SubscriptionServices: \(error)")
//            return 0.0
//        }
//    }
//
//    // Define a helper function that checks if a given date is within the current month
//    func isCurrentMonth(date: Date) -> Bool {
//        // Get the current calendar
//        let calendar = Calendar.current
//        
//        // Get the components of the current date
//        let currentDateComponents = calendar.dateComponents([.year, .month], from: Date())
//        
//        // Get the components of the given date
//        let dateComponents = calendar.dateComponents([.year, .month], from: date)
//        
//        // Compare the year and month components
//        return currentDateComponents.year == dateComponents.year && currentDateComponents.month == dateComponents.month
//    }
//
//    // Define a function that takes a NSManagedObjectContext as a parameter
//    func calculateSpendingIncrease(context: NSManagedObjectContext) -> Double {
//        
//        
//        // Initialize a variable to store the total spending by month
//        var monthlySpending = [String: Double]()
//        
//        // Create a NSFetchRequest for SubscriptionServices entity
//        let fetchRequest = NSFetchRequest<SubscriptionServices>(entityName: "SubscriptionServices")
//        // Get the month component of the nextbilldate using a date formatter
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM"
//        // Try to execute the fetch request and get an array of SubscriptionServices objects
//        do {
//            let subscriptionServices = try context.fetch(fetchRequest)
//            
//            // Loop through the fetched objects
//            for service in subscriptionServices {
//                let month = dateFormatter.string(from: service.nextBillDate ?? Date())
//                
//                // Add the price to the monthly spending dictionary
//                monthlySpending[month, default: 0.0] += service.price
//            }
//            
//            // Get the current month and last month using a date formatter
//            let currentMonth = dateFormatter.string(from: Date())
//            let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
//            let lastMonth = dateFormatter.string(from: lastMonthDate)
//            
//            // Get the total spending of this month and last month from the dictionary
//            let thisMonthSpending = monthlySpending[currentMonth] ?? 0.0
//            let lastMonthSpending = monthlySpending[lastMonth] ?? 0.0
//            
//            // Calculate the difference between this month and last month
//            let difference = thisMonthSpending - lastMonthSpending
//            
//            // Calculate the percentage increase using the formula
//            let percentageIncrease = difference / abs(lastMonthSpending) * 100
//            
//            // Round the result to 2 decimal places using a number formatter
//            let numberFormatter = NumberFormatter()
//            numberFormatter.maximumFractionDigits = 2
//            numberFormatter.roundingMode = .halfUp
//            
//            // Return the formatted result as a double
//            return Double(numberFormatter.string(from: NSNumber(value: percentageIncrease))!) ?? 0.0
//            
//        } catch {
//            // Handle any errors
//            print("Error fetching SubscriptionServices: \(error)")
//            return 0.0
//        }
//    }
//
//
//    // Define a helper function that checks if a given date is within the last month
//    func isLastMonth(date: Date) -> Bool {
//        // Get the current calendar
//        let calendar = Calendar.current
//        
//        // Get the components of the current date minus one month
//        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: Date())!
//        let lastMonthDateComponents = calendar.dateComponents([.year, .month], from: lastMonthDate)
//        
//        // Get the components of the given date
//        let dateComponents = calendar.dateComponents([.year, .month], from: date)
//        
//        // Compare the year and month components
//        return lastMonthDateComponents.year == dateComponents.year && lastMonthDateComponents.month == dateComponents.month
//    }
//    
//    
//    // MARK: Define a function that takes a NSManagedObjectContext as a parameter
//        func calculateWeeklySpending(context: NSManagedObjectContext) -> Double {
//            // Initialize a variable to store the total spending
//            var totalSpending = 0.0
//            
//            // Create a NSFetchRequest for SubscriptionServices entity
//            let fetchRequest = NSFetchRequest<SubscriptionServices>(entityName: "SubscriptionServices")
//            
//            // Try to execute the fetch request and get an array of SubscriptionServices objects
//            do {
//                let subscriptionServices = try context.fetch(fetchRequest)
//                
//                // Loop through the fetched objects
//                for service in subscriptionServices {
//                    // Check if the nextbilldate is within the current week
//                    if isCurrentWeek(date: service.nextBillDate ?? Date()) {
//                        // Add the price to the total spending
//                        totalSpending += service.price
//                    }
//                }
//                
//                // Return the total spending
//                return totalSpending
//                
//            } catch {
//                // Handle any errors
//                print("Error fetching SubscriptionServices: \(error)")
//                return 0.0
//            }
//        }
//
//        // Define a helper function that checks if a given date is within the current week
//        func isCurrentWeek(date: Date) -> Bool {
//            // Get the current calendar
//            let calendar = Calendar.current
//            
//            // Get the components of the current date
//            let currentDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
//            
//            // Get the components of the given date
//            let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
//            
//            // Compare the yearForWeekOfYear and weekOfYear components
//            return currentDateComponents.yearForWeekOfYear == dateComponents.yearForWeekOfYear && currentDateComponents.weekOfYear == dateComponents.weekOfYear
//        }
//    func fetchRemainingSpending(context: NSManagedObjectContext) -> Double {
//        let fetchRequest: NSFetchRequest<SubscriptionServices> = SubscriptionServices.fetchRequest()
//        let subscription = try! context.fetch(fetchRequest)
//        let calendar = Calendar.current
//        let currentDate = Date()
//        var remainingSpending = 0.0
//        do {
//            for sub in subscription {
//                if let subscription = sub as? SubscriptionServices {
//                    if calendar.isDate(subscription.nextBillDate ?? Date(), equalTo: currentDate, toGranularity: .year) {
//                        remainingSpending += subscription.price
//                    }
//                }
//            }
//        } catch {
//            print("Error fetching data")
//        }
//        return remainingSpending
//    }
//    
//}
