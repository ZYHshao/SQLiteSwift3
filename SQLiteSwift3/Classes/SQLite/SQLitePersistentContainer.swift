//
//  SQLitePersistentContainer.swift
//  Pods
//
//  Created by vip on 16/11/7.
//
//

import UIKit

func printError(_ error:String){
    print("SQLiteSwift3======LOG=======\nSQLitePersistentContainer:%@",error)
}

class SQLitePersistentContainer: NSObject {
    
    var sqlHandle:SQLiteSwift3?
    let sqlRootTableName = "jaki_sqlite_root"
    override init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/SQLiteSwift3_base_v1.sqlite"
        print(file)
        sqlHandle = SQLiteSwift3.openDB(file)
    }
    
    
    /// save the data,and association user key with class name. user can use key to found
    /// the all had saved class data
    ///
    /// - Parameters:
    ///   - object: must be SQLiteProtocol data
    ///   - key: user key
    /// - Returns:Whether successful
    func saveObject(_ object:SQLiteProtocol, key:String) -> Bool {
        if !checkExistRootTable() {
             self.createRootTable()
        }
        let result =  sqlHandle?.insertData([rootTableObjectName:object.objectClassName(),rootTableUserKey:key], intoTable: sqlRootTableName)
        if result != nil && !result!  {
            printError("save object key \(key) in root table , it have exit or fail")
        }else{
            //save data
            
        }
        return true
    }
    
    
    
//MARK:private Method
    let rootTableObjectName = "objectName"
    let rootTableUserKey = "userKey"

    
    /// create root table,this table record user access key-value
    func createRootTable(){
        if sqlHandle != nil {
            let sqlObjectKey = SQLiteKeyObject()
            sqlObjectKey.name = rootTableObjectName
            sqlObjectKey.fieldType = TEXT
            sqlObjectKey.tSize = 30
            let sqlUserKey = SQLiteKeyObject()
            sqlUserKey.name = rootTableUserKey
            sqlUserKey.fieldType = TEXT
            sqlUserKey.modificationType = UNIQUE
            sqlUserKey.tSize = 30
            if(!sqlHandle!.createTable(withName: sqlRootTableName, keys: [sqlObjectKey,sqlUserKey])){
                printError("the root table have exist or create fail")
            }
        }
    }
    
    /// check the root table if exist
    ///
    /// - Returns: check result
    func checkExistRootTable() ->Bool {
        let names = sqlHandle?.searchAllTableName()
        var exist = false
        names?.forEach(){ (elment) in
            if elment == sqlRootTableName {
                exist = true
            }
        }
        return exist
    }
}
