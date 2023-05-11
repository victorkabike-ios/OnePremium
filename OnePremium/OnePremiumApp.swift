//
//  OnePremiumApp.swift
//  OnePremium
//
//  Created by victor kabike on 2023/02/21.
//

import SwiftUI

@main
struct OnePremiumApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
               
        }
    }
}
