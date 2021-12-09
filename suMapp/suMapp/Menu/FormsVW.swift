//
//  FormsVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 07/12/21.
//

import SwiftUI

struct FormsVW: View {
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("Color BG"))
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [], animation: .default) private var items: FetchedResults<Item>
    
    @State private var inteliBlock:Bool = true
    @State private var dataForm:[STCform] = []
    
    var body: some View {
        NavigationView {
            List(items[0].regions!.indices) { i in
                NavigationLink(items[0].regions![i].name, destination: DetailedFormVW(region: items[0].regions![i].name, dataForm: dataForm))
                    .listRowBackground(Color("Color menu"))
            }
            .disabled(inteliBlock)
            .navigationTitle("Regiones")
        }
        .onAppear {
            for i in 0..<items[0].form!.count {
                dataForm.append(STCform(functype: items[0].form![i].functype, parameters: items[0].form![i].parameters))
            }
            inteliBlock = false
        }
    }
    
}

struct FormsVW_Previews: PreviewProvider {
    static var previews: some View {
        FormsVW()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            //.colorScheme(.dark)
    }
}
