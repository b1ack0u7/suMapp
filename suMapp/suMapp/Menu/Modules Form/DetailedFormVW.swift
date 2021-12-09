//
//  DetailedFormVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 08/12/21.
//

import SwiftUI

struct DetailedFormVW: View {
    let dataForm:[STCform]
    
    enum Keys:String {
        case checkBox = "checkBox"
        case textField = "textField"
        case listField = "listField"
        case photo = "photo"
    }
    
    @State private var checkBoxData:[String] = []

    var body: some View {
        ZStack {
            Color("Color BG")
                .ignoresSafeArea()
            VStack {
                //checkBox()
            }
        }
        .onAppear {
            for i in 0..<dataForm.count {
                switch (Keys(rawValue: dataForm[i].functype)) {
                    case .checkBox:
                        //Titulo : Cantidad de checks : Nombre de las checks : Cantidad maxima a seleccionar
                        print("DBGN: check")
                    
                    case .textField:
                    
                        print("DBGN: text")
                    
                    case .listField:
                        //Titulo : Cantidad de items : Lista de items : Cantidad maxima a seleccionar
                        print("DBGN: list")
                    
                    case .photo:
                        //No tiene parametros
                        print("DBGN: photo")
                    
                    case .none:
                        print("DBGN: none")
                }
                
            }
        }
    }
    
    @ViewBuilder
    private func checkBox() -> some View {
        VStack {
            Text("\(checkBoxData[0])")
            HStack {
                Image(systemName: "checkmark.square.fill")
            }
        }
        
    }
}

struct DetailedFormVW_Previews: PreviewProvider {
    static var previews: some View {
        DetailedFormVW(dataForm: [STCform(functype: "checkBox", parameters: "ByPass Inicial:1")])
            .colorScheme(.dark)
    }
}
