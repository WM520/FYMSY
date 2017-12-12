//
//  JPUserEntity.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

//  用户实体
@interface JPUserEntity : NSObject
@property (nonatomic, assign) BOOL isLogin;
/** 账户*/
@property (nonatomic, strong) NSString *jp_user;
@property (nonatomic, strong) NSString *jp_pass;
/** 商户号*/
@property (nonatomic, strong) NSString *merchantNo;
/** 唯一识别码*/
@property (nonatomic, strong) NSString *merchantId;
/** 商户名*/
@property (nonatomic, strong) NSString *merchantName;
/** 1 K9商户    2 一码付商户*/
@property (nonatomic, assign) NSUInteger applyType;
//  单例方法
+ (JPUserEntity *)sharedUserEntity;
@end
