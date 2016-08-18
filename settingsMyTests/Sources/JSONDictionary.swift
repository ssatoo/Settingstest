//
//  JSONDictionary.swift
//  JSONParser
//
//  Created by Anthony Levings on 23/03/2015.
//

import Foundation

public struct JSONDictionary:SequenceType {
    // set restrictions
    //TODO: make restrictions work for nest dictionaries when changed after initialization
    public var inheritRestrictions = true
    public var restrictTypeChanges:Bool
    public var anyValueIsNullable:Bool
    
    private var i = 0
    private lazy var dictionaryKeys:[String] = self.keys
    
    private var stringDict:Dictionary<String,String>?
    private var numDict:Dictionary<String,NSNumber>?
    private var boolDict:Dictionary<String,Bool>?
    private var nullDict:Dictionary<String,NSNull>?
    
    private var dictDict:Dictionary<String,JSONDictionary>?
    private var arrayDict:Dictionary<String,JSONArray>?
    public var dictionary:Dictionary<String,AnyObject> {
        var dictionary = Dictionary<String,AnyObject>()
        
        
        if let sD = stringDict  {
            for (k,v) in sD {
                dictionary[k] = v
            }
        }
        if let nD = numDict {
            for (k,v) in nD {
                dictionary[k] = v
            }
        }
        
        if let bD = boolDict {
            for (k,v) in bD {
                dictionary[k] = v
            }
        }
        
        if let nuD = nullDict {
            for (k,v) in nuD {
                dictionary[k] = v
            }
        }
        
        
        if let dD = dictDict {
            for (k,v) in dD {
                dictionary[k] = v.dictionary as AnyObject
                
            }
        }
        if let aD = arrayDict {
            for (k,v) in aD {
                dictionary[k] = v.array as AnyObject
                
            }
        }
        return dictionary
    }
    public var nsDictionary:NSDictionary {
        let dictionary = NSMutableDictionary()
        
        
        if let sD = stringDict  {
            for (k,v) in sD {
                dictionary[k] = v as NSString
            }
        }
        if let nD = numDict {
            for (k,v) in nD {
                dictionary[k] = v as NSNumber
            }
        }
        if let nD = boolDict {
            for (k,v) in nD {
                dictionary[k] = v as Bool
            }
        }
        if let nuD = nullDict {
            for (k,v) in nuD {
                dictionary[k] = v as NSNull
            }
        }
        if let dD = dictDict {
            for (k,v) in dD {
                dictionary[k] = v.nsDictionary as NSDictionary
                
            }
        }
        if let aD = arrayDict {
            for (k,v) in aD {
                dictionary[k] = v.nsArray as NSArray
            }
        }
        return dictionary
    }
    
    
    public init (restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) {
        self.anyValueIsNullable = anyValueIsNullable
        self.restrictTypeChanges = restrictTypeChanges
        
    }
    public init (dict:Dictionary<String,AnyObject>, handleBool:Bool = true, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) {
        self.anyValueIsNullable = anyValueIsNullable
        self.restrictTypeChanges = restrictTypeChanges
        // AJL: replace with map?
        for (k,v) in dict {
            if let v = v as? String {
                if stringDict == nil {
                    stringDict = Dictionary<String,String>()
                }
                if stringDict != nil {
                    stringDict![k] = v
                }
            }
            else if let v = v as? NSNumber  {
                // test to see if a bool
                if handleBool && v.isBoolNumber()  {
                    if boolDict == nil {
                        boolDict = Dictionary<String,Bool>()
                    }
                    if boolDict != nil {
                        boolDict![k] = Bool(v)
                    }
                }
                else {
                if numDict == nil {
                    numDict = Dictionary<String,NSNumber>()
                }
                if numDict != nil {
                    numDict![k] = v
                    
                    }
                }
            }
            
                
                
            else if let v = v as? NSNull {
                if nullDict == nil {
                    nullDict = Dictionary<String,NSNull>()
                }
                if nullDict != nil {
                    nullDict![k] = v
                }
            }
                
            else if let v = v as? Dictionary<String, AnyObject> {
                if dictDict == nil {
                    dictDict = Dictionary<String,JSONDictionary>()
                }
                if dictDict != nil {
                    dictDict![k] = JSONDictionary(dict: v, handleBool:handleBool, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable)
                }
            }
            else if let v = v as? [AnyObject] {
                if arrayDict == nil {
                    arrayDict = Dictionary<String,JSONArray>()
                }
                if arrayDict != nil {
                    arrayDict![k] = JSONArray(array: v, handleBool:handleBool, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable)
                }
                
            }
        }
        
    }
    
  
    
    
    
}

