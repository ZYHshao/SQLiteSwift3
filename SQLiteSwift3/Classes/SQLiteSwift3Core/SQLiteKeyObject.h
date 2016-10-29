//
//  SQLiteKeyObject.h
//  SQLiteTest
//
//  Created by vip on 16/10/24.
//  Copyright © 2016年 jaki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SMALLINT,
    INTEGER,
    REAL,
    FLOAT,
    DOUBLE,
    CURRENCY,
    VARCHAR,
    TEXT,
    BINARY,
    BLOB,
    BOOLEAN,
    DATE,
    TIME,
    TIMESTAMP
}SQLiteFieldType;

typedef enum {
    NO_MODIFICATION,
    PRIMARY_KEY,
    NOT_NULL,
    UNIQUE,
    DEFAULT,
    CHECK
}SQLiteModificationType;

@interface SQLiteKeyObject : NSObject

/**
    field name 
 */
@property(nonatomic,strong,nonnull)NSString * name;

/**
    field type default Text
 */
@property(nonatomic,assign)SQLiteFieldType fieldType;


/**
    modification type
 */
@property(nonatomic,assign)SQLiteModificationType modificationType;


/**
    if the modificationType is DEFAULT, this field should be a NSString as default value
    if the modificationType is CHECK ,this field should be a NSString as check condition
 */
@property(nonatomic,strong,nullable)NSString * condition;


/**
    the text type size.Default is 10
 */
@property(nonatomic,assign)NSInteger tSize;

/**
    get the field type as NSString

 @return type String
 */
-(nullable NSString *)getFieldType;


/**
    get the modification type as NSString

 @return type String
 */
-(nullable NSString *)getModificationType;



@end
