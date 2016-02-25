//
//  HomeViewController.m
//  LoveWord
//
//  Created by xiongchao on 16/1/11.
//  Copyright © 2016年 xiongchao. All rights reserved.
//
#define BtnHeight 35

#import "HomeViewController.h"
#import "HomeModel.h"
#import "HomeTableViewCell.h"
#import "HomeDetailViewController.h"
#import "WordDetailViewController.h"
#import "UITabBarController+HideTabBar.h"
static NSString *cellID = @"myCell";

@interface HomeViewController ()<UISearchBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    float lastContentOffset;
    UIButton * backTopbtn;
    UITableView *searchTable;
    NSArray *relateWord;
    NSInteger wordLength;
    NSArray *translates;
}
@property (nonatomic,strong)NSMutableArray *modelArr1;
@property (nonatomic,strong)NSMutableArray *modelArr2;
@property (nonatomic,strong)NSMutableArray *modelArr3;
@property (nonatomic,strong)NSMutableArray *tableArr;
@property (nonatomic,strong)NSArray *dicArray;
@property (nonatomic,strong)UIScrollView * scrollview;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,assign)BOOL keyboardIsVisible;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self createUI];
}

- (void)configData
{
    _tableArr = [NSMutableArray array];
    NSDictionary *dic1 = @{@"limit":@"20",@"s":@"englishnewss"};
    NSDictionary *dic2 = @{@"limit":@"20",@"s":@"englishdaily"};
    NSDictionary *dic3 = @{@"limit":@"20",@"s":@"englishstory"};
    _dicArray = @[dic1,dic2,dic3];

    for (int i = 0; i < 3; i++)
    {
        [HttpService getHttpDataWithUrlStr:HomeUrlStr andParameters:_dicArray[i] andDataBlock:^(NSMutableArray *arr) {
            if (!arr)
            {
                NSLog(@"获取数据失败");
            }
            else
            {
                if (i == 0)
                {
                    _modelArr1 = arr;
                }
                if (i == 1)
                {
                    _modelArr2 = arr;
                }
                if (i == 2)
                {
                    _modelArr3 = arr;
                }
                
                UITableView *table = _tableArr[i];
                [table reloadData];

            }
        }];
    }

}

//获取上拉数据
-(void)updateUpDataWith:(NSInteger)i
{
    [HttpService getHttpDataWithUrlStr:HomeUrlStr andParameters:_dicArray[i] andDataBlock:^(NSMutableArray *arr) {
        if (!arr)
        {
            NSLog(@"获取数据失败");
        }
        else
            
        {
            if (i == 0)
            {
                _modelArr1 = arr;
            }
            else if (i == 1)
            {
                _modelArr2 = arr;
            }
            else if (i == 2)
            {
                _modelArr3 = arr;
            }
            UITableView *table = _tableArr[i];
            [table reloadData];
            [table.mj_header endRefreshing];
            
        }
        
    }];
}


