//
//  IBDataBase.h
//  JiePos
//
//  Created by iBlocker on 2017/11/9.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBNewsModel.h"

@interface IBDataBase : NSObject
+ (instancetype)sharedDataBase;

#pragma mark - Person
/** 添加newsModel*/
- (void)addModel:(IBNewsModel *)newsModel;
/** 删除Table*/
- (void)deleteTable;
/** 获取所有数据*/
- (NSMutableArray *)getAllPerson;
@end
