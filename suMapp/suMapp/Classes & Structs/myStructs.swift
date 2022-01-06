//
//  myStructs.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import Foundation

//DataTrans
struct STCdataTrans {
    var regions:[String] = []
    var sections:[Cforms] = []
}


//DetailedForm Structs

enum ENMF_Keys:String {
    case optional = "#Optional"
    case required = "#Required"
    case sequence = "#Sequence"
    case nolimit = "#Nolimit"
}

//Container
struct STCF_container {
    var checkBox:STCF_checkBox?
    var listField:STCF_listField?
    var camera:STCF_camera?
    var stepper:STCF_stepper?
}

//Check Box
struct STCF_checkBox {
    let title:String
    let itemsQuantity:Int
    let itemsList:[String]
    let itemsMaxToSelect:Int
    let modifiers:[ENMF_Keys?]
}

//List Field
struct STCF_listField {
    let title:String
    let itemsQuantity: Int
    let itemsList:[String]
    let itemsMaxToSelect:Int
    let modifiers:[ENMF_Keys?]
}

//Stepper
struct STCF_stepper {
    let title:String
    let itemRange:[Double]
    let step:Double
    let numberFormat:String
    let modifiers:[ENMF_Keys?]
}

//Camera
struct STCF_camera {
    let title:String
    let modifier:[ENMF_Keys?]
}
