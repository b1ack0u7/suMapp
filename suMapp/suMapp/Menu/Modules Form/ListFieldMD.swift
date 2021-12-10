//
//  ListFieldMD.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 09/12/21.
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
    
    @Binding var dataForm:STCform
    let parameters:STCF_listField
    
    @State private var selectedItem:String = ""
    @State private var selectionsItem:[String] = []
    
    var body: some View {
        if(parameters.NumAccepted == 1) {
            ZStack {
                Color("ITF Menu")
                
                VStack {
                    Text("\(parameters.title)")
                        .font(.system(size: 20))
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Picker("Seleccione su opción", selection: $selectedItem) {
                        ForEach(parameters.tags.indices, id: \.self) { idx in
                            Text(parameters.tags[idx])
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 250, height: 100)
                    .clipped()
                    
                    Spacer()
                }
            }
            .cornerRadius(20)
            .frame(width: 350, height: 160, alignment: .center)
        }
        else {
            ZStack {
                Color("ITF Menu")
                
                VStack {
                    Text("\(parameters.title)")
                        .font(.system(size: 20))
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    List {
                        ForEach(parameters.tags, id: \.self) { item in
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
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor(Color("ITF Menu"))
            }
            .cornerRadius(20)
            .frame(width: 350, height: 250, alignment: .center)
        }
        
    }
}

struct ListFieldMD_Previews: PreviewProvider {
    static var previews: some View {
        ListFieldMD(dataForm: .constant(STCform(functype: "", parameters: "")),
                    parameters: STCF_listField(title: "Nivel de sal inicial", quantity: 3, tags: ["Un tercio", "Dos tercios", "Tres tercios"], NumAccepted: 1))
            .colorScheme(.dark)
    }
}
