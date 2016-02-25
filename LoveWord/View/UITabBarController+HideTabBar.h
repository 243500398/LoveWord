//
//  UITabBarController+HideTabBar.h
//  LoveWord
//
//  Created by xiongchao on 16/2/5.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (HideTabBar)

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
