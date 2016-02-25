//
//  HomeDetailViewController.m
//  LoveWord
//
//  Created by xiongchao on 16/1/18.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "UITextView+MyText.h"
#import "WordDetailViewController.h"
#define IMGHEIGHT 200
@interface HomeDetailViewController ()<TipViewDelegate>

{
    UIImageView *imgView;
    UITextView *myTextView;
    UIBarButtonItem *collect;
    TipView *translateView;
    
}
@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self configUI];
}

-(void)configData
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (translateView)
    {
        [translateView removeFromSuperview];
    }
}

-(void)configUI
{
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回"
            style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.titleStr;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
    //图片
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMGHEIGHT)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrlStr]];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageHappen:)];
    [imgView addGestureRecognizer:tapImage];
    //设置图片填充模式
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    //裁剪边缘
    imgView.clipsToBounds = YES;
    //开启交互
    imgView.userInteractionEnabled = YES ;
    [scrollView addSubview:imgView];
    
    //文字
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, IMGHEIGHT, SCREEN_WIDTH-20, 500)];
    myTextView.text = self.text;
    //不许编辑
    myTextView.editable = NO;
    //不许滚动文本
    myTextView.scrollEnabled = NO;
    myTextView.font = [UIFont systemFontOfSize:17];
    //自适应
    [myTextView sizeToFit];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, IMGHEIGHT + myTextView.bounds.size.height);
    [scrollView addSubview:myTextView];
    
    UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTextHappen:)];
    [myTextView addGestureRecognizer:tapText];
  
    //工具条
    collect = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectClick:)];
    collect.tag = 1;

    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.toolbarItems = @[space,collect,space,space,share,space];
    [self.navigationController setToolbarHidden:NO];
    
}

//收藏
-(void)collectClick:(UIBarButtonItem *)sender
{
    if(sender.tag)
    {
        collect.title = @"取消收藏";
        
    }
    else
    {
        collect.title = @"收藏";
    }
    sender.tag = !sender.tag;
}



-(void)shareClick
{
    NSLog(@"分享");
}


-(void)tapTextHappen:(UITapGestureRecognizer *)tap
{
    //点击的坐标
    CGPoint tapPoint = [tap locationInView:myTextView];
    NSString *tapStr = [myTextView strToPoint:tapPoint];
    NSLog(@"点击的单词是：%@",tapStr);
    translateView = [TipView defaultManager];
    translateView.delegate = self;
    if (![tapStr isEqualToString:@""])
    {
        if ([OtherHelper isEnglish:tapStr])
        {
            NSLog(@"是英文");
            
            [self.view addSubview:translateView];
            [translateView showTranslate:tapStr];
            
        }
        else
        {
            NSLog(@"不是英文");
        }

    }
    else
    {
        NSLog(@"点击的是空白");
        [translateView removeFromSuperview];
        
    }
    
}

-(void)gowdvcWithWord:(NSString *)str
{
    WordDetailViewController *wdvc = [[WordDetailViewController alloc]init];
    wdvc.word = str;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wdvc animated:YES];
    
}

//点击图片
-(void)tapImageHappen:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"保存");
        UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }];

    UIAlertAction * cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [alert addAction:save];
    [alert addAction:cancal];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        NSLog(@"保存成功");
        [TipView showTip:@"保存成功"];
    }
    else
    {
        NSLog(@"保存失败");
        [TipView showTip:@"保存失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
