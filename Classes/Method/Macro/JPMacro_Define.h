//
//  JPMacro_Define.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#ifndef JPMacro_Define_h
#define JPMacro_Define_h

#import <Foundation/Foundation.h>

// !!!: Log
#ifdef DEBUG
#define JPLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define JPLog(format, ...)
#endif

// !!!: 私有方法 调试使用
//#define JPLog(_View_)   NSLog(@"打印视图层次结构:\n*******************************\n%@\n*******************************\n", [_View_ performSelector:@selector(recursiveDescription)])


// !!!: iOS版本
//  iOS 7
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 && [UIDevice currentDevice].systemVersion.floatValue < 8.0)
//  iOS 7之后（包含iOS 7）
#define iOS7Later [UIDevice currentDevice].systemVersion.floatValue >= 7.0
//  iOS 7 ~ 8
#define iOS7To8 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 && [UIDevice currentDevice].systemVersion.floatValue < 9.0)
//  iOS 8之后（包含iOS 8）
#define iOS8Later [UIDevice currentDevice].systemVersion.floatValue >= 8.0
//  iOS 9
#define iOS9 ([UIDevice currentDevice].systemVersion.floatValue >= 9.0 && [UIDevice currentDevice].systemVersion.floatValue < 10.0)
//  iOS 9之后（包含iOS 9）
#define iOS9Later [UIDevice currentDevice].systemVersion.floatValue >= 9.0
//  iOS 10
#define iOS10 ([UIDevice currentDevice].systemVersion.floatValue >= 10.0 && [UIDevice currentDevice].systemVersion.floatValue < 11.0)
//  iOS 10之后（包含iOS 10）
#define iOS10Later [UIDevice currentDevice].systemVersion.floatValue >= 10.0
//  iOS 11
#define iOS11 [UIDevice currentDevice].systemVersion.floatValue >= 11.0

// !!!: Size
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define JPRealValue(_f_) (_f_)/750.0f*[UIScreen mainScreen].bounds.size.width

#define StatuBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight self.navigationController.navigationBar.frame.size.height

#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define TabBarHeight (isPhoneX?83:49)

#define JP_DefaultsFont [UIFont systemFontOfSize:JPRealValue(30)]

// !!!: weakSelf声明
#define weakSelf_declare    __weak typeof(self) weakSelf = self

/*****************************/
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif
/*********分割线************/
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif
/*****************************/

#define JP_UserDefults [NSUserDefaults standardUserDefaults]

// !!!: 友盟推送
static NSString *const JP_UMAppKey = @"5900578e677baa5a60000e09";
static NSString *const JP_UMAppSecret = @"ee5cbeo2lyv4nkrf7pwuinvbnszqwfct";
static NSString *const JP_UMessageAliasType = @"tenantsNumber";

// !!!: 友盟统计
static NSString *const JP_UMMobClickAppKey = @"5976f65404e2053727000b6f";

// !!!: 科大讯飞语音播报
static NSString *const JP_MSCAppKey = @"59083cc6";

// !!!: 通知
static NSString *const kCFUMMessageClickNotification = @"kCFUMMessageClick";
static NSString *const kCFContentInsetNotification = @"kCFContentInset";
static NSString *const kCFRefreshingNotification = @"kCFRefreshing";
static NSString *const kCFHasRefreshedNotification = @"kCFHasRefreshed";

static NSString *const kCFPushNotification = @"kCFPushNotification";
static NSString *const kCFVoiceNotification = @"kCFVoiceNotification";

//  图片数量通知
static NSString *const kCFCredentialsNotification = @"kCFCredentialsInfo";

//  商户自助进件通知
static NSString *const kCFBaseInfoNotification = @"kCFBaseInfo";
static NSString *const kCFBillingInfoNotification = @"kCFBillingInfo";
static NSString *const kCFCredentialsInfoNotification = @"kCFCredentialsInfo";

#endif /* JPMacro_Define_h */
