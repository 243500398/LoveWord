//
//  HttpService.m
//  LoveWord
//
//  Created by xiongchao on 16/1/15.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "HttpService.h"
#import "AFNetworking.h"
#import "HomeModel.h"
#import "MJExtension.h"

@implementation HttpService

+(void)getHttpDataWithUrlStr:(NSString *)urlStr andParameters:(NSDictionary *)dic andDataBlock:(DataBlock)block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置服务器返回数据的格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //处理链接问题
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager GET:urlStr parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *modelArr = [NSMutableArray array];
        //数据存到模型
        for (NSDictionary *dic in dataArr)
        {
            HomeModel *model = [HomeModel mj_objectWithKeyValues:dic];
            if (model)
            {
                [modelArr addObject:model];
            }
        }
        block(modelArr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        block(nil);
    }];
    
}
@end
