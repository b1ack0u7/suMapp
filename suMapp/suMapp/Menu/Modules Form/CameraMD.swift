//
//  CameraMD.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

struct CameraMD: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var dataForm:STCform
    
    @State private var showCamera:Bool = false
    @State private var isPictureTaken:Bool = false
    @State private var picture:String = ""
    
    var body: some View {
        ZStack {
            Color("ITF Menu")
                .ignoresSafeArea()
            
            VStack {
                Text("\(dataForm.parameters)")
                    .font(.system(size: 20))
                    .padding(.top, 20)
                Spacer()
                
                Button(action: {
                    showCamera = true
                }, label: {
                    if(!isPictureTaken) {
                        Image(systemName: "camera")
                            .font(.system(size: 50))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                    }
                    else {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                    }
                })
                
                Spacer()
            }
        }
        .cornerRadius(20)
        .frame(width: 350, height: 150, alignment: .center)
        .sheet(isPresented: $showCamera) {
            CameraLayout(isShowingCamera: $showCamera, pic: $picture, picState: $isPictureTaken)
        }
    }
}

struct CameraMD_Previews: PreviewProvider {
    static var previews: some View {
        CameraMD(dataForm: .constant(STCform(functype: "photo", parameters: "Evidencia de nivel de sal inicial")))
            .colorScheme(.dark)
    }
}
