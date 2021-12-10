//
//  DetailedFormVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 08/12/21.
//

import SwiftUI

struct DetailedFormVW: View {
    let region:String
    @State var dataForm:[STCform]
    
    private enum Keys:String {
        case checkBox = "checkBox"
        case textField = "textField"
        case listField = "listField"
        case photo = "photo"
        case stepper = "stepper"
    }
    
    @State private var dataContainer:[STCF_container] = []
    @State private var isLoading:Bool = true
    @State private var dataToSave:String = ""
    
    var body: some View {
        ZStack {
            Color("ITF BG")
                .ignoresSafeArea()
            
            if(isLoading) {
                VStack {
                    Text("Cargando")
                        .font(.system(size: 30))
                        .padding(.bottom, 20)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(1.5)
                }
                .transition(AnyTransition.opacity.animation(.easeInOut))
                
            }
            else {
                VStack {
                    ScrollView(showsIndicators: false) {
                        ForEach(dataForm.indices, id:\.self) { idx in
                            switch (Keys(rawValue: dataForm[idx].functype)) {
                            case .checkBox:
                                CheckBoxMD(dataForm: $dataForm[idx], parameters: dataContainer[idx].checkBox!)
                                    .padding(.bottom, 20)
                                
                            case .textField:
                                Text("TextField")
                                    .padding(.bottom, 20)
                                
                            case .listField:
                                ListFieldMD(dataForm: $dataForm[idx], parameters: dataContainer[idx].listField!)
                                    .padding(.bottom, 20)
                                
                            case .photo:
                                CameraMD(dataForm: $dataForm[idx])
                                    .padding(.bottom, 20)
                                
                            case.stepper:
                                Text("Stepper")
                                    .padding(.bottom, 20)
                                
                            case .none:
                                Text("None")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .transition(AnyTransition.opacity.animation(.easeInOut))
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
                    //Titulo
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
            
            withAnimation(.easeInOut) {
                isLoading = false
            }
        }
    }

}

struct DetailedFormVW_Previews: PreviewProvider {
    static var previews: some View {
        DetailedFormVW(region: "Bajio", dataForm: [
            STCform(functype: "checkBox", parameters: "Multimedia AG (o turbiedad):2:OK,IRREGULAR,Turbio,Neutro,Otro:1"),
            STCform(functype: "listField", parameters: "Nivel de sal inicial:3:Un tercio,Dos tercios,Tres tercios:1")])
        
            .colorScheme(.dark)
    }
}
