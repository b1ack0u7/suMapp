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

/*
public class Sections: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let name:String
    let forms:[STCinnerDataFormAPI]
    
    enum Keys:String {
        case name = "name"
        case forms = "forms"
    }
    
    init(name:String, forms:[STCinnerDataFormAPI]) {
        self.name = name
        self.forms = forms
    }
    
    public required convenience init?(coder: NSCoder) {
        let mName = coder.decodeObject(of: NSString.self, forKey: Keys.name.rawValue)! as String
        let mForms = coder.decodeObject(of: NSArray.self, forKey: Keys.forms.rawValue)! as! [STCinnerDataFormAPI]
        
        self.init(name: mName, forms: mForms)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Keys.name.rawValue)
        coder.encode(forms, forKey: Keys.forms.rawValue)
    }
}*/

public class Regions: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let name:String
    
    enum Keys:String {
        case name = "name"
    }
    
    init(name:String) {
        self.name = name
    }
    
    public required convenience init?(coder: NSCoder) {
        let mName = coder.decodeObject(of: NSString.self, forKey: Keys.name.rawValue)! as String
        
        self.init(name: mName)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Keys.name.rawValue)
    }
}


class DBAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [Regions.self]
    }
    
    static func register() {
        let className = String(describing: DBAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = DBAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
