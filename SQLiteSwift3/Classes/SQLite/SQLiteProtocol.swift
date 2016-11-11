//
//  SQLiteProtocol.swift
//  Pods
//
//  Created by vip on 16/11/7.
//
//

import Foundation

public protocol SQLiteProtocol {
    
    /// get the object class name
    ///
    /// - Returns: class name
    func objectClassName()->String
    
    func objectFieldName() -> [String:String]
    
    func toDictionary() -> [String:Any]
}

public extension SQLiteProtocol{

    func objectClassName()->String{
        if self is Int {
            return "Int"
        }else{
            return String(cString:object_getClassName(self)).components(separatedBy: ".").last!
        }
        return ""
    }
    func objectType(obj:Any)->String{
        if obj is Int {
            return "Int"
        }else{
            return String(cString:object_getClassName(obj)).components(separatedBy: ".").last!
        }
        return ""
    }
    func objectFieldName() -> [String:String] {
        if self is Int {
            return ["value":"Int"]
        }else{
            var outCount:UInt32 = 0
            let __self = self as! NSObject
            let propertyList = class_copyPropertyList(__self.classForCoder , &outCount)
            var propertyDic = Dictionary<String,String>()
            for index in 0 ..< Int(outCount) {
                let proName = String(cString:property_getName(propertyList![index]))
                let value = __self.value(forKey: proName)!
                
                let type = objectType(obj: value)
                propertyDic[proName] = type
            }
            return propertyDic
        }
        return [:]
    }
    
    func toDictionary() -> [String:Any] {
        if self is Int {
            return ["value":self]
        }else{
            var outCount:UInt32 = 0
            let __self = self as! NSObject
            let propertyList = class_copyPropertyList(__self.classForCoder , &outCount)
            var propertyDic = Dictionary<String,Any>()
            for index in 0 ..< Int(outCount) {
                let proName = String(cString:property_getName(propertyList![index]))
                let value=__self.value(forKey: proName)
                propertyDic[proName] = value
            }
            return propertyDic
        }
        return [:]
    }



}

extension Int : SQLiteProtocol{
    
}
extension String : SQLiteProtocol{
    
}

