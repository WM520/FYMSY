//
//  JP_DealCell.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/10.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPDealFlowModel.h"

@interface JPDealFlowExtentionCell : UITableViewCell
@property (nonatomic, assign) JPDealTextColorType colorType;
/** 商户号*/
@property (nonatomic, strong) YYLabel *businessID;
/** 服务商*/
@property (nonatomic, strong) YYLabel *serverBusiness;
/** 终端号*/
@property (nonatomic, strong) YYLabel *terminalNo;
/** 交易类型*/
@property (nonatomic, strong) YYLabel *dealType;
/** 交易状态*/
@property (nonatomic, strong) YYLabel *dealState;
/** 支付方式*/
@property (nonatomic, strong) YYLabel *payWay;
/** 支付卡号*/
@property (nonatomic, strong) YYLabel *payCardNo;
/** 手续费（元）*/
@property (nonatomic, strong) YYLabel *poundage;
/** 实到金额（元）*/
@property (nonatomic, strong) YYLabel *actualMoney;
/** 签约费率*/
@property (nonatomic, strong) YYLabel *signingMoney;
/** 平台流水账号*/
@property (nonatomic, strong) YYLabel *platfromNo;
/** 返回码*/
@property (nonatomic, strong) YYLabel *returnCode;

@property (nonatomic, strong) JPDealFlowModel *dealModel;
@end

@interface JPDealFlowExtentCell : UITableViewCell
@property (nonatomic, assign) JPDealTextColorType colorType;
/** 商户号*/
@property (nonatomic, strong) YYLabel *businessID;
/** 服务商*/
@property (nonatomic, strong) YYLabel *serverBusiness;
/** 终端号*/
@property (nonatomic, strong) YYLabel *terminalNo;
/** 交易类型*/
@property (nonatomic, strong) YYLabel *dealType;
/** 交易状态*/
@property (nonatomic, strong) YYLabel *dealState;
/** 支付方式*/
@property (nonatomic, strong) YYLabel *payWay;
/** 支付卡号*/
@property (nonatomic, strong) YYLabel *payCardNo;
/** 手续费（元）*/
@property (nonatomic, strong) YYLabel *poundage;
/** 原交易金额（元）*/
@property (nonatomic, strong) YYLabel *originDealMoney;
/** 优惠减免（元）*/
@property (nonatomic, strong) YYLabel *reductionMoney;
/** 实到金额（元）*/
@property (nonatomic, strong) YYLabel *actualMoney;
/** 签约费率*/
@property (nonatomic, strong) YYLabel *signingMoney;
/** 平台流水账号*/
@property (nonatomic, strong) YYLabel *platfromNo;
/** 返回码*/
@property (nonatomic, strong) YYLabel *returnCode;

@property (nonatomic, strong) JPDealFlowModel *dealModel;
@end

