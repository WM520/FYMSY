//
//  JPModifyInfoHelper.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/6.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPModifyInfoHelper.h"

@implementation JPModifyInfoHelper
/** 数据源*/
+ (NSMutableDictionary *)dataSource {
    NSString *filePath = [self filePath];
    return [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
}

/** 清除数据*/
+ (void)clearData {
    NSMutableDictionary *mutableDic = [self dataSource];
    [mutableDic removeAllObjects];
    [self saveData:mutableDic];
}

/** 路径*/
+ (NSString *)filePath {
    NSString *path = NSHomeDirectory();
    NSString *docPath  = [path stringByAppendingPathComponent:@"Documents"];
    return [docPath stringByAppendingPathComponent:@"modifyinfo.plist"];
}

/** 保存数据*/
+ (void)saveData:(NSMutableDictionary *)data {
    [data writeToFile:[self filePath] atomically:YES];
}

/**
 插入数据
 
 @param obj 值
 @param key 键
 */
+ (void)addObject:(id)obj forKey:(NSString *)key {
    NSMutableDictionary *mutableDic = nil;
    if ([[self dataSource] count] > 0) {
        mutableDic = [self dataSource];
    } else {
        mutableDic = @{}.mutableCopy;
    }
    [mutableDic setObject:obj forKey:key];
    [self saveData:mutableDic];
}

/**
 读取数据
 
 @param key 键
 @return 值
 */
+ (id)objectForKey:(NSString *)key {
    NSMutableDictionary *mutableDic = [self dataSource];
    NSArray *keys = mutableDic.allKeys;
    
    if ([keys containsObject:key]) {
        return [mutableDic objectForKey:key];
    } else {
        return nil;
    }
}

@end
