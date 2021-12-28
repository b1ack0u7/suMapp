//
//  suMappApp.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 06/12/21.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        DBAttributeTransformer.register()
        return true
    }
}

@main
struct suMappApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(isLogged: UserDefaults.standard.bool(forKey: "isLogged"))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
