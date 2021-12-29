//
//  myStructs.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import Foundation

struct STCdataApi: Decodable {
    var regions:[STCinnerRegionAPI]?
    var sections:[STCinnerSectionAPI]?
}

struct STCinnerRegionAPI: Decodable {
    let name:String
}

struct STCinnerSectionAPI: Decodable {
    let name:String
    let dataform:[STCinnerDataFormAPI]
}

struct STCinnerDataFormAPI: Identifiable, Decodable {
    var id = UUID()
    let functype: String
    let parameters: String
    
    private enum CodingKeys: String, CodingKey {case functype, parameters}
}

struct STCform:Identifiable {
    var id = UUID()
    let functype:String
    let parameters:String
    var results:String?
}

//DetailedForm Structs
struct STCF_checkBox {
    let title:String
    let quantity:Int
    let tags:[String]
    let NumAccepted:Int
}

struct STCF_listField {
    let title:String
    let quantity:Int
    let tags:[String]
    let NumAccepted:Int
}

struct STCF_stepper {
    let title:String
    let modificators:[String]
}

struct STCF_container {
    var checkBox:STCF_checkBox?
    var listField:STCF_listField?
    var stepper:STCF_stepper?
}
