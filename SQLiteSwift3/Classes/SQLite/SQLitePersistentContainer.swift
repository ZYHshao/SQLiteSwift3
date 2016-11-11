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

public class SQLitePersistentContainer: NSObject {
    
    var sqlHandle:SQLiteSwift3?
    let sqlRootTableName = "jaki_sqlite_root"
    public override init() {
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
    public func saveObject(_ object:SQLiteProtocol, key:String) -> Bool {
        if !checkExistRootTable() {
             self.createRootTable()
        }
        let result =  sqlHandle?.insertData([rootTableObjectName:object.objectClassName(),rootTableUserKey:key], intoTable: sqlRootTableName)
            //save data
        self.saveData(data: object)
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
        return checkExisNormalTable(tableName: sqlRootTableName)
    }
    
    func checkExisNormalTable(tableName:String) -> Bool {
        let names = sqlHandle?.searchAllTableName()
        var exist = false
        names?.forEach(){ (elment) in
            if elment == tableName {
                exist = true
            }
        }
        return exist
    }
    
    func saveData(data:SQLiteProtocol) -> Bool {
        //create table
        let className = data.objectClassName()
        if !checkExisNormalTable(tableName: className) {
            self.createTable(data: data)
        }
        sqlHandle?.insertData(data.toDictionary(), intoTable: className)
        
        return true
    }
    
    let NoneINOUT_KEY = "jaki_NoneINOUT_KEY"
    func createTable(data:SQLiteProtocol){
        if sqlHandle != nil {
            var keyArray = Array<SQLiteKeyObject>()
            let Key1 = SQLiteKeyObject()
            Key1.name = "innerKey"
            Key1.fieldType = INTEGER
            Key1.modificationType = PRIMARY_KEY
            let Key2 = SQLiteKeyObject()
            Key2.name = "outerKeys"
            Key2.fieldType = INTEGER
            let Key3 = SQLiteKeyObject()
            Key3.name = "outerNames"
            Key3.fieldType = TEXT
            Key3.modificationType = DEFAULT
            Key3.condition = NoneINOUT_KEY
            Key3.tSize = 30
            let Key4 = SQLiteKeyObject()
            Key4.name = "innerName"
            Key4.fieldType = TEXT
            Key4.modificationType = DEFAULT
            Key4.condition = NoneINOUT_KEY
            Key4.tSize = 30
            keyArray.append(Key1)
            keyArray.append(Key2)
            keyArray.append(Key3)
            keyArray.append(Key4)
            for field in data.objectFieldName() {
                let Key = SQLiteKeyObject()
                Key.name = field.key
                Key.fieldType = getFieldSqlType(type: field.value)
                keyArray.append(Key)
            }
            if(!sqlHandle!.createTable(withName: data.objectClassName(), keys:keyArray)){
                printError("the \(data.objectClassName()) table have exist or create fail")
            }
        }
    }
    func getFieldSqlType(type:String) -> SQLiteFieldType {
        switch type {
        case "Int":
            return INTEGER
        case "String":
            return TEXT
        default:
            return TEXT
            break
        }
    }
}
