//
//  FormsVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

struct FormsVW: View {
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("ITF BG"))
        
        //Resources: NavigationView Style
        //https://www.bigmountainstudio.com/community/public/posts/80041-how-do-i-customize-the-navigationview-in-swiftui
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(Color("ITF BG"))
        UINavigationBar.appearance().standardAppearance = appearance
    }
    @EnvironmentObject var dataTrans: CLSDataTrans
    
    @State private var inteliBlock:Bool = true
    @State private var dataForm:[STCform] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataTrans.regions.indices, id:\.self) { idx in
                    NavigationLink(dataTrans.regions[idx], destination: subView())
                        .listRowBackground(Color("ITF Menu"))
                        //.disabled(inteliBlock)
                }
            }
            .navigationTitle("Regiones")
        }
        .onAppear {
            /*
            for i in 0..<items[0].form!.count {
                dataForm.append(STCform(functype: items[0].form![i].functype, parameters: items[0].form![i].parameters))
            }
            inteliBlock = false
             */
        }
    }
    
    @ViewBuilder
    private func subView() -> some View {
        List {
            ForEach(dataTrans.sections.indices, id:\.self) { idx in
                NavigationLink(dataTrans.sections[idx], destination: DetailedFormVW(region: dataTrans.sections[idx], dataForm: dataTrans.dataForm[idx]))
                    .listRowBackground(Color("ITF Menu"))
            }
        }
    }
    
}

struct FormsVW_Previews: PreviewProvider {
    static var previews: some View {
        FormsVW()
            .environmentObject(CLSDataTrans())
            //.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            //.colorScheme(.dark)
    }
}
