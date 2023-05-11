//
//  Persistence.swift
//  OnePremium
//
//  Created by victor kabike on 2023/02/21.
//

import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "OnePremium")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //Saving Data into Core Data
    func saveData(){
        do {
           try  viewContext.save()
        }catch {
            print("Error Saving to Core Data", error.localizedDescription)
        }
    }

}