extension JSONDictionary {
    public subscript (key:String) -> String? {
        get {
            return stringDict?[key]
        }
        set(newValue) {
            if stringDict?[key] != nil {
                stringDict?[key] = newValue
            }
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if stringDict == nil {
                    stringDict = Dictionary<String,String>()
                }
                stringDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                // if a string dictionary doesn't already exist, it will be created before the key and value is added (same for each type)
                if stringDict == nil {
                    stringDict = Dictionary<String,String>()
                }
                if stringDict != nil {
                    stringDict?[key] = newValue
                }
            }
                
                
                // the JSONArray type uses nil as an indicator of emptiness, so if the final value/key is removed then the dictionary should reset to nil
            else if restrictTypeChanges == false {
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // because nil is an indicator of emptiness, it might be the case that no stringDict exists, and so it must be created if this is the case
                if stringDict == nil {
                    stringDict = Dictionary<String,String>()
                }
                stringDict?[key] = newValue
            }
        }
    }
    
    
    public subscript (key:String) -> NSNumber? {
        get {
            return numDict?[key]
        }
        set(newValue) {
            if numDict?[key] != nil {
                numDict?[key] = newValue
            }
                
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if numDict == nil {
                    numDict = Dictionary<String,NSNumber>()
                }
                numDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if numDict == nil {
                    numDict = Dictionary<String,NSNumber>()
                }
                if numDict != nil {
                    numDict?[key] = newValue
                }
            }
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                boolDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // because nil is an indicator of emptiness, it might be the case that no stringDict exists, and so it must be created if this is the case
                if numDict == nil {
                    numDict = Dictionary<String,NSNumber>()
                }
                numDict?[key] = newValue
            }
            
        }
    }
    
    public subscript (key:String) -> Bool? {
        get {
            return boolDict?[key]
        }
        set(newValue) {
            if boolDict?[key] != nil {
                boolDict?[key] = newValue
            }
                
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if boolDict == nil {
                    boolDict = Dictionary<String,Bool>()
                }
                boolDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if boolDict == nil {
                    boolDict = Dictionary<String,Bool>()
                }
                if boolDict != nil {
                    boolDict?[key] = newValue
                }
            }
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // because nil is an indicator of emptiness, it might be the case that no stringDict exists, and so it must be created if this is the case
                if boolDict == nil {
                    boolDict = Dictionary<String,Bool>()
                }
                boolDict?[key] = newValue
            }
            
        }
    }
    
    public subscript (key:String) -> NSNull? {
        get {
            return nullDict?[key]
        }
        set(newValue) {
            if nullDict?[key] != nil {
                nullDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if nullDict == nil {
                    nullDict = Dictionary<String,NSNull>()
                }
                if nullDict != nil {
                    nullDict?[key] = newValue
                }
            }
                
            else if anyValueIsNullable == true {
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                boolDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                if nullDict == nil {
                    nullDict = Dictionary<String,NSNull>()
                }
                nullDict?[key] = newValue
            }
            
        }
    }
    
    public subscript (key:String) -> JSONDictionary? {
        get {
            var dictD = self.dictDict?[key]
            
            if inheritRestrictions == true {
                dictD?.restrictTypeChanges = self.restrictTypeChanges
                dictD?.anyValueIsNullable = self.anyValueIsNullable
            }
            
            return dictD
        }
        set(newValue) {
            if dictDict?[key] != nil {
                dictDict?[key] = newValue
            }
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if dictDict == nil {
                    dictDict = Dictionary<String,JSONDictionary>()
                }
                dictDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if dictDict == nil {
                    dictDict = Dictionary<String,JSONDictionary>()
                }
                if dictDict != nil {
                    dictDict?[key] = newValue
                }
            }
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                boolDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                // because nil is an indicator of emptiness, it might be the case that no stringDict exists, and so it must be created if this is the case
                if dictDict == nil {
                    dictDict = Dictionary<String,JSONDictionary>()
                }
                dictDict?[key] = newValue
            }
            
            
        }
    }
    
    
    public subscript (key:String) -> JSONArray? {
        get {
            var arrayD = self.arrayDict?[key]
            
            if inheritRestrictions == true {
                arrayD?.restrictTypeChanges = self.restrictTypeChanges
                arrayD?.anyValueIsNullable = self.anyValueIsNullable
            }
            
            return arrayD
        }
        set(newValue) {
            if arrayDict?[key] != nil {
                arrayDict?[key] = newValue
            }
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if arrayDict == nil {
                    arrayDict = Dictionary<String,JSONArray>()
                }
                arrayDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if arrayDict == nil {
                    arrayDict = Dictionary<String,JSONArray>()
                }
                arrayDict?[key] = newValue
                
                
            }
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                numDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                boolDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // because nil is an indicator of emptiness, it might be the case that no stringDict exists, and so it must be created if this is the case
                if arrayDict == nil {
                    arrayDict = Dictionary<String,JSONArray>()
                }
                arrayDict?[key] = newValue
            }
            
        }
    }
    
    
    public subscript (key:String) -> Value? {
        get {
            
            if let a = stringDict?[key] {
                return Value(a)
            }
                
            else if let a = numDict?[key] {
                return Value(num:a)
            }
                
            else if let a = boolDict?[key] {
                return Value(bool:a)
            }
                
            else if let a = nullDict?[key] {
                return Value(a)
            }
                
            else if let a = dictDict?[key] {
                return Value(a)
            }
            else if let a = arrayDict?[key] {
                return Value(a)
            }
            
            
            return nil
        }
        
    }
    
}

