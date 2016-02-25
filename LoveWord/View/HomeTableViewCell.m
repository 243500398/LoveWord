//
//  HomeTableViewCell.m
//  LoveWord
//
//  Created by xiongchao on 16/1/14.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(HomeModel *)model
{
    if (_model != model)
    {
        _model = model;
        self.time.text = [self dealTime:_model.time];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.image]];
        self.text.text = _model.text;
        self.from.text = [NSString stringWithFormat:@"#%@#",_model.displayName];
    }
   
}

//处理时间
-(NSString *)dealTime:(NSString *)time
{
    //已知有如下时间格式2016.1.10T.15:20:25
    NSArray *timeArr = [time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"T."]];
    //年月日——时分秒
    NSString *str = [NSString stringWithFormat:@"%@ %@",timeArr[0],timeArr[1]];
    //年月日
    NSString *str1 = [NSString stringWithFormat:@"%@",timeArr[0]];
    //字符串时间转换为NSdata
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dataFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *date = [dataFormatter dateFromString:str];
    
    //date与当前系统时间相比较，结果取绝对值
    NSInteger second = fabs([date timeIntervalSinceNow]);
    //计算小时
    NSInteger hour = second/(60*60);
    //小时为零计算分
    if (hour == 0)
    {
        NSInteger minute = second/60;
        return [NSString stringWithFormat:@"%d分钟前",minute];
    }
    else if (hour < 24)
    {
        return [NSString stringWithFormat:@"%d小时前",hour];
    }
    else if (hour >= 24 && hour <48)
    {
        return @"1天前";
    }
    else if (hour >= 48 && hour <72)
    {
        return @"2天前";
    }
    else
    {
        //大于72小时只显示年月日
        return str1;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
