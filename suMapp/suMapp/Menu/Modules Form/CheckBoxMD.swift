//
//  CheckBoxMD.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 09/12/21.
//

import SwiftUI

struct CheckBoxMD: View {
    @Binding var dataForm:STCform
    let parameters:STCF_checkBox
    let col = [GridItem(.flexible(), spacing: 0),
               GridItem(.flexible(), spacing: 0),
               GridItem(.flexible(), spacing: 0)]
    
    @State private var checkedBool:[Bool] = []
    @State private var inteliLock:Bool = true
    
    var body: some View {
        ZStack {
            Color("Color menu")
            if(!inteliLock) {
                
                VStack {
                    Text("\(parameters.title)")
                        .font(.system(size: 20))
                        .offset(x: 0, y: 20)
                    if(parameters.tags.count > 1) {
                        LazyVGrid(columns: col, spacing: 20) {
                            ForEach(parameters.tags.indices, id: \.self) { idx in
                                VStack {
                                    Text("\(parameters.tags[idx])")
                                    Image(systemName: checkedBool[idx] ? "checkmark.square.fill" : "square")
                                        .foregroundColor(checkedBool[idx] ? Color(UIColor.systemBlue) : Color.secondary)
                                        .onTapGesture {
                                            checkedBool[idx].toggle()
                                        }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
        }
        .cornerRadius(20)
        .frame(width: 350, height: 200, alignment: .center)
        .onAppear {
            checkedBool = Array(repeating: false, count: parameters.tags.count)
            inteliLock = false
        }
    }
}


struct CheckBoxMD_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxMD(dataForm: .constant(STCform(functype: "", parameters: "")),
                   parameters: STCF_checkBox(title: "Multimedia AG (o turbiedad)", quantity: 2, tags: ["OK","IRREGULAR"], NumAccepted: 1))
    }
}

