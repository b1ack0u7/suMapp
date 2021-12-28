//
//  suMappApp.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

@main
struct suMappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
