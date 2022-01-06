//
//  FormSubVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 05/01/22.
//

import SwiftUI

struct FormSubVW: View {
    @EnvironmentObject var dataTrans: CLSDataTrans
    let selectedRegion:String

    @State private var inteliLock:Bool = false //New visit T/F
    @State private var activateAlert:Bool = false
    
    var body: some View {
        List {
            ForEach(dataTrans.sections.indices, id:\.self) { idx in
                NavigationLink(dataTrans.sections[idx].name, destination: DetailedFormVW(selectedRegion: selectedRegion, dataForm: dataTrans.sections[idx].dataform))
                    .listRowBackground(Color("ITF Menu"))
            }
        }
        .disabled(!inteliLock)
        .navigationTitle("Secciones")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(inteliLock)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    ()
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                })
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        if(inteliLock) {
                            activateAlert = true
                        }
                        inteliLock.toggle()
                    }
                }, label: {
                    Image(systemName: inteliLock ? "square.and.arrow.down" : "plus")
                        .foregroundColor(.green)
                })
            }
        }
        .alert("¿Que desea hacer?", isPresented: $activateAlert) {
            Button("Guardar") {}
            Button("Cancelar", role: .cancel) {inteliLock = true}
        } message: {
            Text("Elija su opción")
        }
    }
    
    private func saveData() {
        
    }
}

struct FormSubVW_Previews: PreviewProvider {
    static var previews: some View {
        FormSubVW(selectedRegion: "Pacific")
    }
}
