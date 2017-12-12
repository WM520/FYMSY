//
//  IBDataBase.m
//  JiePos
//
//  Created by iBlocker on 2017/11/9.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBDataBase.h"
#import "FMDB.h"
#import <Foundation/Foundation.h>

@interface IBDataBase () <NSCopying, NSMutableCopying> {
    FMDatabase  *_dataBase;
}
@end
static IBDataBase *_dataBaseCtl = nil;
@implementation IBDataBase
+ (instancetype)sharedDataBase {
    
    if (_dataBaseCtl == nil) {
        _dataBaseCtl = [[IBDataBase alloc] init];
        [_dataBaseCtl initDataBase];
    }
    return _dataBaseCtl;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (_dataBaseCtl == nil) {
        
        _dataBaseCtl = [super allocWithZone:zone];
    }
    return _dataBaseCtl;
}

- (id)copy {
    
    return self;
}

- (id)mutableCopy {
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    return self;
}


- (void)initDataBase {
    
    // 文件路径
    NSString *filePath = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.JieposExtention"] absoluteString] stringByAppendingPathComponent:@"mynews.sqlite"];
    
    // 实例化FMDataBase对象
    _dataBase = [FMDatabase databaseWithPath:filePath];
    [_dataBase open];
    
    // 初始化数据表
    NSString *personSql = @"CREATE TABLE 'news' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'news_id' VARCHAR(255),'transactionResult' VARCHAR(255),'transactionMoney' VARCHAR(255),'transactionTime'VARCHAR(255),'tenantsNumber'VARCHAR(255),'tenantsName'VARCHAR(255),'transactionType'VARCHAR(255),'payType'VARCHAR(255),'orderNumber'VARCHAR(255),'serialNumber'VARCHAR(255),'answerBackCode'VARCHAR(255),'transactionCode'VARCHAR(255),'couponAmt'VARCHAR(255),'totalAmt'VARCHAR(255)) ";
    [_dataBase executeUpdate:personSql];
    
    [_dataBase close];
}

#pragma mark - 接口

- (void)addModel:(IBNewsModel *)newsModel {
    [_dataBase open];
    
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_dataBase executeQuery:@"SELECT * FROM news "];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"news_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"news_id"] integerValue] ) ;
        }
    }
    maxID = @([maxID integerValue] + 1);
        
    [_dataBase executeUpdate:@"INSERT INTO news(news_id,transactionResult,transactionMoney,transactionTime,tenantsNumber,tenantsName,transactionType,payType,orderNumber,serialNumber,answerBackCode,transactionCode,couponAmt,totalAmt)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", maxID, newsModel.transactionResult, newsModel.transactionMoney, newsModel.transactionTime, newsModel.tenantsNumber, newsModel.tenantsName, newsModel.transactionType, newsModel.payType, newsModel.orderNumber, newsModel.serialNumber, newsModel.answerBackCode, newsModel.transactionCode, newsModel.couponAmt, newsModel.totalAmt];
    
    [_dataBase close];
    
}

- (void)deleteTable {
    [_dataBase open];
    
    [_dataBase executeUpdate:@"DELETE FROM news"];
    
    [_dataBase close];
}


- (NSMutableArray *)getAllPerson {
    [_dataBase open];
    
    NSMutableArray *dataArray = @[].mutableCopy;
    
    FMResultSet *res = [_dataBase executeQuery:@"SELECT * FROM news"];
    
    while ([res next]) {
        IBNewsModel *newsModel = [[IBNewsModel alloc] init];
        newsModel.news_id = [[res stringForColumn:@"news_id"] integerValue];
        newsModel.transactionResult = [res stringForColumn:@"transactionResult"];
        newsModel.transactionMoney = [res stringForColumn:@"transactionMoney"];
        newsModel.transactionTime = [res stringForColumn:@"transactionTime"];
        newsModel.tenantsNumber = [res stringForColumn:@"tenantsNumber"];
        newsModel.tenantsName = [res stringForColumn:@"tenantsName"];
        newsModel.transactionType = [res stringForColumn:@"transactionType"];
        newsModel.payType = [res stringForColumn:@"payType"];
        newsModel.orderNumber = [res stringForColumn:@"orderNumber"];
        newsModel.serialNumber = [res stringForColumn:@"serialNumber"];
        newsModel.answerBackCode = [res stringForColumn:@"answerBackCode"];
        newsModel.transactionCode = [res stringForColumn:@"transactionCode"];
        newsModel.couponAmt = [res stringForColumn:@"couponAmt"];
        newsModel.totalAmt = [res stringForColumn:@"totalAmt"];
        
        [dataArray addObject:newsModel];
    }
    [_dataBase close];
        
    return dataArray;
}

@end
