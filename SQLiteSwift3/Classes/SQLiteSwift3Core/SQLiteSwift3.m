//
//  SQLiteSwift3.m
//  SQLiteTest
//
//  Created by vip on 16/10/24.
//  Copyright © 2016年 jaki. All rights reserved.
//

#import "SQLiteSwift3.h"
#import <sqlite3.h>

#define SERVICE_NOT_RUNING_TIP_CODE \
NSString * info = [NSString stringWithFormat:@"the SQL DB do not open"];\
LOG_FORMAT(NSStringFromClass(self.class), info);\
return NO;



@interface SQLiteSwift3()
{
    sqlite3 * sqlite;
}
@end

@implementation SQLiteSwift3

- (instancetype)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}

#pragma mark - Public Method

+(SQLiteSwift3 *)openDB:(NSString *)path{
    SQLiteSwift3 * obj = [[self alloc]init];
    [self reOpenDB:obj path:path];
    return obj;
}

-(SQLiteSwift3 *)openDB:(NSString *)path{
    [SQLiteSwift3 reOpenDB:self path:path];
    return self;
    
}

-(BOOL)createTableWithName:(NSString *)name keys:(NSArray<SQLiteKeyObject *> *)keysArray{
    CHECK_BEGIN_REQURIMENT([self serviceRuning])
    if (!keysArray||keysArray.count==0) {
        LOG_FORMAT(NSStringFromClass(self.class), @"you must have field when create table");
        return NO;
    }
    NSString * fieldString = [self arrangementFieldWithArray:keysArray];
    if (!fieldString) {
        return NO;
    }
    NSString * sqlString = [NSString stringWithFormat:@"create table %@(%@)",name,fieldString];
    if ([self runSQL:sqlString]) {
        return YES;
    }else{
        NSString * info = [NSString stringWithFormat:@"the table:%@ had already existent or other error,create failed",name];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    CHECK_END_REQUREMENT(SERVICE_NOT_RUNING_TIP_CODE)
}

-(NSArray<NSString *> *)searchAllTableName{
    CHECK_BEGIN_REQURIMENT([self serviceRuning])
    NSMutableArray * mutableArray = [NSMutableArray array];
    if([self getAllTableNamesWriteTo:mutableArray]){
        return [mutableArray copy];
    }else{
        NSString * info = [NSString stringWithFormat:@"the search of table name fail"];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return nil;
    }
    CHECK_END_REQUREMENT(SERVICE_NOT_RUNING_TIP_CODE)
}

-(BOOL)insertData:(NSDictionary<NSString *,id> *)keyValueDic intoTable:(nonnull NSString *)tableName{
    CHECK_BEGIN_REQURIMENT([self serviceRuning])
    if (!keyValueDic) {
        NSString * info = [NSString stringWithFormat:@"insert data must not nil,in table:%@ failed",tableName];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    NSArray<NSString *> * keyValueArray = [self arrangementKeyValueWithDictionary:keyValueDic];
    if (!keyValueArray||keyValueArray.count!=2) {
        return NO;
    }else{
        NSString * keyString = keyValueArray[0];
        NSString * valueString = keyValueArray[1];
        NSString * sqlString = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",tableName,keyString,valueString];
        if([self runSQL:sqlString]){
            return YES;
        }else{
            NSString * info = [NSString stringWithFormat:@"insert data failed,the table:%@ not existent or other result",tableName];
            LOG_FORMAT(NSStringFromClass(self.class), info);
            return NO;
        }
    }
    CHECK_END_REQUREMENT(SERVICE_NOT_RUNING_TIP_CODE)
}

-(BOOL)addField:(SQLiteKeyObject *)field intoTable:(NSString *)tableName{
    CHECK_BEGIN_REQURIMENT([self serviceRuning])
    if (!field||!tableName) {
        NSString * info = [NSString stringWithFormat:@"add failed,the table must be exis and field not to be nil"];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    NSString * fieldString = [self arrangementFieldWithArray:@[field]];
    NSString * sqlSreing = [NSString stringWithFormat:@"alter table %@ add %@",tableName,fieldString];
    if ([self runSQL:sqlSreing]) {
        return YES;
    }else{
        NSString * info = [NSString stringWithFormat:@"the field had existent or sql invalid in table %@",tableName];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    CHECK_END_REQUREMENT(SERVICE_NOT_RUNING_TIP_CODE)
}

-(BOOL)updateData:(NSDictionary<NSString *,id> *)keyValueDic intoTable:(NSString *)table while:(NSString *)conditionString isSecurity:(BOOL)security{
    CHECK_BEGIN_REQURIMENT([self serviceRuning])
    if (!keyValueDic||!table) {
        NSString * info = [NSString stringWithFormat:@"update data must not be nil in table %@",table];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    NSString * keyValueString = [self formatKeyValueDictionatyToString:keyValueDic];
    NSMutableString * sqlString = [NSMutableString stringWithFormat:@"update %@ set %@",table,keyValueString];
    if (!security) {
        if (conditionString&&!(conditionString.length==0)) {
            [sqlString appendFormat:@" where %@",conditionString];
        }
    }else{
        if (!conditionString||conditionString.length==0) {
            NSString * info = [NSString stringWithFormat:@"update data not have a condition,it's not security, in table %@",table];
            LOG_FORMAT(NSStringFromClass(self.class), info);
            return NO;
        }
        [sqlString appendFormat:@" where %@",conditionString];
    }
    if ([self runSQL:sqlString]) {
        return YES;
    }else{
        NSString * info = [NSString stringWithFormat:@"update data error,condition error or other in table %@",table];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    CHECK_END_REQUREMENT(SERVICE_NOT_RUNING_TIP_CODE)
}

-(BOOL)deleteData:(NSString *)conditionString intoTable:(NSString *)tableName isSecurity:(BOOL)security{
    CHECK_BEGIN_REQURIMENT([self serviceRuning])
    if (!tableName||tableName.length==0) {
        NSString * info = [NSString stringWithFormat:@"delete data must not be nil in table %@",tableName];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    NSMutableString * sqlString = [NSMutableString stringWithFormat:@"delete from %@",tableName];
    if (!security) {
        if (conditionString&&conditionString.length!=0) {
            [sqlString appendFormat:@" where %@",conditionString];
        }
    }else{
        if (!conditionString||conditionString.length==0) {
            NSString * info = [NSString stringWithFormat:@"delete data not have a condition,it's not security, in table %@",tableName];
            LOG_FORMAT(NSStringFromClass(self.class), info);
            return NO;
        }else{
            [sqlString appendFormat:@" where %@",conditionString];
        }
    }
    if ([self runSQL:sqlString]) {
        return YES;
    }else{
        NSString * info = [NSString stringWithFormat:@"delete data error,condition error or other in table %@",tableName];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }
    CHECK_END_REQUREMENT(SERVICE_NOT_RUNING_TIP_CODE)
}

-(BOOL)deleteTable:(NSString *)tableName{
    CHECK_BEGIN_REQURIMENT([self serviceRuning])
    if (!tableName||tableName.length==0) {
        NSString * info = [NSString stringWithFormat:@"delete table must not be nil"];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return NO;
    }else{
        NSString * sqlString = [NSString stringWithFormat:@"drop table %@",tableName];
        if ([self runSQL:sqlString]) {
            return YES;
        }else{
            NSString * info = [NSString stringWithFormat:@"delete table error, table %@",tableName];
            LOG_FORMAT(NSStringFromClass(self.class), info);
            return NO;
        }
    }
    CHECK_END_REQUREMENT(SERVICE_NOT_RUNING_TIP_CODE)
}


-(void)searchDataWithReeuest:(SQLiteSearchRequest *)request inTable:(NSString *)tableName searchFinish:(nullable void (^)(BOOL, NSArray<NSDictionary<NSString *,id> *> * _Nullable))finish{
    if([self serviceRuning]){
        if (!tableName||tableName.length==0||!request) {
            NSString * info = [NSString stringWithFormat:@"search request or table name  must not be nil"];
            LOG_FORMAT(NSStringFromClass(self.class), info);
            if (finish) {
                finish(NO,nil);
            }
            return ;
        }else{
            NSMutableString * sqlString = [[NSMutableString alloc]init];
            [sqlString appendString:@"select"];
            if (!request.fieldArray) {
                [sqlString appendString:@" *"];
            }else{
                if (request.fieldArray.count==0) {
                    if (finish) {
                        finish(YES,nil);
                    }
                    return ;
                }else{
                    [request.fieldArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx==0) {
                            [sqlString appendFormat:@" "];
                        }
                        [sqlString appendFormat:@"%@",obj];
                        if (idx!=request.fieldArray.count-1) {
                            [sqlString appendFormat:@","];
                        }
                    }];
                }
            }
            [sqlString appendFormat:@" from %@",tableName];
            if (request.contidion&&request.contidion.length>0) {
                [sqlString appendFormat:@" where %@",request.contidion];
            }
            if (request.orderByField&&request.orderByField.length>0) {
                if (request.orderType!=OrderTypeNone) {
                    [sqlString appendFormat:@" order by %@ %@",request.orderByField,request.orderTypeString];
                }
            }
            if (request.limit!=LimitDefaultKey) {
                if (request.limit == 0) {
                    if (finish) {
                        finish(YES,nil);
                    }
                    return ;
                }else{
                    [sqlString appendFormat:@" limit %ld",request.limit];
                    if (request.offset>=0) {
                        [sqlString appendFormat:@" offset %ld",request.offset];
                    }
                }
            }
            
            //begin query sql
            NSMutableArray * resultArray = [NSMutableArray array];
            if ([self runQuertSQL:sqlString selectField:request.fieldArray inTable:tableName  writeTo:resultArray]) {
                if (finish) {
                    finish(YES,resultArray);
                }
            }else{
                if (finish) {
                    finish(NO,nil);
                }
                return ;
            }
            
        }
    }else{
        NSString * info = [NSString stringWithFormat:@"the SQL DB do not open"];
        LOG_FORMAT(NSStringFromClass(self.class), info);
        return ;
    }
}

#pragma mark - Private Method

/**
 release the old DB object and create a new.
 
 @param obj SQLiteSwift handler object
 @param path the DataBase path.
 */
+(void)reOpenDB:(SQLiteSwift3 *)obj path:(NSString *)path{
    if (obj->sqlite!=nil) {
        sqlite3_close(obj->sqlite);
        obj->sqlite = nil;
    }
    BOOL exis = [[NSFileManager defaultManager]fileExistsAtPath:path];
    int sqlState = sqlite3_open([path UTF8String], &(obj->sqlite));
    if (sqlState == SQLITE_OK) {
        if (exis) {
            obj.state = openSuccess;
        }else{
            obj.state = createSuccess;
        }
    }else{
        if (exis) {
            obj.state = openFail;
        }else{
            obj.state = createFail;
        }
        sqlite3_close(obj->sqlite);
        obj->sqlite = nil;
    }
}


/**
 run Non Query command of sql.
 
 @param sql sql command String
 
 @return wether success
 */
-(BOOL)runSQL:(NSString *)sql{
    int code = sqlite3_exec(self->sqlite, [sql UTF8String], NULL, NULL, nil);
    if (code!=SQLITE_OK) {
        return NO;
    }else{
        return YES;
    }
}


/**
 run Query command of sql
 
 @param sql         sql command String
 @param resultArray query result array
 
 @return wether success
 */
-(BOOL)runQuertSQL:(NSString *)sql selectField:(NSArray *)selectFieldsArray inTable:(NSString *)tableName writeTo:(NSMutableArray *)resultArray{
    sqlite3_stmt * stmt = nil;
    int code = sqlite3_prepare_v2(self->sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (code!=SQLITE_OK) {
        return NO;
    }else{
        NSArray * allFieldsInfoArray = [self getTheTableAllFieldsType:tableName];
        NSMutableArray * fieldsArray = [NSMutableArray arrayWithArray:selectFieldsArray];
        if (selectFieldsArray==nil) {
            [allFieldsInfoArray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [fieldsArray addObject:obj.allKeys.firstObject];
            }];
        }
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            //base on the type to analytical data
            NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
            for (int i=0; i<fieldsArray.count; i++) {
                __block NSString * typeString = nil;
                [allFieldsInfoArray enumerateObjectsUsingBlock:^(NSDictionary<NSString*,NSString*>*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.allKeys.firstObject isEqualToString:fieldsArray[i]]) {
                        typeString = obj.allValues.firstObject;
                    }
                }];
                if (!typeString) {
                    NSString * info = [NSString stringWithFormat:@"select a error field in:%@",fieldsArray];
                    LOG_FORMAT(NSStringFromClass(self.class), info);
                    return NO;
                }
                if ([typeString isEqualToString:@"smallint"]) {
                    NSNumber * value = [NSNumber numberWithShort:sqlite3_column_int(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"integer"]){
                    NSNumber * value = [NSNumber numberWithInt:sqlite3_column_int(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"real"]){
                    NSNumber * value = [NSNumber numberWithDouble:sqlite3_column_int(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"float"]){
                    NSNumber * value = [NSNumber numberWithFloat:sqlite3_column_double(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"double"]){
                    NSNumber * value = [NSNumber numberWithFloat:sqlite3_column_double(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"currency"]){
                    NSNumber * value = [NSNumber numberWithLong:sqlite3_column_int64(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"varchar"]){
                    char * cString =(char*)sqlite3_column_text(stmt, i);
                    NSString * value = [NSString stringWithCString:cString?cString:"NULL" encoding:NSUTF8StringEncoding];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"text"]){
                    char * cString =(char*)sqlite3_column_text(stmt, i);
                    NSString * value = [NSString stringWithCString:cString?cString:"NULL" encoding:NSUTF8StringEncoding];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"binary"]){
                    int length = sqlite3_column_bytes(stmt, i);
                    const void *data = sqlite3_column_blob(stmt, i);
                    NSData * value = [NSData dataWithBytes:data length:length];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"blob"]){
                    int length = sqlite3_column_bytes(stmt, i);
                    const void *data = sqlite3_column_blob(stmt, i);
                    NSData * value = [NSData dataWithBytes:data length:length];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"boolean"]){
                    NSNumber * value = [NSNumber numberWithInt:sqlite3_column_int(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"date"]){
                    char * cString =(char*)sqlite3_column_text(stmt, i);
                    NSString * value = [NSString stringWithCString:cString?cString:"NULL" encoding:NSUTF8StringEncoding];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"time"]){
                    char * cString =(char*)sqlite3_column_text(stmt, i);
                    NSString * value = [NSString stringWithCString:cString?cString:"NULL" encoding:NSUTF8StringEncoding];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else if ([typeString isEqualToString:@"timestamp"]){
                    NSNumber * value = [NSNumber numberWithLongLong:sqlite3_column_int64(stmt, i)];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }else{
                    char * cString =(char*)sqlite3_column_text(stmt, i);
                    NSString * value = [NSString stringWithCString:cString?cString:"NULL" encoding:NSUTF8StringEncoding];
                    [dataDic setObject:value forKey:fieldsArray[i]];
                }
            }
            [resultArray addObject:dataDic];
        }
        sqlite3_finalize(stmt);
        stmt = nil;
        return YES;
    }
}


/**
 run table name Query command of sql
 
 @param resultArray result
 @return wether success
 */
-(BOOL)getAllTableNamesWriteTo:(NSMutableArray *)resultArray{
    sqlite3_stmt *statement;
    NSString * getTableInfo = @"select * from sqlite_master where type='table' order by name;";
    int result = sqlite3_prepare_v2(sqlite, [getTableInfo UTF8String], -1, &statement, nil);
    if (!result==SQLITE_OK) {
        return NO;
    }
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *nameData = [NSString stringWithUTF8String:sqlite3_column_text(statement, 1)];
        [resultArray addObject:nameData];
    }
    sqlite3_finalize(statement);
    statement = nil;
    return YES;
}


/**
 Organize Field to sql String
 
 @param fieldArray Organize the database table field to sql String
 
 @return the sql string
 */
-(NSString *)arrangementFieldWithArray:(NSArray<SQLiteKeyObject *>*)fieldArray{
    NSMutableString * sqlString = [[NSMutableString alloc]init];
    __block BOOL isSuccess = YES;
    [fieldArray enumerateObjectsUsingBlock:^(SQLiteKeyObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[SQLiteKeyObject class]]) {
            NSString * info = [NSString stringWithFormat:@"the table field must be SQLiteKeyObject : %@",obj];
            LOG_FORMAT(NSStringFromClass(self.class), info);
            isSuccess = NO;
        }
        [sqlString appendString:obj.name];
        [sqlString appendString:[NSString stringWithFormat:@" %@",[obj getFieldType]]];
        if (obj.modificationType!=NO_MODIFICATION) {
            [sqlString appendString:[NSString stringWithFormat:@" %@",[obj getModificationType]]];
            if (obj.modificationType == DEFAULT) {
                if (!obj.condition) {
                    NSString * info = [NSString stringWithFormat:@"the table field must have a default value : %@ %@",obj,obj.name];
                    LOG_FORMAT(NSStringFromClass(self.class), info);
                    isSuccess = NO;
                }else{
                    [sqlString appendString:[NSString stringWithFormat:@" %@",obj.condition]];
                }
            }else if (obj.modificationType == CHECK){
                if (!obj.condition) {
                    NSString * info = [NSString stringWithFormat:@"the table field must have a condition value : %@ %@",obj,obj.name];
                    LOG_FORMAT(NSStringFromClass(self.class), info);
                    isSuccess = NO;
                }else{
                    [sqlString appendString:[NSString stringWithFormat:@"(%@)",obj.condition]];
                }
            }
        }
        if (!(idx == fieldArray.count-1)) {
            [sqlString appendString:@","];
        }
    }];
    if (isSuccess) {
        return sqlString;
    }else{
        return nil;
    }
}


/**
 Organize insert field as String  exam:@["key,key,key"] @["value","value","value"]
 
 @param keyValueDic key-value dictionary
 
 @return a array contain Key String and Value String
 */
-(NSArray<NSString *> *)arrangementKeyValueWithDictionary:(NSDictionary<NSString *,id> *)keyValueDic{
    NSArray<NSString *> * keyArray = keyValueDic.allKeys;
    NSMutableString * keyString = [[NSMutableString alloc]init];
    NSMutableString * valueString = [[NSMutableString alloc]init];
    [keyArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [keyString appendString:obj];
        if ([[keyValueDic objectForKey:obj] isKindOfClass:[NSString class]]) {
            [valueString appendFormat:@"\"%@\"",[keyValueDic objectForKey:obj]];
        }else{
            [valueString appendFormat:@"%@",[keyValueDic objectForKey:obj]];
        }
        if (idx!=keyArray.count-1) {
            [keyString appendString:@","];
            [valueString appendString:@","];
        }
    }];
    return @[keyString,valueString];
}


/**
 format the dictionary to String exam:@"key=value,key=value"
 
 @param keyValueDic key-value dictionary
 
 @return format String
 */
-(NSString *)formatKeyValueDictionatyToString:(NSDictionary *)keyValueDic{
    NSMutableString * formatString = [[NSMutableString alloc]init];
    [keyValueDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (formatString.length!=0) {
            [formatString appendString:@","];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [formatString appendFormat:@"%@=\"%@\"",key,obj];
        }else{
            [formatString appendFormat:@"%@=%@",key,obj];
            
        }
        
    }];
    return formatString;
}


/**
 get all fields info
 
 @param tableName table name
 
 @return fields info array fieldName:fieldType
 */
-(NSArray<NSDictionary *> *)getTheTableAllFieldsType:(NSString *)tableName{
    if (!tableName||tableName.length==0) {
        return nil;
    }
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSString * getColumn = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(self->sqlite, [getColumn UTF8String], -1, &statement, nil);
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char *nameData = (char *)sqlite3_column_text(statement, 1);
        NSString *columnName = [[NSString alloc] initWithUTF8String:nameData];
        char *typeData = (char *)sqlite3_column_text(statement, 2);
        //trans to lowercase string
        NSString *columntype = [[NSString stringWithCString:typeData encoding:NSUTF8StringEncoding] lowercaseString];
        NSDictionary * dic = @{columnName:columntype};
        [array addObject:dic];
    }
    sqlite3_finalize(statement);
    statement=nil;
    return array;
}


/**
 get the SQLite DataBase whether Open
 
 @return whether open Success
 */
-(BOOL)serviceRuning{
    return self->sqlite?YES:NO;
}

@end
