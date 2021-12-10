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
    @State private var lastSelected:Int = 0
    
    var body: some View {
        ZStack {
            Color("ITF Menu")
            if(!inteliLock) {
                VStack {
                    Text("\(parameters.title)")
                        .font(.system(size: 20))
                        .padding(.top, 20)
                    
                    Spacer()
                    if(parameters.tags.count == 2) {
                        HStack(spacing: 60) {
                            ForEach(parameters.tags.indices, id: \.self) { idx in
                                VStack(spacing: 10) {
                                    Text("\(parameters.tags[idx])")
                                    Image(systemName: checkedBool[idx] ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 20))
                                        .foregroundColor(checkedBool[idx] ? Color(UIColor.systemBlue) : Color.secondary)
                                        .onTapGesture {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            lastSelected = idx
                                            checkedBool[idx].toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                checkSelection()
                                            }
                                        }
                                }
                            }
                        }
                    }
                    else {
                        LazyVGrid(columns: col, spacing: 20) {
                            ForEach(parameters.tags.indices, id: \.self) { idx in
                                VStack {
                                    Text("\(parameters.tags[idx])")
                                    Image(systemName: checkedBool[idx] ? "checkmark.square.fill" : "square")
                                        .foregroundColor(checkedBool[idx] ? Color(UIColor.systemBlue) : Color.secondary)
                                        .onTapGesture {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            lastSelected = idx
                                            checkedBool[idx].toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                checkSelection()
                                            }
                                        }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    Spacer()
                }
            }
        }
        .cornerRadius(20)
        .frame(width: 350, height: 150, alignment: .center)
        .onAppear {
            checkedBool = Array(repeating: false, count: parameters.tags.count)
            inteliLock = false
        }
    }
    
    private func checkSelection() {
        var countTrues:Int = 0
        for i in 0..<checkedBool.count {
            if(checkedBool[i]) {
                countTrues += 1
            }
        }
        if(countTrues > 1) {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            withAnimation(.easeInOut) {
                checkedBool[lastSelected].toggle()
            }
        }
    }
}


struct CheckBoxMD_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxMD(dataForm: .constant(STCform(functype: "", parameters: "")),
                   parameters: STCF_checkBox(title: "Multimedia AG (o turbiedad)", quantity: 2, tags: ["OK","IRREGULAR"], NumAccepted: 1))
    }
}

