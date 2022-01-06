//
//  myClasses.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import Foundation
import SwiftUI
import UIKit

class CLSDataTrans: ObservableObject {
    @Published var regions:[String] = []
    @Published var sections:[String] = []
    @Published var dataForm:[[STCform]] = []
}

public class RSecc: NSObject, NSSecureCoding, Decodable {
    public static var supportsSecureCoding: Bool = true
    
    let functype:String
    let title:String
    let itemsQuantity:Int?
    let itemsList:[String]?
    let itemRange:[Float]?
    let itemsMaxToSelect:Int?
    let step:Float?
    let numberFormat:String?
    let modifiers:[String]?
    
    enum Keys:String {
        case functype = "functype"
        case title = "title"
        case itemsQuantity = "itemsQuantity"
        case itemsList = "itemsList"
        case itemRange = "itemRange"
        case itemsMaxToSelect = "itemsMaxToSelect"
        case step = "step"
        case numberFormat = "numberFormat"
        case modifiers = "modifiers"
    }
    
    init(functype:String, title:String, itemsQuantity:Int, itemsList:[String], itemRange:[Float], itemsMaxToSelect:Int, step:Float, numberFormat:String, modifiers:[String]) {
        self.functype = functype
        self.title = title
        self.itemsQuantity = itemsQuantity
        self.itemsList = itemsList
        self.itemRange = itemRange
        self.itemsMaxToSelect = itemsMaxToSelect
        self.step = step
        self.numberFormat = numberFormat
        self.modifiers = modifiers
    }
    
    public required convenience init?(coder: NSCoder) {
        let mFunctype = coder.decodeObject(of: NSString.self, forKey: Keys.functype.rawValue)! as String
        let mTitle = coder.decodeObject(of: NSString.self, forKey: Keys.title.rawValue)! as String
        let mItemsQuantity = coder.decodeObject(of: NSNumber.self, forKey: Keys.itemsQuantity.rawValue) as! Int
        let mItemsList = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: Keys.itemsList.rawValue) as! [String]
        let mItemRange = coder.decodeObject(of: [NSArray.self, NSNumber.self], forKey: Keys.itemRange.rawValue) as! [Float]
        let mItemsMaxToSelect = coder.decodeObject(of: NSNumber.self, forKey: Keys.itemsMaxToSelect.rawValue) as! Int
        let mStep = coder.decodeObject(of: NSNumber.self, forKey: Keys.step.rawValue) as! Float
        let mNumberFormat = coder.decodeObject(of: NSString.self, forKey: Keys.numberFormat.rawValue)! as String
        let mModifiers = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: Keys.modifiers.rawValue) as! [String]
        
        self.init(functype: mFunctype, title: mTitle, itemsQuantity: mItemsQuantity, itemsList: mItemsList, itemRange: mItemRange, itemsMaxToSelect: mItemsMaxToSelect, step: mStep, numberFormat: mNumberFormat, modifiers: mModifiers)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(functype, forKey: Keys.functype.rawValue)
        coder.encode(title, forKey: Keys.title.rawValue)
        coder.encode(itemsQuantity, forKey: Keys.itemsQuantity.rawValue)
        coder.encode(itemsList, forKey: Keys.itemsList.rawValue)
        coder.encode(itemRange, forKey: Keys.itemRange.rawValue)
        coder.encode(itemsMaxToSelect, forKey: Keys.itemsMaxToSelect.rawValue)
        coder.encode(step, forKey: Keys.step.rawValue)
        coder.encode(numberFormat, forKey: Keys.numberFormat.rawValue)
        coder.encode(modifiers, forKey: Keys.modifiers.rawValue)
    }
}

public class RSections: NSObject, NSSecureCoding, Decodable {
    public static var supportsSecureCoding: Bool = true
    
    let name:String
    let dataform:[RSecc]
    
    enum Keys:String {
        case name = "name"
        case dataform = "dataform"
    }
    
    init(name:String, dataform:[RSecc]) {
        self.name = name
        self.dataform = dataform
    }
    
    public required convenience init?(coder: NSCoder) {
        let mName = coder.decodeObject(of: NSString.self, forKey: Keys.name.rawValue)! as String
        let mDataForm = coder.decodeObject(of: [NSArray.self, RSecc.self], forKey: Keys.dataform.rawValue) as! [RSecc]
        
        self.init(name: mName, dataform: mDataForm)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Keys.name.rawValue)
        coder.encode(dataform, forKey: Keys.dataform.rawValue)
    }
}

public class myTest: NSObject, NSSecureCoding, Decodable {
    public static var supportsSecureCoding: Bool = true
    
    var regions:[String]
    var sections:[RSections]
    
    enum Keys:String {
        case regions = "regions"
        case sections = "sections"
    }
    
    init(regions:[String], sections:[RSections]) {
        self.regions = regions
        self.sections = sections
    }
    
    public required convenience init?(coder: NSCoder) {
        let mRegions = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: Keys.regions.rawValue) as! [String]
        let mSections = coder.decodeObject(of: [NSArray.self, RSections.self], forKey: Keys.sections.rawValue) as! [RSections]
        
        self.init(regions: mRegions, sections: mSections)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(regions, forKey: Keys.regions.rawValue)
        coder.encode(sections, forKey: Keys.sections.rawValue)
    }
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
        [Regions.self, Sections.self, myTest.self]
    }
    
    static func register() {
        let className = String(describing: DBAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = DBAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
