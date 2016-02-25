//
//  FMDBService.h
//  LoveWord
//
//  Created by xiongchao on 16/1/26.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBService : NSObject

+(NSArray *)getSearchRelateWords:(NSString *)word;

+(NSString *)getTranslateForWord:(NSString *)word;

+(BOOL)addWordBookWithWord:(NSString *)string;

+(void)addWordBookExcel;

+(NSString *)getMeanToWord:(NSString *)word;

+(BOOL)isExistInWordBook:(NSString *)string;

+(BOOL)deleteWord:(NSString *)string;

+(NSArray *)getMeansToWords:(NSArray *)array;
@end
