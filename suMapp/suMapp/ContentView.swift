//
//  ContentView.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [], animation: .default) private var items: FetchedResults<Item>
    
    var dataTrans = CLSDataTrans()
    @State var isLogged:Bool
    
    @State private var tabIcons:[String] = ["house.fill","text.book.closed.fill","exclamationmark.triangle.fill","gear"]
    @State private var tabIndex:Int = 0
    @State private var dataToPass:STCdataTrans = STCdataTrans()
    
    var body: some View {
        if(isLogged) {
            VStack(spacing: 0) {
                switch tabIndex {
                case 0:
                    HomeVW()
                case 1:
                    FormsVW()
                case 2:
                    AlertsVW()
                case 3:
                    SettingsVW(showLogin: $isLogged, tabIndex: $tabIndex)
                default:
                    Text("")
                }
                
                ZStack {
                    Color("ITF BG")
                    Rectangle()
                        .fill(Color("ITF Menu"))
                        .cornerRadius(25)
                        .shadow(radius: 6)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    LazyHGrid(rows: [GridItem(.flexible())], spacing: 14) {
                        ForEach(0..<tabIcons.count, id: \.self) { i in
                            Spacer()
                            ZStack {
                                //Selected Option
                                /*
                                if(i == tabIndex) {
                                    Circle()
                                        .foregroundColor(Color("ITF selection"))
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50)
                                }
                                 */
                                
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    withAnimation(.easeInOut) {
                                        tabIndex = i
                                    }
                                }, label: {
                                    Image(systemName: tabIcons[i])
                                        .resizable()
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .foregroundColor(i == tabIndex ? Color.white : Color.gray)
                                })
                            }
                            .frame(width: 60, alignment: .center)
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
            }
            .transition(AnyTransition.opacity.animation(.easeInOut))
            .environmentObject(dataTrans)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                dataTrans.regions = items[0].forms!.regions
                dataTrans.sections = items[0].forms!.sections
            }
        }
        else {
            LoginVW(showLogin: $isLogged)
                .transition(AnyTransition.opacity.animation(.easeInOut))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLogged: true)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
