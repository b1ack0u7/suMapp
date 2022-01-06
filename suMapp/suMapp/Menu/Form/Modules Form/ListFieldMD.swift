//
//  ListFieldMD.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

private struct MultipleSelectionRow: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                if(isSelected) {
                    Image(systemName: "checkmark")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
    }
}

struct ListFieldMD: View {
    @Environment(\.colorScheme) var colorScheme
    let parameters:STCF_listField
    
    @State private var listFetch:[String] = [""]
    
    //Select only one
    @State private var selectedItem:String = ""
    
    //Select more than one
    @State private var selectionsItem:[String] = []
    
    var body: some View {
        if(parameters.itemsMaxToSelect == 1) {
            //Select only one
            ZStack {
                Color("ITF Menu")
                
                VStack {
                    Text("\(parameters.title)")
                        .font(.system(size: 20))
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Picker("Seleccione su opción", selection: $selectedItem) {
                        ForEach(listFetch.indices, id: \.self) { idx in
                            Text(listFetch[idx])
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 250, height: 190)
                    .clipped()
                    
                    Spacer()
                }
            }
            .cornerRadius(20)
            .frame(width: 350, height: 250, alignment: .center)
            .onAppear {
                if(parameters.modifiers.contains(ENMF_Keys.sequence)) {
                    listFetch = []
                    for i in 0...parameters.itemsQuantity {
                        listFetch.append(String(i))
                    }
                }
                else {
                    listFetch = parameters.itemsList
                }
            }
        }
        else {
            //Select more than one
            ZStack {
                Color("ITF Menu")
                
                VStack {
                    Text("\(parameters.title)")
                        .font(.system(size: 20))
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    List {
                        ForEach(listFetch, id: \.self) { item in
                            MultipleSelectionRow(title: item, isSelected: selectionsItem.contains(item)) {
                                if selectionsItem.contains(item) {
                                    selectionsItem.removeAll(where: { $0 == item })
                                }
                                else {
                                    selectionsItem.append(item)
                                }
                            }
                            .listRowBackground(Color("MD listField"))
                            .listRowSeparatorTint(colorScheme == .dark ? .white : .black)
                        }
                    }
                    
                    Spacer()
                }
            }
            .cornerRadius(20)
            .frame(width: 350, height: 250, alignment: .center)
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor(Color("ITF Menu"))
                if(parameters.modifiers.contains(ENMF_Keys.sequence)) {
                    listFetch = []
                    for i in 0...parameters.itemsQuantity {
                        listFetch.append(String(i))
                    }
                }
                else {
                    listFetch = parameters.itemsList
                }
            }
        }
        
    }
}

struct ListFieldMD_Previews: PreviewProvider {
    static var previews: some View {
        ListFieldMD(parameters: STCF_listField(title: "Nivel de sal inicial", itemsQuantity: 3, itemsList: ["Un tercio", "Dos Tercios", "Tres tercios"], itemsMaxToSelect: 1, modifiers: [ENMF_Keys.required]))
        //ListFieldMD(parameters: STCF_listField(title: "Nivel de sal inicial", quantity: 3, tags: ["Un tercio", "Dos tercios", "Tres tercios"], NumAccepted: 1, modifier: ENMF_Keys.required))
            .colorScheme(.dark)
    }
}

