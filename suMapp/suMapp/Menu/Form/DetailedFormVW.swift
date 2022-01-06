//
//  DetailedFormVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

struct DetailedFormVW: View {
    let selectedRegion:String
    @State var dataForm:[SectionsDataForm]
    
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
            UIToolbar.appearance().barTintColor = UIColor.systemGray5
            for i in 0..<dataForm.count {
                let cnt = dataForm[i]
                let mod = cnt.modifiers.map {ENMF_Keys(rawValue: $0)}
                
                switch (Keys(rawValue: cnt.functype)) {
                case .checkBox:
                    //Titulo : Cantidad de checks : Nombre de las checks {data1,data2} : Cantidad maxima a seleccionar
                    dataContainer.append(STCF_container(checkBox: STCF_checkBox(title: cnt.title, itemsQuantity: cnt.itemsQuantity!, itemsList: cnt.itemsList!, itemsMaxToSelect: cnt.itemsMaxToSelect!, modifiers: mod)))
                    //print("DBGN: check")
                
                case .textField:
                    dataContainer.append(STCF_container())
                    //print("DBGN: text")
                
                case .listField:
                    //Titulo : Cantidad de items : {Lista de items || #Sequence -> 1..<N} : Cantidad maxima a seleccionar : {#Optional || #Required = default}
                    dataContainer.append(STCF_container(listField: STCF_listField(title: cnt.title, itemsQuantity: cnt.itemsQuantity!, itemsList: cnt.itemsList!, itemsMaxToSelect: cnt.itemsMaxToSelect!, modifiers: mod)))
                    //print("DBGN: list")
                
                case .photo:
                    //Titulo : {#Optional || #Required = default}
                    dataContainer.append(STCF_container(camera: STCF_camera(title: cnt.title, modifier: mod)))
                    //print("DBGN: photo")
                
                case .stepper:
                    //Titulo : {#Nolimit -> 0..<N || Lista -> 0,N} : Paso a dar : Formato de numero {%.0f = default} : {#Optional || #Required = default}
                    dataContainer.append(STCF_container(stepper: STCF_stepper(title: cnt.title, itemRange: cnt.itemRange!, step: cnt.step!, numberFormat: cnt.numberFormat!, modifiers: mod)))
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
        DetailedFormVW(selectedRegion: "Bajio", dataForm: [])

            .colorScheme(.dark)
    }
}
