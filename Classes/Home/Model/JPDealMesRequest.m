//
//  JPDealMesRequest.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealMesRequest.h"

@implementation JPDealMesRequest

//  请求商户可查询信息
+ (void)showCondFLowCallback:(ZJNetCallback)callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JPUserEntity sharedUserEntity].merchantId forKey:@"merchantId"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_showCondFLow_url];
    
    [JPNetworking postUrl:url params:params progress:nil callback:^(id resp) {
        if (callback) {
            callback (resp);
        }
    }];

}

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
                         callback:(ZJNetCallback)callback {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(msgFlag) forKey:@"msgFlag"];
    [params setObject:@(mercFlag) forKey:@"mercFlag"];
    [params setObject:merchantNo forKey:@"merchantNo"];
    [params setObject:@(merchantId) forKey:@"merchantId"];
    [params setObject:userName forKey:@"userName"];
    [params setObject:startTime forKey:@"startTime"];
    [params setObject:endTime forKey:@"endTime"];
    [params setObject:currentPageTime forKey:@"currentPageTime"];
    [params setObject:type forKey:@"type"];
    [params setObject:payChannel forKey:@"payChannel"];
    [params setObject:@(startRow) forKey:@"startRow"];
        
    NSString *url = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_getFlowListByCond_url];
    
    [JPNetworking postUrl:url params:params progress:nil callback:^(id resp) {
        if (callback) {
            callback (resp);
        }
    }];
}
@end
