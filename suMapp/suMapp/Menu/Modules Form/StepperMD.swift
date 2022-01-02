//
//  StepperMD.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 01/01/22.
//

import SwiftUI

struct StepperMD: View {
    let parameters:STCF_stepper
    
    @State private var numMin:Double = 0.0
    @State private var numMax:Double = 5.0
    @State private var myNumber:Double = 0.0
    
    @State private var numberS:String = "0"
    
    var body: some View {
        ZStack {
            Color("ITF Menu")
            
            VStack {
                Text("\(parameters.title)")
                    .font(.system(size: 20))
                
                if(ENMF_Keys(rawValue: parameters.tags) == ENMF_Keys.nolimit) {
                    TextField(String(format: parameters.formatt, numberS), text: $numberS)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 18))
                        .padding(.top, 1)
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                    
                }
                else {
                    TextField(String(format: parameters.formatt, myNumber), text: $numberS)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 18))
                        .padding(.top, 1)
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .onChange(of: numberS, perform: { newValue in
                            let tmpNumb = Double(numberS) ?? numMin
                            if(tmpNumb >= numMin && tmpNumb <= numMax) {
                                myNumber = tmpNumb
                            }
                            else if(tmpNumb < numMin) {
                                myNumber = numMin
                                numberS = String(format:parameters.formatt, myNumber)
                            }
                            else if(tmpNumb > numMax) {
                                myNumber = numMax
                                numberS = String(format:parameters.formatt, myNumber)
                            }
                        })
                    
                    ZStack {
                        Text("Min")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                        Text("Max")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 30)
                    }
                    
                    Slider(
                        value: $myNumber,
                        in: numMin...numMax,
                        step: parameters.step,
                        onEditingChanged: { _ in
                            numberS = String(format:parameters.formatt, myNumber)
                        },
                        minimumValueLabel: Text(String(format: parameters.formatt, numMin)),
                        maximumValueLabel: Text(String(format: parameters.formatt, numMax)),
                        label: {Text("")}
                    )
                        .padding([.leading, .trailing], 32)
                }
                
            }
        }
        .cornerRadius(20)
        .frame(width: 350, height: 180, alignment: .center)
        .onAppear {
            if(ENMF_Keys(rawValue: parameters.tags) != ENMF_Keys.nolimit) {
                let tags = parameters.tags.components(separatedBy: ",")
                numMin = Double(tags[0])!
                numMax = Double(tags[1])!
                myNumber = Double(numMin)
                numberS = String(myNumber)
            }
        }
    }
}

struct StepperMD_Previews: PreviewProvider {
    static var previews: some View {
        StepperMD(parameters: STCF_stepper(title: "Cantidades", tags: "0.2,1.5", step: 0.1, formatt: "%.1f", modifier: ENMF_Keys.required))
            .colorScheme(.dark)
    }
}
