//
//  suMappApp.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 06/12/21.
//

import SwiftUI

@main
struct suMappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(showLoggin: UserDefaults.standard.bool(forKey: "isLogged"))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
