//
//  SQLiteSearchRequest.h
//  SQLiteTest
//
//  Created by vip on 16/10/28.
//  Copyright © 2016年 jaki. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    OrderTypeNone,
    OrderTypeASC,
    OrderTypeDesc
}SQLiteSearchOrderType;

@interface SQLiteSearchRequest : NSObject


/**
    want to search value of fields
    if set to empty array ,it will search no data.
    if set to nil or not set ,it will search all field data. Default is nil
 */
@property(nonatomic,strong)NSArray<NSString *> * fieldArray;


/**
    sequence rule depents on.
 */
@property(nonatomic,strong)NSString * orderByField;

/**
    sequence rule.
 */
@property(nonatomic,assign)SQLiteSearchOrderType orderType;


/**
    set search pageSize,if set to 0, will search no data. Default search all
 */
@property(nonatomic,assign)NSInteger limit;


/**
    set search pageOffset,Default is 0
 */
@property(nonatomic,assign)NSInteger offset;


/**
    search contidion.
 */
@property(nonatomic,strong)NSString * contidion;


/**
    get order type as string

 @return order type
 */
-(NSString *)orderTypeString;

@end


const extern NSInteger LimitDefaultKey;
