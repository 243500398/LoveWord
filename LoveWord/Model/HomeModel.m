//
//  HomeModel.m
//  LoveWord
//
//  Created by xiongchao on 16/1/11.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"image" : @"data.image.url",
             @"text" : @"data.text",
             @"time" : @"createdAt",
             @"displayName" : @"data.source.displayName",
             @"like" : @"data.post.likes",
             @"messageId":@"messageId"
            };
}


-(NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"++++++image = %@\ntext = %@\nmessageId  = %d",self.image,self.text,self.messageId];
    return str;
}


@end
