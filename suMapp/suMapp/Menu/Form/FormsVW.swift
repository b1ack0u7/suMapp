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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataTrans.regions.indices, id:\.self) { idx in
                    NavigationLink(dataTrans.regions[idx], destination: FormSubVW(selectedRegion: dataTrans.regions[idx]))
                        .listRowBackground(Color("ITF Menu"))
                }
            }
            .navigationTitle("Regiones")
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