//获取下拉数据
-(void)updateDownDataWith:(NSInteger)i
{
    NSArray *strArr = @[@"englishnewss",@"englishdaily",@"englishstory"];
    HomeModel *model = [[HomeModel alloc]init];
    if (i == 0)
    {
        model = [_modelArr1 lastObject];
    }
    if (i == 1)
    {
        model = [_modelArr2 lastObject];

    }
    if (i == 2)
    {
        model = [_modelArr3 lastObject];
    }
    NSInteger count = model.messageId-1;
    
    NSDictionary *dic = @{@"limit":@"20",@"maxId":[NSString stringWithFormat:@"%d",count],@"s":strArr[i]};
    
    [HttpService getHttpDataWithUrlStr:HomeUrlStr andParameters:dic andDataBlock:^(NSMutableArray *arr) {
        
        if (arr)
        {
//            for (HomeModel *model in arr)
//            {
//                NSLog(@"%@",model);
//            }
            
            if (i == 0)
            {
                for (id obj in arr)
                {
                    [_modelArr1 addObject:obj];
                }
                
            }
            if (i == 1)
            {
                for (id obj in arr)
                {
                    [_modelArr2 addObject:obj];
                }
                
            }
            if (i == 2)
            {
                for (id obj in arr)
                {
                    [_modelArr2 addObject:obj];
                }
                
            }
            UITableView *table = _tableArr[i];
            [table reloadData];
            
            [table.mj_footer endRefreshing];

        }
        else
        {
            NSLog(@"获取数据失败");
        }
        
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
}


-(void)createUI
{
    
    //搜索栏
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"查单词";
    self.navigationItem.titleView = _searchBar;
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor blueColor];
    
    //分类按钮背景视图
    UIView * classView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, BtnHeight)];
    [self.view addSubview:classView];
    
    //分类按钮
    NSArray *btnArr = @[@"新闻",@"美句",@"美文"];
    for (int i = 0; i < 3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*SCREEN_WIDTH/3.0, 0, SCREEN_WIDTH/3.0, BtnHeight);
        [btn setTitle:btnArr[i] forState:UIControlStateNormal];
        if (i == 0)
        {
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        
        [classView addSubview:btn];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, BtnHeight-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [classView addSubview:lineView];
    
    //滚动视图
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+BtnHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-BtnHeight)];
    [self.view addSubview:_scrollview];
    _scrollview.contentSize = CGSizeMake(3*SCREEN_WIDTH, _scrollview.bounds.size.height);
    _scrollview.pagingEnabled = YES;
    _scrollview.bounces = NO;
    _scrollview.delegate = self;
    _scrollview.showsHorizontalScrollIndicator = NO;
    
    //滚动视图中的table
    _tableArr = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollview.bounds.size.height) style:UITableViewStylePlain];
        [_tableArr addObject:table];
        [_scrollview addSubview:table];
        //注册
        [table registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
        table.tableFooterView = [[UIView alloc]init];
        table.dataSource = self;
        table.delegate = self;
        table.scrollsToTop = YES;
        
        table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self updateUpDataWith:i];
        }];
        
        table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self updateDownDataWith:i];
        }];
    }
    
    //回到顶部
//    backTopbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-120, 45, 45)];
//    [backTopbtn setBackgroundImage:[UIImage imageNamed:@"back_top"] forState:UIControlStateNormal];
//    backTopbtn.hidden = YES;
//    [backTopbtn addTarget:self action:@selector(backTopClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backTopbtn];
    
    //相关单词table
    searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    searchTable.delegate = self;
    searchTable.dataSource =self;
    searchTable.tableFooterView = [[UIView alloc]init];

}

//回到顶部
//-(void)backTopClick:(UIButton *)btn
//{
//    NSInteger index = _scrollview.contentOffset.x/SCREEN_WIDTH;
//    UITableView *table = _tableArr[index];
//    [table setContentOffset:CGPointMake(0, 0) animated:NO];
//    [table setContentOffset:CGPointMake(0, 0) animated:NO];
//    backTopbtn.hidden = YES;
//}


//1组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//每组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableArr[0])
    {
        return _modelArr1.count;
    }
    if (tableView == _tableArr[1])
    {
      return _modelArr2.count;
    }
    if (tableView == _tableArr[2])
    {
      return _modelArr3.count;
    }
    if (tableView == searchTable)
    {
        return relateWord.count;
    }
    return 0;
}

//cell的创建
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableArr[0])
    {
       HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
       cell.model = _modelArr1[indexPath.row];
        return cell;
    }
    if (tableView == _tableArr[1])
    {
       HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
       cell.model = _modelArr2[indexPath.row];
        return cell;
    }
    if (tableView == _tableArr[2])
    {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
       cell.model = _modelArr3[indexPath.row];
        return cell;
    }
    
    if (tableView == searchTable)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:relateWord[indexPath.row]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, wordLength)];
        cell.textLabel.attributedText = attributedString;
        cell.detailTextLabel.text = translates[indexPath.row];
        return cell;
        
    }
    return nil;

}

//预估高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

