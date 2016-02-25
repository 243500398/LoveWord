//
//  HomeModel.h
//  LoveWord
//
//  Created by xiongchao on 16/1/11.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,strong)NSArray *like;
@property (nonatomic,assign) NSInteger messageId;
+ (NSDictionary *)replacedKeyFromPropertyName;

@end
