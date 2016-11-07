//
//  SQLiteProtocol.swift
//  Pods
//
//  Created by vip on 16/11/7.
//
//

import Foundation

protocol SQLiteProtocol {
    func objectClassName()->String
}

extension SQLiteProtocol{
    func objectClassName()->String{
       return String(cString:object_getClassName(self))
    }

}

extension Int : SQLiteProtocol{
    
}
