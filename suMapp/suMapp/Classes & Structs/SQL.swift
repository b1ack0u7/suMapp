//
//  SQL.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 07/12/21.
//

import Foundation
import SwiftUI
import Combine

/*
struct UserData: Decodable {
    var user:String?
    var pass:String?
}

struct Regions: Decodable {
    var name:String?
}

class NetworkingManager:ObservableObject {
    var didChange = PassthroughSubject<NetworkingManager,Never>()
    
    @Published var userData = UserData().self {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var regions = [Regions()].self {
        didSet {
            didChange.send(self)
        }
    }
    
    func login() {
        guard let url = URL(string: "https://run.mocky.io/v3/c788aa59-f970-49c3-8f18-7eac26b805d9") else {return}
        URLSession.shared.dataTask(with: url) {(data, response, _) in
            if let response = response {
                print(response)
            }
            do {
                guard let data = data else {return}
                let decoded = try JSONDecoder().decode(UserData.self, from: data)
                    DispatchQueue.main.async {
                        self.userData = decoded
                    }
            } catch let error as NSError {
                print("DBG: API error: ",error.localizedDescription)
            }
        }.resume()
    }
    
    func region() {
        guard let url = URL(string: "https://run.mocky.io/v3/ea4aff87-f4d0-431b-a743-385e7a64d613") else {return}
        URLSession.shared.dataTask(with: url) {(data, response, _) in
            if let response = response {
                print(response)
            }
            do {
                guard let data = data else {return}
                let decoded = try JSONDecoder().decode([Regions].self, from: data)
                    DispatchQueue.main.async {
                        self.regions = decoded
                    }
            } catch let error as NSError {
                print("DBG: API error: ",error.localizedDescription)
            }
        }.resume()
    }
}

*/
