//
//  OtherHelper.m
//  LoveWord
//
//  Created by xiongchao on 16/1/29.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "OtherHelper.h"

@implementation OtherHelper

//判断字符串是否为英文单词
+(BOOL)isEnglish:(NSString *)string
{
    NSString * firstWord = [string substringToIndex:1];
    NSLog(@"首字%@",firstWord);
//
//    char firstWord = [string characterAtIndex:0];
//    NSLog(@"首字母%c",firstWord);
    
    // 编写正则表达式：只能是英文
    NSString *regex = @"^[a-zA-Z]+$";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 对字符串进行判断
    if ([predicate evaluateWithObject:firstWord])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
