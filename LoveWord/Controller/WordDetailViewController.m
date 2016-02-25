//
//  WordDetailViewController.m
//  LoveWord
//
//  Created by xiongchao on 16/1/26.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "WordDetailViewController.h"

@interface WordDetailViewController ()<UIScrollViewDelegate,UISearchBarDelegate>
{
    UISegmentedControl *segment;
    UIScrollView *scroll;
    UITextView *textView;
    UIBarButtonItem *addWordBook;
    UIScrollView *subScroll;
}
@end

@implementation WordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    segment = [[UISegmentedControl alloc]initWithItems:@[@"本地词典",@"网络词典"]];
    segment.bounds = CGRectMake(0, 0, 140, 30);
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];

    //搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    searchBar.text = self.word;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, searchBar.bounds.size.height+64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-searchBar.bounds.size.height)];
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, scroll.bounds.size.height);
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.bounces = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    
    subScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-searchBar.bounds.size.height)];
    [scroll addSubview:subScroll];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 300)];
    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [textView addGestureRecognizer:tap];
    textView.userInteractionEnabled = YES;
    //不许编辑
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:17];
    textView.text = [FMDBService getTranslateForWord:searchBar.text];
    if (![textView.text isEqualToString:@""])
    {
        [textView sizeToFit];
    }
    [subScroll addSubview:textView];
    subScroll.contentSize = CGSizeMake(SCREEN_WIDTH, textView.bounds.size.height);
    
    //工具条
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    addWordBook = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(addWordBookClick:)];
    
    BOOL result = [FMDBService isExistInWordBook:self.word];
    if (result)
    {
        addWordBook.tag = 1;
        [addWordBook setTitle:@"从单词本移除"];
    }
    else
    {
        addWordBook.tag = 0;
        [addWordBook setTitle:@"添加到单词本"];
    }
    self.toolbarItems = @[space,addWordBook,space];
    self.navigationController.toolbarHidden = NO;

    
}

//收键盘
-(void)endEdit
{
    NSLog(@"293865876");
    [self.view endEditing:YES];
}

//键盘搜索按钮按下
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    self.word = searchBar.text;
    
    textView.text = [FMDBService getTranslateForWord:self.word];
    [textView sizeToFit];
    subScroll.contentSize = CGSizeMake(SCREEN_WIDTH, textView.bounds.size.height);
    
    BOOL result = [FMDBService isExistInWordBook:self.word];
    if (result)
    {
        addWordBook.tag = 1;
        [addWordBook setTitle:@"从单词本移除"];
    }
    else
    {
        addWordBook.tag = 0;
        [addWordBook setTitle:@"添加到单词本"];
    }

}

//添加与移除单词
-(void)addWordBookClick:(UIBarButtonItem *)sender
{
    if (sender.tag == 0)
    {
        BOOL result = [FMDBService addWordBookWithWord:self.word];
        if (result)
        {
            NSLog(@"添加到单词本成功");
            [addWordBook setTitle:@"从单词本移除"];
            addWordBook.tag = 1;
        }
        else
        {
            NSLog(@"添加到单词本失败");
        }
    }
    else
    {
        BOOL result = [FMDBService deleteWord:self.word];
        if (result)
        {
            NSLog(@"从单词本移除成功");
           [addWordBook setTitle:@"添加到单词本"];
            addWordBook.tag = 0;
        }
        else
        {
            NSLog(@"从单词本删除失败");
        }
        
    }
    

}


-(void)segmentAction:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0)
    {
        [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (index == 1)
    {
         [scroll setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x/SCREEN_WIDTH == 1)
    {
        segment.selectedSegmentIndex = 1;
    }
    else
    {
        segment.selectedSegmentIndex = 0;
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
