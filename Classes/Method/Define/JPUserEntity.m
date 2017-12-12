//
//  JPUserEntity.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPUserEntity.h"

static JPUserEntity *__userEntity = nil;

@implementation JPUserEntity
//实现方法,判断是否为空,是就创建一个全局实例给它
+ (JPUserEntity *)sharedUserEntity {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __userEntity = [[JPUserEntity alloc] init];
    });
    return __userEntity;
}

//避免alloc/new创建新的实例变量--->增加一个互斥锁
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized(self) {
        if (__userEntity == nil) {
            __userEntity = [super allocWithZone:zone];
        }
    }
    return __userEntity;
}

//避免copy,需要实现NSCopying协议
- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)setMerchantNo:(NSString *)merchantNo {
    if (merchantNo == nil) {
        merchantNo = @"";
    }
    _merchantNo = merchantNo;
}
@end
