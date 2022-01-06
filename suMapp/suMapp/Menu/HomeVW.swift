//
//  HomeVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

struct HomeVW: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [], animation: .default) private var items: FetchedResults<Item>
    @EnvironmentObject var dataTrans: CLSDataTrans
    
    @State private var currentDate:String = ""
    @State private var currentTime:String = ""
    
    var body: some View {
        ZStack {
            Color("ITF BG")
                .ignoresSafeArea()
            
            Button(action: {
                updateForm()
            }, label: {
                Image(systemName: "arrow.counterclockwise.circle")
                    .font(.system(size: 35))
            })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .trailing, vertical: .top))
                .padding(.trailing, 30)
            
            VStack {
                VStack {
                    Text("\(currentDate)")
                        .font(.system(size: 30))
                    Text("\(currentTime)")
                        .font(.system(size: 27))
                }
                .offset(x: 0, y: 150)
                
                Spacer()
                
                VStack {
                    Text("Resueltos Hoy")
                        .font(.system(size: 25))
                    Text("Acciones: 1")
                        .font(.system(size: 22))
                }
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(x: 0, y: 150)
                
                Spacer()
            }
        }
        .onAppear {
            getDate()
        }
    }
    
    private func updateForm() {
        guard let url = URL(string: UserDefaults.standard.string(forKey: "api")!) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, _) in
            do {
                guard let data = data else {return}
                let decoded = try JSONDecoder().decode(Cforms.self, from: data)
                DispatchQueue.main.async {
                    updateData(dataForm: decoded)
                }
            } catch let error as NSError {
                print("DBG: API error: ",error.localizedDescription)
            }
        }.resume()
    }
    
    private func updateData(dataForm:Cforms) {
        items[0].forms = dataForm
        do {
            try viewContext.save()
            print("Data updated")
            
            dataTrans.regions = items[0].forms!.regions
            dataTrans.sections = items[0].forms!.sections
        } catch {
            let nsError = error as NSError
            fatalError("DBGE: Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    func getDate() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "EEEE d MMMM"

        var date = formatter.string(from: today).capitalized.components(separatedBy: " ")
        date.insert("de", at: 2)
        
        formatter.dateFormat = "h:mm:ss a"
        let time = formatter.string(from: Date()).uppercased()
        
        currentDate = date.joined(separator: " ")
        currentTime = time
    }
}

struct HomeVW_Previews: PreviewProvider {
    static var previews: some View {
        HomeVW()
            .environmentObject(CLSDataTrans())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
