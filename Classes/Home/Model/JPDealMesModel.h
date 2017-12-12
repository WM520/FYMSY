//
//  JPDealMesModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPDealBusinessNameModel.h"
#import "JPDealStateModel.h"
#import "JPDealPayWayModel.h"

@interface JPDealMesModel : NSObject

/** 店铺类型   1：普通    2：总店    3：分店*/
@property (nonatomic, copy) NSString *merchantType;

/** 交易状态*/
@property (nonatomic, strong) NSArray *tranStatList2;

/** 商户下拉框*/
@property (nonatomic, strong) NSArray *mercList;

/** 支付方式*/
@property (nonatomic, strong) NSArray *payList2;
@end
