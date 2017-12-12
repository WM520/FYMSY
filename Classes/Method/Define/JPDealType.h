//
//  JPDealType.h
//  JiePos
//
//  Created by Jason_LJ on 2017/5/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JPDealTextColorType) {
    JPDealTextColorTypeFailed = 0,
    JPDealTextColorTypeSuccess = 1,
};

//  可用交易类型汇总
/** 银行卡消费交易*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00001;
/** 银行卡撤销交易*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00002;
/** 银行卡退货交易*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00003;
/** 银行卡余额查询*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00004;
/** 银行卡预授权*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00005;
/** 银行卡预授权撤销*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00006;
/** 银行卡预授权完成(请求)*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00007;
/** 银行卡预授权完成(通知)*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00008;
/** 银行卡预授权完成(请求)撤销*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeT00009;
/** 微信刷卡支付*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeW00001;
/** 微信支付订单查询*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeW00002;
/** 微信支付交易撤销*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeW00003;
/** 微信支付退款*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeW00004;
/** 微信支付退款查询*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeW00005;
/** 微信扫码支付*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeW00006;
/** 微信交易订单关闭*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeW00007;
/** 支付宝刷卡支付*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeA00001;
/** 支付宝支付订单查询*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeA00002;
/** 支付宝支付交易撤销*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeA00003;
/** 支付宝支付退款*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeA00004;
/** 支付宝支付退款查询*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeA00005;
/** 支付宝扫码支付*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeA00006;
/** 支付宝交易订单关闭*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeA00007;
/** 一码付支付宝扫码支付*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeJA001;
/** 一码付支付宝支付查询*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeJA002;
/** 一码付微信扫码支付*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeJW001;
/** 一码付微信支付查询*/
UIKIT_EXTERN NSString *__nonnull const JPAvailDealTypeJW002;




