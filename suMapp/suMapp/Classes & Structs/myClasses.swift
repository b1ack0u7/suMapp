//
//  myClasses.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import Foundation
import SwiftUI
import UIKit

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

class CLSDataTrans: ObservableObject {
    @Published var dataForm:[[STCform]] = []
    @Published var regions:[String] = []
    @Published var sections:[String] = []
}

public class myForm: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    var functype:String
    var parameters:String
    
    enum Keys:String {
        case functype = "functype"
        case parameters = "parameters"
    }
    
    init(functype:String, parameters:String) {
        self.functype = functype
        self.parameters = parameters
    }
    
    public required convenience init?(coder: NSCoder) {
        let mFunctype = coder.decodeObject(of: NSString.self, forKey: Keys.functype.rawValue)! as String
        let mParameters = coder.decodeObject(of: NSString.self, forKey: Keys.parameters.rawValue)! as String
        
        self.init(functype: mFunctype, parameters: mParameters)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(functype, forKey: Keys.functype.rawValue)
        coder.encode(parameters, forKey: Keys.parameters.rawValue)
    }
}



public class mySection: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let name:String
    let form:[myForm]
    
    enum Keys:String {
        case name = "name"
        case form = "form"
    }
    
    init(name:String, form:[myForm]) {
        self.name = name
        self.form = form
    }
    
    public required convenience init?(coder: NSCoder) {
        let mSection = coder.decodeObject(of: NSString.self, forKey: Keys.name.rawValue)! as String
        let mForm = coder.decodeObject(of: [NSArray.self, myForm.self], forKey: Keys.form.rawValue) as! [myForm]
        
        self.init(name: mSection, form: mForm)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Keys.name.rawValue)
        coder.encode(form, forKey: Keys.form.rawValue)
    }
}

public class Sections: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let sections:[mySection]
    
    enum Key:String {
        case sections = "sections"
    }
    
    init(sections:[mySection]) {
        self.sections = sections
    }
    
    public required convenience init?(coder: NSCoder) {
        let mSections = coder.decodeObject(of: [NSArray.self, mySection.self], forKey: Key.sections.rawValue) as! [mySection]
        
        self.init(sections: mSections)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(sections, forKey: Key.sections.rawValue)
    }
}

public class Regions: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let region:[String]
    
    enum Key:String {
        case region = "region"
    }
    
    init(region:[String]) {
        self.region = region
    }
    
    public required convenience init?(coder: NSCoder) {
        let mRegions = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: Key.region.rawValue) as! [String]
        
        self.init(region: mRegions)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(region, forKey: Key.region.rawValue)
    }
}

class DBAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [Regions.self, Sections.self]
    }
    
    static func register() {
        let className = String(describing: DBAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = DBAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
