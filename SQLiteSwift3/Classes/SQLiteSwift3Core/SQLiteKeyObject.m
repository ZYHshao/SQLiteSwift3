//
//  SQLiteKeyObject.m
//  SQLiteTest
//
//  Created by vip on 16/10/24.
//  Copyright © 2016年 jaki. All rights reserved.
//

#import "SQLiteKeyObject.h"

@implementation SQLiteKeyObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fieldType = TEXT;
        self.modificationType = NO_MODIFICATION;
        self.tSize = 10;
    }
    return self;
}

-(NSString *)getFieldType{
    switch (self.fieldType) {
        case SMALLINT:
            return @"smallint";
            break;
        case INTEGER:
            return @"integer";
            break;
        case REAL:
            return @"real";
            break;
        case FLOAT:
            return @"float";
            break;
        case DOUBLE:
            return @"double";
            break;
        case CURRENCY:
            return @"currency";
            break;
        case VARCHAR:
            return @"varchar";
            break;
        case TEXT:
            return [NSString stringWithFormat:@"text(%ld)",self.tSize];
            break;
        case BINARY:
            return @"binary";
            break;
        case BLOB:
            return @"blob";
            break;
        case DATE:
            return @"date";
            break;
        case TIME:
            return @"time";
            break;
        case TIMESTAMP:
            return @"timestamp";
            break;
        default:
            return nil;
            break;
    }
}


-(NSString *)getModificationType{
    switch (self.modificationType) {
        case NO_MODIFICATION:
            return nil;
            break;
        case PRIMARY_KEY:
            return @"PRIMARY KEY";
            break;
        case NOT_NULL:
            return @"NOT NULL";
            break;
        case UNIQUE:
            return @"UNIQUE";
            break;
        case DEFAULT:
            return @"DEFAULT";
            break;
        case CHECK:
            return @"CHECK";
            break;
        default:
            return nil;
            break;
    }
}

-(NSString *)condition{
    if (self.modificationType == DEFAULT) {
        if (self.fieldType == TEXT) {
            return [NSString stringWithFormat:@"\"%@\"",_condition];
        }else if(self.fieldType == VARCHAR){
            return [NSString stringWithFormat:@"\'%@\'",_condition];
        }else{
            return _condition;
        }
    }else{
        return _condition;
    }
}
@end
