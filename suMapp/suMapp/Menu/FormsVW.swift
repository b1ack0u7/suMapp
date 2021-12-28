//
//  FormsVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

struct FormsVW: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [],animation: .default) private var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            Button(action: {
                //allData()
            }, label: {
                Text("Show Data")
            }).padding()
            
            Button(action: {
                addItem()
            }, label: {
                Text("Add Data")
            }).padding()
            
            if(items.count > 0) {
                List {
                    ForEach((items[0].sections?.sections.indices)!, id: \.self) { idx in
                        Text("\((items[0].sections?.sections[idx].name)!)")
                    }
                    
                }
            }
            
        }
    }
     
    
    private func addItem() {
        let newItem = Item(context: viewContext)
        newItem.regions = Regions(region: ["Hey","que tal"])
        newItem.sections = Sections(sections: [mySection(name: "Comprar", form: [myForm(functype: "Box", parameters: "pAram")])])
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct FormsVW_Previews: PreviewProvider {
    static var previews: some View {
        FormsVW()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
