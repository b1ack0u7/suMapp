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
    @Published var sections:[Sections] = []
}

public class SectionsDataForm: NSObject, NSSecureCoding, Decodable {
    public static var supportsSecureCoding: Bool = true
    
    let functype:String
    let title:String
    let itemsQuantity:Int?
    let itemsList:[String]?
    let itemRange:[Double]?
    let itemsMaxToSelect:Int?
    let step:Double?
    let numberFormat:String?
    let modifiers:[String]
    
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
    
    init(functype:String, title:String, itemsQuantity:Int, itemsList:[String], itemRange:[Double], itemsMaxToSelect:Int, step:Double, numberFormat:String, modifiers:[String]) {
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
        let mItemsQuantity = coder.decodeObject(of: NSNumber.self, forKey: Keys.itemsQuantity.rawValue) ?? 0
        let mItemsList = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: Keys.itemsList.rawValue) ?? [""]
        let mItemRange = coder.decodeObject(of: [NSArray.self, NSNumber.self], forKey: Keys.itemRange.rawValue) ?? [0.0,0.0]
        let mItemsMaxToSelect = coder.decodeObject(of: NSNumber.self, forKey: Keys.itemsMaxToSelect.rawValue) ?? 1
        let mStep = coder.decodeObject(of: NSNumber.self, forKey: Keys.step.rawValue) ?? 0
        let mNumberFormat = coder.decodeObject(of: NSString.self, forKey: Keys.numberFormat.rawValue) ?? "%.0f"
        let mModifiers = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: Keys.modifiers.rawValue) ?? ["#None"]
        
        self.init(functype: mFunctype, title: mTitle, itemsQuantity: mItemsQuantity as! Int, itemsList: mItemsList as! [String], itemRange: mItemRange as! [Double], itemsMaxToSelect: mItemsMaxToSelect as! Int, step: mStep as! Double, numberFormat: mNumberFormat as String, modifiers: mModifiers as! [String])
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

public class Sections: NSObject, NSSecureCoding, Decodable {
    public static var supportsSecureCoding: Bool = true
    
    let name:String
    let dataform:[SectionsDataForm]
    
    enum Keys:String {
        case name = "name"
        case dataform = "dataform"
    }
    
    init(name:String, dataform:[SectionsDataForm]) {
        self.name = name
        self.dataform = dataform
    }
    
    public required convenience init?(coder: NSCoder) {
        let mName = coder.decodeObject(of: NSString.self, forKey: Keys.name.rawValue)! as String
        let mDataForm = coder.decodeObject(of: [NSArray.self, SectionsDataForm.self], forKey: Keys.dataform.rawValue) as! [SectionsDataForm]
        
        self.init(name: mName, dataform: mDataForm)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Keys.name.rawValue)
        coder.encode(dataform, forKey: Keys.dataform.rawValue)
    }
}

public class Cforms: NSObject, NSSecureCoding, Decodable {
    public static var supportsSecureCoding: Bool = true
    
    var regions:[String]
    var sections:[Sections]
    
    enum Keys:String {
        case regions = "regions"
        case sections = "sections"
    }
    
    init(regions:[String], sections:[Sections]) {
        self.regions = regions
        self.sections = sections
    }
    
    public required convenience init?(coder: NSCoder) {
        let mRegions = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: Keys.regions.rawValue) as! [String]
        let mSections = coder.decodeObject(of: [NSArray.self, Sections.self], forKey: Keys.sections.rawValue) as! [Sections]
        
        self.init(regions: mRegions, sections: mSections)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(regions, forKey: Keys.regions.rawValue)
        coder.encode(sections, forKey: Keys.sections.rawValue)
    }
}

class DBAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [Cforms.self]
    }
    
    static func register() {
        let className = String(describing: DBAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = DBAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