#pragma mark -
#pragma mark 点击cell
//cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchTable)
    {
        [self.navigationController.view endEditing:YES];
        WordDetailViewController *wdvc = [[WordDetailViewController alloc]init];
        wdvc.word = relateWord[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wdvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        [searchTable removeFromSuperview];
    }
    else
    {
        HomeDetailViewController *hdvc = [[HomeDetailViewController alloc]init];
        
        HomeModel *model = [[HomeModel alloc]init];
        if (tableView == _tableArr[0])
        {
            model = _modelArr1[indexPath.row];
        }
        if (tableView == _tableArr[1])
        {
            model = _modelArr2[indexPath.row];
            
        }
        if (tableView == _tableArr[2])
        {
            model = _modelArr3[indexPath.row];
        }
        hdvc.imgUrlStr = model.image;
        hdvc.text = model.text;
        hdvc.titleStr = model.displayName;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hdvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (lastContentOffset < scrollView.contentOffset.y)
    {
        NSLog(@"向上滚动");
         [self.tabBarController setTabBarHidden:YES animated:YES];
    }
    else
    {
        NSLog(@"向下滚动");
         [self.tabBarController setTabBarHidden:NO animated:YES];
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSInteger index = _scrollview.contentOffset.x/SCREEN_WIDTH;
//    UITableView *table = _tableArr[index];
//    CGPoint offset = table.contentOffset;
//    NSInteger y = offset.y;
//    NSLog(@"现在的高度%d",y);
//    if (offset.y > 2000)
//    {
//        backTopbtn.hidden = NO;
//    }
//    else
//    {
//        backTopbtn.hidden = YES;
//    }

}




//滚动停止代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGPoint contentOffset = _scrollview.contentOffset;
    for (int i = 0; i < 3; i++)
    {
        UIButton *btn = [self.view viewWithTag:1000+i];
        if (contentOffset.x/SCREEN_WIDTH == i)
        {
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            
        }
        else
        {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    
    

}

//分类按钮点击事件
- (void)btnClick:(UIButton *)sender
{
    for (int i = 0; i < 3; i++)
    {
        UIButton *btn = [self.view viewWithTag:1000+i];
        if (sender.tag-1000 == i)
        {
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            
        }
        else
        {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    _scrollview.contentOffset = CGPointMake((sender.tag-1000)*SCREEN_WIDTH, 0);
    
    
}

#pragma mark -
#pragma mark 输入

//点击searchBar输入框,开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UIBarButtonItem *cancalBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancalBtnClick:)];
    [cancalBtn setTintColor:[UIColor whiteColor]];
    //添加取消按钮
    self.navigationItem.rightBarButtonItem = cancalBtn;
    [self.view addSubview:searchTable];
    
}


//输入框内容改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //单词长度
    wordLength = searchText.length;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        //异步操作代码块
//        //获取相关的单词
//        relateWord = [FMDBService getSearchRelateWords:searchText];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            //回到主线程操作代码块
//            [searchTable reloadData];
//        });
//        
//    });
    
    //获取相关的单词
    relateWord = [FMDBService getSearchRelateWords:searchText];
    //获取相关单词翻译
    translates = [FMDBService getMeansToWords:relateWord];
    //刷新
    [searchTable reloadData];
    
    
}

//键盘搜索按钮按下
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController.view endEditing:YES];
    WordDetailViewController *wdvc = [[WordDetailViewController alloc]init];
    wdvc.word = searchBar.text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wdvc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [searchTable removeFromSuperview];
}

#pragma mark -
#pragma mark 取消

//点击取消按钮
-(void)cancalBtnClick:(UIButton *)sender
{
    //相关单词置空
    relateWord = nil;
    //刷新
    [searchTable reloadData];
    //输入框置空
    _searchBar.text = nil;
    //去掉searchTable
    [searchTable removeFromSuperview];
    //取消输入
    [self.navigationController.view endEditing:YES];
    //去掉取消按钮
    self.navigationItem.rightBarButtonItem = nil;
    
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
