//
//  StringExtension.swift
//  Pavefs
//


import Foundation

extension String
{
    func localized(lang:String) ->String
    {
        
        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
}