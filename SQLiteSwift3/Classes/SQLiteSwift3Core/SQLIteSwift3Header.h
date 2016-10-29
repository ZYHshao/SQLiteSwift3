//
//  SQLIteSwift3Header.h
//  SQLiteTest
//
//  Created by vip on 16/10/24.
//  Copyright © 2016年 jaki. All rights reserved.
//

#ifndef SQLIteSwift3Header_h
#define SQLIteSwift3Header_h
#define LOG_FORMAT(Cls,Info) NSLog(@"SQLiteSwift3======LOG=======\n%@-%s-%d:%@",Cls,__FUNCTION__,__LINE__,Info);


//check contition sentence define must be used form a pair
#define CHECK_BEGIN_REQURIMENT(bValue) if(bValue){
#define CHECK_END_REQUREMENT(codeBlock) }else{codeBlock};


#endif /* SQLIteSwift3Header_h */

