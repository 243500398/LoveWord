//
//  TipView.m
//  Individuation
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TipView.h"

#define VIEWWIDTH 200
#define VIEWHEIGHT 150

@interface TipView ()
{
    UILabel *wlabel;
    UILabel *tlabel;
}

@end

static TipView *defaultManager;

@implementation TipView

+(TipView *)defaultManager{
    if(!defaultManager)
        defaultManager=[[self alloc]initWithFrame:CGRectZero];
    return  defaultManager;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bounds = CGRectMake(0, 0,VIEWWIDTH, VIEWHEIGHT);
        self.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        wlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, VIEWWIDTH-20, 30)];
        wlabel.textColor = [UIColor whiteColor];
        wlabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:wlabel];
        
        tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, VIEWWIDTH-20, 70)];
        tlabel.numberOfLines = 0;
        tlabel.textColor = [UIColor whiteColor];
        tlabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:tlabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 115, VIEWWIDTH, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 117, VIEWWIDTH, 30);
        [btn setTitle:@"更多释义->>" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)btnClick:(UIButton *)button
{
    [self.delegate gowdvcWithWord:wlabel.text];
}

+(void)showTip:(NSString *)title
{
    //计算文字宽度
    CGRect rect = [title boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0,0, rect.size.width+20, 40)];
    lable.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    lable.text = title;
    lable.font = [UIFont systemFontOfSize:17];
    lable.textColor = [UIColor whiteColor];
    lable.layer.cornerRadius = 8;
    lable.clipsToBounds = YES;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor blackColor];
    
    UIWindow * window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:lable];
    
    [UIView animateWithDuration:1.5 animations:^{
        lable.alpha = 0;
    } completion:^(BOOL finished) {
        [lable removeFromSuperview];
    }];
    
}

-(void)showTranslate:(NSString *)word
{
    wlabel.text = word;
    NSString *string = [FMDBService getMeanToWord:word];
    if (![string isEqualToString:@""])
    {
        tlabel.text = string;
    }
    else
    {
        tlabel.text = @"没有本地释义";
    }
    
}
@end
