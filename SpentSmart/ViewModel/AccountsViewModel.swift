//
//  AccountsViewModel.swift
//  OnePremium
//
//  Created by victor kabike on 2023/05/04.
//

import Foundation
import SwiftUI
import CoreData

final class AccountsViewModel: ObservableObject {
    // function that checks if the Accounts entity is empty in Core Data:
    func isAccountsEmpty(in context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        let count = try? context.count(for: fetchRequest)
        return count == 0
    }
    // function that fetches data from the Accounts entity in Core Data:
    func fetchAccounts(in context: NSManagedObjectContext) -> [Accounts] {
        let fetchRequest = NSFetchRequest<Accounts>(entityName: "Accounts")
        let accounts = try? context.fetch(fetchRequest)
        return accounts ?? []
    }
    // add Setup Accounts
    func setupAccount(accountName: String, balance: Double, image: String){
        let account = Accounts(context: PersistenceController.shared.viewContext)
        account.id = UUID()
        account.image = image
        account.accountName = accountName
        account.balance = balance

        PersistenceController.shared.saveData()
        // Notify views that the object is about to change
            objectWillChange.send()
    }
}
