//
//  HomeTableViewCell.h
//  LoveWord
//
//  Created by xiongchao on 16/1/14.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeTableViewCell : UITableViewCell
@property (nonatomic,strong)HomeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *from;


@end
