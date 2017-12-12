//
//  JPModifyInfoHelper.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/6.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPModifyInfoHelper : NSObject
/** 数据源*/
+ (NSMutableDictionary *)dataSource;
/** 清除数据*/
+ (void)clearData;
/** 路径*/
+ (NSString *)filePath;
/**
 插入数据
 
 @param obj 值
 @param key 键
 */
+ (void)addObject:(id)obj forKey:(NSString *)key;
/**
 读取数据
 
 @param key 键
 @return 值
 */
+ (id)objectForKey:(NSString *)key;

@end
