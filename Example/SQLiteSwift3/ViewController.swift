//
//  ViewController.swift
//  SQLiteTest
//
//  Created by vip on 16/10/24.
//  Copyright © 2016年 jaki. All rights reserved.
//

import UIKit
import SQLiteSwift3

class ViewController: UIViewController {

    var sqliteHander:SQLiteSwift3?
    
    override func viewDidLoad() {
        let obj = SQLiteObject()
    }
    
    
    
    func testOBJSave()  {
        
    }
    
    func testGetTableName()  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        print(file)
        sqliteHander = SQLiteSwift3.openDB(file)
        print(sqliteHander!.searchAllTableName())
        
    }
    
    func testSelect()  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        sqliteHander = SQLiteSwift3.openDB(file)
        let request = SQLiteSearchRequest()
        request.fieldArray = ["name","number"]
        request.orderByField = "count"
        request.orderType = OrderTypeDesc
        request.contidion = "count>50"
        request.limit = 2
        request.offset = 1
        sqliteHander?.searchData(withReeuest: request, inTable: "cschool", searchFinish: { (success, result) in
            print(success)
            print(result)
        })
    }
    
    func testDeleteTable()  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        sqliteHander = SQLiteSwift3.openDB(file)
        print(sqliteHander?.deleteTable("school"))
    }
    
    func testDelete()  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        sqliteHander = SQLiteSwift3.openDB(file)
        print(sqliteHander?.deleteData("", intoTable: "cschool", isSecurity: false))
    }
    
    func testUpdateData(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        sqliteHander = SQLiteSwift3.openDB(file)
        print(sqliteHander?.updateData(["name":"new Class","count":"50"], intoTable: "cschool", while: "count=100", isSecurity: true))
    }
    
    func testAddField(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        sqliteHander = SQLiteSwift3.openDB(file)
        print(file)
        let field = SQLiteKeyObject()
        field.name = "newField2"
        field.fieldType = TEXT
        field.modificationType = DEFAULT
        field.condition = "default"
        
        let field2 = SQLiteKeyObject()
        field2.name = "newField4"
        field2.fieldType = TEXT;
        field2.modificationType = DEFAULT
        field2.condition = "5"
        field2.tSize = 15;
        print(sqliteHander?.addField(field2, intoTable: "school"))
    }

    func testInsert()  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        sqliteHander = SQLiteSwift3.openDB(file)
        print(file)
        print(sqliteHander?.insertData(["number":NSNumber(value: 1),"name":"新的班级","count":100], intoTable: "cschool"))
    }
    
    func testCreateTable() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        sqliteHander = SQLiteSwift3.openDB(file)
        let key1 = SQLiteKeyObject()
        key1.name = "number"
        key1.fieldType = INTEGER
        key1.modificationType = PRIMARY_KEY
        
        let key2 = SQLiteKeyObject()
        key2.name = "name"
        key2.fieldType = INTEGER
        key2.modificationType = DEFAULT
        key2.condition = "111"
        
        let key3 = SQLiteKeyObject()
        key3.name = "count"
        key3.fieldType = INTEGER
        key3.modificationType=CHECK
        key3.condition="count>30"
        print(sqliteHander?.createTable(withName: "chool", keys: [key1,key2,key3]))
    }

    
    func testCreateDB(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        print(file)
        sqliteHander = SQLiteSwift3.openDB(file)
        print("==============\(sqliteHander?.state)")
    }
    
    func testOpenDB() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/newDataBase.sqlite"
        print(file)
        sqliteHander = SQLiteSwift3.openDB(file)
        print("==============\(sqliteHander?.state)")
    }
    
    func testReopen()  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = path! + "/DataBase.sqlite"
        print(file)
        sqliteHander = SQLiteSwift3.openDB(file)
        print("==============\(sqliteHander?.state)")
    }

}

