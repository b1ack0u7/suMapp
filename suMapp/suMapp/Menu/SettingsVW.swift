//
//  SettingsVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 07/12/21.
//

import SwiftUI
import UserNotifications

//Resources: Logout
//https://stackoverflow.com/questions/52275684/how-can-i-restart-an-application-programmatically-in-swift-4-on-ios/52278301#52278301

struct SettingsVW: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [], animation: .default) private var items: FetchedResults<Item>
    @EnvironmentObject var dataTrans: CLSDataTrans
    
    @Binding var showLogin:Bool
    @Binding var tabIndex:Int
    @State private var showAlert:Bool = false
    
    var body: some View {
        ZStack {
            Color("ITF BG")
                .ignoresSafeArea()
            Button(action: {
                showAlert = true
            }, label: {
                VStack {
                    Text("Cerrar sesión")
                }
            })
        }
        .alert("¿Desea cerrar sesión?", isPresented: $showAlert) {
            Button("Si") {}
            Button("No", role: .cancel) {}
        }
    }
    
    private func clearData() {
        //UserDefaults
        UserDefaults.standard.removeObject(forKey: "isLogged")
        UserDefaults.standard.removeObject(forKey: "api")
        
        //TransferableData
        dataTrans.regions = []
        dataTrans.sections = []
        
        //CoreData
        for data in items {
            viewContext.delete(data)
        }
        do {
            try viewContext.save()
            print("CoreData Cleared")
        } catch let error as NSError {
            print("DBG: API error: ",error.localizedDescription)
        }
    }
}

struct SettingsVW_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVW(showLogin: .constant(false), tabIndex: .constant(0))
            .environmentObject(CLSDataTrans())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .colorScheme(.dark)
    }
}
