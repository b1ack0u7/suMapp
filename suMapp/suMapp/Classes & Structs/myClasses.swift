//
//  myClasses.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 06/12/21.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public class Regions: NSObject, NSCoding {
    let name:String
    
    enum Keys:String {
        case name = "name"
    }
    
    init(name:String) {
        self.name = name
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Keys.name.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let Mname = coder.decodeObject(forKey: Keys.name.rawValue) as! String
        
        self.init(name: Mname)
    }
}

public class Form: NSObject, NSCoding {
    let functype:String
    let parameters:String
    
    enum Keys:String {
        case functype = "functype"
        case parameters = "parameters"
    }
    
    init(functype:String, parameters:String) {
        self.functype = functype
        self.parameters = parameters
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(functype, forKey: Keys.functype.rawValue)
        coder.encode(parameters, forKey: Keys.parameters.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let Mfunctype = coder.decodeObject(forKey: Keys.functype.rawValue) as! String
        let Mparameters = coder.decodeObject(forKey: Keys.parameters.rawValue) as! String
        
        self.init(functype: Mfunctype, parameters: Mparameters)
    }
}


