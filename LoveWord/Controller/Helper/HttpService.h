//
//  HttpService.h
//  LoveWord
//
//  Created by xiongchao on 16/1/15.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DataBlock)(NSMutableArray *arr);

@interface HttpService : NSObject
+(void)getHttpDataWithUrlStr:(NSString *)urlStr andParameters:(NSDictionary *)dic andDataBlock:(DataBlock)block;
@end
