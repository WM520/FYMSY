//
//  JPHomeModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPHomeChartModel : NSObject
/** 每日累计交易额*/
@property (nonatomic, strong) NSString *sumDayTransAt;
/** 交易日日期*/
@property (nonatomic, strong) NSString *recCrtDt;
@end

@interface JPHomeModel : NSObject
/**
 {
 "merchantNo" : "998320582110001",
 "yesDate" : "20170418",
 "feeIn" : 1,
 "refundSuccess" : 1,
 "curMonthMerFee" : 0,
 "curMonthTransAt" : 0,
 "refundFail" : 0,
 "feeOut" : -1,
 },
 "firstDate" : "20170401"
 }
 */
/** 当月累计手续费*/
@property (nonatomic, strong) NSString *curMonthMerFee;
/** 当月累计交易金额*/
@property (nonatomic, strong) NSString *curMonthTransAt;
@end
