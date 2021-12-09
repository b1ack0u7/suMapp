//
//  myStructs.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 08/12/21.
//

import Foundation

struct STCdataApi: Decodable {
    var regions:[STCinnerRegion]?
    var dataform:[STCinnerDataForm]?
}

struct STCinnerRegion: Decodable {
    let name:String
}

struct STCinnerDataForm: Identifiable, Decodable {
    var id = UUID()
    let functype: String
    let parameters: String
    
    private enum CodingKeys: String, CodingKey {case functype, parameters}
}

struct STCform:Identifiable {
    var id = UUID()
    let functype:String
    let parameters:String
}