// accessing keys and keys for types
extension JSONDictionary {
    // retrieve keys from dictionaries (all or based on Type)
    public var keys:[String] {
        var keys = [String]()
        if stringDict != nil {
            keys.appendContentsOf(stringDict!.keys)
        }
        if numDict != nil {
            keys.appendContentsOf(numDict!.keys)
        }
        
        if boolDict != nil {
            keys.appendContentsOf(boolDict!.keys)
        }
        if nullDict != nil {
            keys.appendContentsOf(nullDict!.keys)
        }
        
        if dictDict != nil {
            keys.appendContentsOf(dictDict!.keys)
        }
        if arrayDict != nil {
            keys.appendContentsOf(arrayDict!.keys)
        }
        
        return keys
    }
    public var keysWithStringValues:[String]? {
        if stringDict != nil {
            let keys = (stringDict!).map{k,v in k}
            return keys
        }
        return nil
    }
    public var keysWithNumberValues:[String]? {
        if numDict != nil {
            let keys = (numDict!).map{k,v in k}
            return keys
        }
        return nil
    }
    public var keysWithBoolValues:[String]? {
        if boolDict != nil {
            let keys = (boolDict!).map{k,v in k}
            return keys
        }
        return nil
    }
    public var keysWithNullValues:[String]? {
        if nullDict != nil {
            let keys = (nullDict!).map{k,v in k}
            return keys
        }
        return nil
    }
    public var keysWithArrayValues:[String]? {
        if arrayDict != nil {
            let keys = (arrayDict!).map{k,v in k}
            return keys
        }
        return nil
    }
    public var keysWithDictionaryValues:[String]? {
        if dictDict != nil {
            let keys = (dictDict!).map{k,v in k}
            return keys
        }
        return nil
    }
    
}

// add methods for dictionary, avoid accidental additions
extension JSONDictionary {
    
    func nonExistentKey(key:String) -> Bool {
        if stringDict?[key] == nil && numDict?[key] == nil && nullDict?[key] == nil && arrayDict?[key] == nil && dictDict?[key] == nil {
            return true
        }
        return false
    }
    
}

// JSON conform to SequenceType
extension JSONDictionary {
    public typealias Generator = JSONDictionaryGenerator
    public func generate() -> Generator {
        // AJL: avoid strong capture of self?
        let gen = Generator(dict: self)
        return gen
    }
}
// return JSON data
extension JSONDictionary {
    public func jsonData(options:NSJSONWritingOptions = []) throws -> NSData {
        return try NSJSONSerialization.dataWithJSONObject(self.dictionary, options: options)
    }
    public func stringify(options:NSJSONWritingOptions = []) throws -> String {
        let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let data = try NSJSONSerialization.dataWithJSONObject(self.dictionary, options: options)
        let count = data.length / sizeof(UInt8)
            
        // create array of appropriate length:
        var array = [UInt8](count: count, repeatedValue: 0)
            
        // copy bytes into array
        data.getBytes(&array, length:count * sizeof(UInt8))
            
            
        if let value = String(bytes: array, encoding: NSUTF8StringEncoding) {
            return value
        }
        throw error
    }
    
   }

// generator
extension JSONDictionary {
    
    typealias Element = Value
    mutating func next() -> Element? {
        
        let k = dictionaryKeys[i]
        if let v = stringDict?[k] {
            i += 1
            return Value(v)
        }
        else if let v = numDict?[k] {
            i += 1
            return Value(num:v)
        }
        else if let v = boolDict?[k] {
            i += 1
            return Value(bool:v)
        }
        else if let v = nullDict?[k] {
           i += 1
            return Value(v)
        }
        else if let v = dictDict?[k] {
           i += 1
            return Value(v)
        }
        else if let v = arrayDict?[k] {
           i += 1
            return Value(v)
        }
        
        // reset value
        i = 0
        return nil
    }
    
}

// JSONDictionary Generator
public struct JSONDictionaryGenerator:GeneratorType {
    public var restrictTypeChanges:Bool
    // use dictionary with index as keys for position in array
    private let dict:JSONDictionary
    private let keys:[String]
    private var i:Int
    
    
    
    public init(dict:JSONDictionary, restrictTypeChanges:Bool = true) {
        self.restrictTypeChanges = restrictTypeChanges
        self.dict = dict
        self.keys = dict.keys
        self.i = 0
    }
    
    mutating public func next() -> (String,Value?)? {
        if i < keys.count {
            let key = keys[i]
            // crashing here when doing regEx search and replace strings
            if let v:Value? = dict[key] {
               i += 1
                return (key, v)
            }
            else {
                return nil
            }
        }
        // reset value
        i = 0
        return nil
    }
}