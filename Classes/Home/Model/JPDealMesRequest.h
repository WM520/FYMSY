//
//  JPDealMesRequest.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDealMesRequest : NSObject

+ (void)showCondFLowCallback:(ZJNetCallback)callback;

/**
 交易流水查询列表、消息通知交易列表

 @param msgFlag         1:消息通知的交易列表；否则，为交易查询列表
 @param mercFlag        0:不选择下拉框，1：选择下拉框条件，不可为空
 @param merchantNo      不管是选择条件还是不选择都传参
 @param merchantId      不管是选择条件还是不选择都传参
 @param userName        商户名称
 @param startTime       20170326162749
 @param endTime         20170326162749
 @param currentPageTime 上一页的最后一行数据的交易日期：20170326162749
 @param type            交易状态
 @param payChannel      交易方式
 @param startRow        每页的开始行
 @param callback        回调
 */
+ (void)getDealMesListWithMsgFlag:(NSInteger)msgFlag
                         mercFlag:(NSInteger)mercFlag
                       merchantNo:(NSString *)merchantNo
                       merchantId:(NSInteger)merchantId
                         userName:(NSString *)userName
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                  currentPageTime:(NSString *)currentPageTime
                             type:(NSString *)type
                       payChannel:(NSString *)payChannel
                         startRow:(NSInteger)startRow
                         callback:(ZJNetCallback)callback;
@end
