//
//  SQLiteSearchRequest.m
//  SQLiteTest
//
//  Created by vip on 16/10/28.
//  Copyright © 2016年 jaki. All rights reserved.
//

#import "SQLiteSearchRequest.h"


const NSInteger LimitDefaultKey = -1;
@implementation SQLiteSearchRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        _limit = LimitDefaultKey;
        _orderType = OrderTypeNone;
    }
    return self;
}

-(NSString *)orderTypeString{
    switch (self.orderType) {
        case OrderTypeNone:
            return nil;
            break;
        case OrderTypeASC:
            return @"asc";
            break;
        case OrderTypeDesc:
            return @"desc";
            break;
        default:
            return nil;
            break;
    }
}
@end
