//
//  SQLiteSwift3.h
//  SQLiteTest
//
//  Created by vip on 16/10/24.
//  Copyright © 2016年 jaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteKeyObject.h"
#import "SQLIteSwift3Header.h"
#import "SQLiteSearchRequest.h"
typedef enum {
    //open DataBase Succsee
    openSuccess,
    //the file existence but not have the premission or other error
    openFail,
    //the file not existence , create a new DataBase Success.
    createSuccess,
    //the file not existence and create file error
    createFail
}SQLiteSwift3State;

@interface SQLiteSwift3 : NSObject

/*
  tip :
        Do not use the init: or new: Method to instantiation this Class，use openDB to
        get a SQLiteSwift3 Object
 */

/**
    open a SQLite DataBase,if the DB Non-existent , will creat A SQLiteDB in the Path，if
    create fail，the SQLiteSwiftSate will be createFail.

 @param path location DataBasePath

 @return the self Object
 */
+(nonnull SQLiteSwift3 *)openDB:(nullable NSString*)path;


/**
    instance method to open a SQLite Database. if the instance had open a DB,the old DB will be closed.After operation will be the role of the new DataBase.

 @param path location DataBasePath

 @return self
 */
-(nonnull SQLiteSwift3 *)openDB:(nullable NSString*)path;


/**
    create a table in current SQL DataBase,if the table had existent or create fail,will return NO.

 @param name      create table's name
 @param keysArray table's fields

 @return result of the create operation
 */
-(BOOL)createTableWithName:(nullable NSString *)name keys:(nullable NSArray<SQLiteKeyObject *>*)keysArray;


/**
    query all table names in current SQL

 @return all table names
 */
-(nullable NSArray<NSString *> *)searchAllTableName;


/**
    insert a data into table.The keyValueDic should contain key-value info about what you want to setting the data.
    tip: the number type,timestamptype should uss NSNumber ,text should uss NSSting 
        other type current not supportrd in this method.

 @param keyValueDic key-value dictionary
 @param tableName   table name

 @return result of the insert operation
 */
-(BOOL)insertData:(nonnull NSDictionary<NSString*,id> *)keyValueDic intoTable:(nonnull NSString *)tableName;


/**
    add a field to the table.

 @param field     field object
 @param tableName table name

 @return result of the add operaton
 */
-(BOOL)addField:(nonnull SQLiteKeyObject *)field intoTable:(nonnull NSString *)tableName;


/**
    Update data,the security field is vary important,if set it to YES,when the 
    conditionString is nil or invalid,this update operation will not perform. 
    If set it to NO,when the condition Stirng is nil or invalid,will update all datas.

 @param keyValueDic     key-value dictionary
 @param table           table name
 @param conditionString condition
 @param security        security field

 @return result of the update operation
 */
-(BOOL)updateData:(nonnull NSDictionary<NSString*,id> *)keyValueDic intoTable:(nonnull NSString *)table while:(nullable NSString *)conditionString isSecurity:(BOOL)security;



/**
    delete datas with condition. If the security field set to YES,when the 
    conditionString is nil or "",this delete will be fail,else if the security 
    field set to NO,it's will delete all data.

 @param conditionString condition string
 @param tableName       table name
 @param security        security field

 @return result of the delete operation
 */
-(BOOL)deleteData:(nonnull NSString *)conditionString intoTable:(nonnull NSString*)tableName isSecurity:(BOOL)security;


/**
    delete a table

 @param tableName table name

 @return result of the delete operation
 */
-(BOOL)deleteTable:(nonnull NSString *)tableName;


/**
    select data with field.

 @param request   search request
 @param tableName table name
 @finish block of handle the result

 */
-(void)searchDataWithReeuest:(nonnull SQLiteSearchRequest *)request inTable:(nonnull NSString *)tableName searchFinish:(nullable void(^)(BOOL success, NSArray<NSDictionary<NSString * ,id> *>* _Nullable resultArray))finish;


@property(nonatomic,assign)SQLiteSwift3State state;

@end
