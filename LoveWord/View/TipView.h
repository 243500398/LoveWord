//
//  TipView.h
//  Individuation
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TipViewDelegate <NSObject>

-(void)gowdvcWithWord:(NSString *)str;

@end

@interface TipView : UIView

+(TipView *)defaultManager;
+(void)showTip:(NSString *)title;
-(void)showTranslate:(NSString *)word;

@property (nonatomic,assign)id <TipViewDelegate> delegate;

@end
