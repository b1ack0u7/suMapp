//
//  DetailedFormVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
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
        case divider = "divider"
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
                                CheckBoxMD(parameters: dataContainer[idx].checkBox!)
                                    .padding(.bottom, 20)
                                
                            case .textField:
                                Text("TextField")
                                    .padding(.bottom, 20)
                                
                            case .listField:
                                ListFieldMD(parameters: dataContainer[idx].listField!)
                                    .padding(.bottom, 20)
                                
                            case .photo:
                                CameraMD(parameters: dataContainer[idx].camera!)
                                    .padding(.bottom, 20)
                                
                            case .stepper:
                                StepperMD(parameters: dataContainer[idx].stepper!)
                                    .padding(.bottom, 20)
                                
                            case .divider:
                                Text("Divider")
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    hideKeyboard()
                }, label: {
                    Text("Done")
                })
            })
        }
        .onAppear {
            for i in 0..<dataForm.count {
                let separated = dataForm[i].parameters.components(separatedBy: ":")
                
                switch (Keys(rawValue: dataForm[i].functype)) {
                case .checkBox:
                    //Titulo : Cantidad de checks : Nombre de las checks {data1,data2} : Cantidad maxima a seleccionar
                    dataContainer.append(STCF_container(checkBox: STCF_checkBox(title: separated[0], quantity: Int(separated[1])!, tags: separated[2].components(separatedBy: ","), NumAccepted: Int(separated[3])!)))
                    //print("DBGN: check")
                
                case .textField:
                    dataContainer.append(STCF_container())
                    //print("DBGN: text")
                
                case .listField:
                    //Titulo : Cantidad de items : {Lista de items || #Sequence -> 1..<N} : Cantidad maxima a seleccionar : {#Optional || #Required = default}
                    dataContainer.append(STCF_container(listField: STCF_listField(title: separated[0], quantity: Int(separated[1])!, tags: separated[2].components(separatedBy: ","), NumAccepted: Int(separated[3])!, modifier: ENMF_Keys(rawValue: separated[safe: 4] ?? ENMF_Keys.required.rawValue)!)))
                    //print("DBGN: list")
                
                case .photo:
                    //Titulo : {#Optional || #Required = default}
                    dataContainer.append(STCF_container(camera: STCF_camera(title: separated[0], modifier: ENMF_Keys(rawValue: separated[safe:1] ?? ENMF_Keys.required.rawValue)!)))
                    //print("DBGN: photo")
                
                case .stepper:
                    //Titulo : {#Nolimit -> 0..<N || Lista -> 0,N} : Paso a dar : Formato de numero {%.0f = default} : {#Optional || #Required = default}
                    dataContainer.append(STCF_container(stepper: STCF_stepper(title: separated[0], tags: separated[1], step: Double(separated[2])!, formatt: separated[3], modifier: ENMF_Keys(rawValue: separated[safe: 4] ?? ENMF_Keys.required.rawValue)!)))
                    //print("DBGN: stepper")
                
                case .divider:
                    dataContainer.append(STCF_container())
                    
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
            STCform(functype: "listField", parameters: "Nivel de sal inicial:3:Un tercio,Dos tercios,Tres tercios:1"),
            STCform(functype: "stepper", parameters: "Cloro libre (PPM) 0.2 - 1.5:0.2,1.5:0.1:%.1f:#Required")])

            .colorScheme(.dark)
    }
}
