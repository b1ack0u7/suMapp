//
//  DetailedFormVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 08/12/21.
//

import SwiftUI

private struct STCF_checkBox {
    let title:String
    let quantity:Int
    let tags:[String]
    let NumAccepted:Int
}

private struct STCF_listField {
    let title:String
    let quantity:Int
    let tags:[String]
    let NumAccepted:Int
}

private struct STCF_stepper {
    let title:String
    let modificators:[String]
}

private struct STCF_container {
    var checkBox:STCF_checkBox?
    var listField:STCF_listField?
    var stepper:STCF_stepper?
}


struct DetailedFormVW: View {
    let region:String
    let dataForm:[STCform]
    
    private enum Keys:String {
        case checkBox = "checkBox"
        case textField = "textField"
        case listField = "listField"
        case photo = "photo"
        case stepper = "stepper"
    }
    
    @State private var dataContainer:[STCF_container] = []

    var body: some View {
        ZStack {
            Color("Color BG")
                .ignoresSafeArea()
            VStack {
                ForEach(dataForm.indices, id:\.self) { idx in
                    switch (Keys(rawValue: dataForm[idx].functype)) {
                    case .checkBox:
                        //checkBox(parameters: dataContainer[idx].checkBox!)
                        Text("CheckBox")
                    case .textField:
                        Text("TextField")
                        
                    case .listField:
                        listView()
                        
                    case .photo:
                        Text("Photo")
                        
                    case.stepper:
                        Text("Stepper")
                        
                    case .none:
                        Text("None")
                    }
                }
            }
        
        }
        .onAppear {
            for i in 0..<dataForm.count {
                let separated = dataForm[i].parameters.components(separatedBy: ":")
                
                switch (Keys(rawValue: dataForm[i].functype)) {
                case .checkBox:
                    //Titulo : Cantidad de checks : Nombre de las checks {data1,data2} : Cantidad maxima a seleccionar
                    dataContainer.append(STCF_container(checkBox: STCF_checkBox(title: separated[0], quantity: Int(separated[1])!, tags: separated[2].components(separatedBy: ","), NumAccepted: Int(separated[3])!)))
                    
                    print("DBGN: check")
                
                case .textField:
                    dataContainer.append(STCF_container())
                    print("DBGN: text")
                
                case .listField:
                    //Titulo : Cantidad de items : Lista de items {#Sequence 1..<N} : Cantidad maxima a seleccionar
                    dataContainer.append(STCF_container(listField: STCF_listField(title: separated[0], quantity: Int(separated[1])!, tags: separated[2].components(separatedBy: ","), NumAccepted: Int(separated[3])!)))
                    
                    print("DBGN: list")
                
                case .photo:
                    //No tiene parametros
                    dataContainer.append(STCF_container())
                    print("DBGN: photo")
                
                case .stepper:
                    //Titulo : {#Nolimit 0..<N} {#Aplicable true,false}
                    dataContainer.append(STCF_container(stepper: STCF_stepper(title: separated[0], modificators: separated[1].components(separatedBy: ","))))

                    print("DBGN: stepper")
                
                case .none:
                    print("DBGN: none")
                }
                
            }
            
            disp()
        }
    }
    
    func disp() {
        for i in 0..<dataForm.count {
            print("DBGU: checkBox: \(dataContainer[i].checkBox?.title), listField: \(dataContainer[i].listField?.title), stepper: \(dataContainer[i].stepper?.title)")
        }
    }
    
    @ViewBuilder
    private func checkBox(parameters:STCF_checkBox) -> some View {
        ZStack {
            Color("Color menu")
            VStack {
                Text("CheckBox")
            }
        }
        .cornerRadius(20)
        .frame(width: 350, height: 200, alignment: .center)
        
        
    }
    
    @ViewBuilder
    private func listView() -> some View {
        VStack {
            Text("ListView")
        }
    }
}

struct DetailedFormVW_Previews: PreviewProvider {
    static var previews: some View {
        DetailedFormVW(region: "Bajio", dataForm: [
            STCform(functype: "checkBox", parameters: "Multimedia AG (o turbiedad):2:OK,IRREGULAR:1"),
            STCform(functype: "listField", parameters: "Nivel de sal inicial:3:Un tercio,Dos tercios,Tres tercios:1")])
        
            .colorScheme(.dark)
    }
}
