//
//  FMDBService.m
//  LoveWord
//
//  Created by xiongchao on 16/1/26.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "FMDBService.h"

@implementation FMDBService

//获取模糊搜索的单词组
+(NSArray *)getSearchRelateWords:(NSString *)word
{
    //获取沙盒路径
//   NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"EnglishWords" ofType:@"sqlite"];

    //单词长度
    NSInteger length = word.length;
    NSMutableArray *arr = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        //查询表
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Words"];
        while ([resultSet next])
        {
            NSString *string = [resultSet stringForColumn:@"word"];
            if (string.length >= length)
            {
                NSString *str = [string substringToIndex:length];
                if ([str isEqualToString:word])
                {
                    [arr addObject:string];
                    if (arr.count == 10)
                    {
                        break;
                    }
                }
            }
        }
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
    [db close];
    return arr;
}


//获取单词解析
+(NSString *)getTranslateForWord:(NSString *)word
{
    NSString *total = [NSString string];
    //文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"EnglishWords" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        //查询表
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Words"];
        while ([resultSet next])
        {
            NSString *string = [resultSet stringForColumn:@"word"];
            if([string isEqualToString:word])
            {
                NSString *GQS = [resultSet stringForColumn:@"gqs"];
                NSString *GQFC = [resultSet stringForColumn:@"gqfc"];
                NSString *XZFC = [resultSet stringForColumn:@"xzfc"];
                NSString *FS = [resultSet stringForColumn:@"fs"];
                NSString *MEAN = [resultSet stringForColumn:@"meaning"];
                MEAN = [MEAN stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
                NSString *LX = [resultSet stringForColumn:@"lx"];
                NSString *dealLX = [LX stringByReplacingOccurrencesOfString:@"/r/n" withString:@"\n"];
                
                total = [NSString stringWithFormat:@"%@\n%@\n\n过去式:%@\n过去分词:%@\n现在分词:%@\n复数:%@\n\n例句:%@\n",string,MEAN,GQS,GQFC,XZFC,FS,dealLX];
                break;
            }
        }

    }
    else
    {
         NSLog(@"打开单词数据库失败");
    }
    [db close];
    return total;
}


//创建单词本表
+(void)addWordBookExcel
{
    NSString *filePath = [SANDBOX stringByAppendingPathComponent:@"wordBook.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString *sqlStr = @"CREATE TABLE w (rank integer,word text)";
        BOOL res = [db executeUpdate:sqlStr];
        if (res)
        {
            NSLog(@"单词本表创建成功");
        }
        else
        {
            NSLog(@"单词本表创建失败");
        }
        
    }
    else
    {
        NSLog(@"打开单词本数据库失败");
    }
    [db close];

}

//添加单词到单词本
+(BOOL)addWordBookWithWord:(NSString *)string
{
    NSString *filePath = [SANDBOX stringByAppendingPathComponent:@"wordBook.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString * sqlStr = @"insert into w values(?,?)";
        BOOL res = [db executeUpdate:sqlStr,@1,string];
        return res;
    }
    else
    {
        NSLog(@"打开单词本数据库失败");
    }
    [db close];
    return NO;
}

//判断单词是否存在单词本
+(BOOL)isExistInWordBook:(NSString *)string
{
    NSString *filePath = [SANDBOX stringByAppendingPathComponent:@"wordBook.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        //查询表
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM w"];
        while ([resultSet next])
        {
            NSString *word = [resultSet stringForColumn:@"word"];
            if ([word isEqualToString:string])
            {
                return YES;
            }

        }
    }
    else
    {
        NSLog(@"打开单词本数据库失败");
    }
    
    [db close];
    return NO;
}

//从单词本删除
+(BOOL)deleteWord:(NSString *)string
{
    NSString *filePath = [SANDBOX stringByAppendingPathComponent:@"wordBook.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        //删除
        BOOL result = [db executeUpdate:@"DELETE FROM w WHERE word = ?",string];
        return result;
    }
    else
    {
        NSLog(@"打开单词本数据库失败");
    }
    
    [db close];
    return NO;

}

//根据单词获取单词翻译
+(NSString *)getMeanToWord:(NSString *)word
{
    NSString *mean = [NSString string];
    //文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"EnglishWords" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Words"];
        while ([result next]) {
            NSString *string = [result stringForColumn:@"word"];
            if ([string isEqualToString:word])
            {
                mean = [result stringForColumn:@"meaning"];
                break;
            }
        }
        mean = [mean stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
    [db close];
    return mean;
}

//根据单词组获取单词翻译
+(NSArray *)getMeansToWords:(NSArray *)array
{
    NSMutableArray *translates = [NSMutableArray array];
    //文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"EnglishWords" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Words"];
        while ([result next])
        {
            NSString *string = [result stringForColumn:@"word"];
            if ([array containsObject:string])
            {
                NSString * mean = [result stringForColumn:@"meaning"];
                mean = [mean stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
                [translates addObject:mean];
            }
        }
        
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
    [db close];
    return translates;
}
@end
