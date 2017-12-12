//
//  JPHomeModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPHomeModel.h"
@implementation JPHomeChartModel
- (void)setSumDayTransAt:(NSString *)sumDayTransAt {
    double sumDay = [sumDayTransAt doubleValue];
    _sumDayTransAt = [NSString stringWithFormat:@"%.2lf", sumDay];
}
- (void)setRecCrtDt:(NSString *)recCrtDt {
    NSDate *date = [NSDate dateFromString:recCrtDt withFormat:@"yyyyMMdd"];
    _recCrtDt = [NSDate stringFromDate:date withFormat:@"M月dd日"];
}
@end

@implementation JPHomeModel
- (void)setCurMonthMerFee:(NSString *)curMonthMerFee {
    if ([curMonthMerFee isEqual:[NSNull null]] || curMonthMerFee == nil) {
        curMonthMerFee = @"0";
    }
    _curMonthMerFee = curMonthMerFee;
}
- (void)setCurMonthTransAt:(NSString *)curMonthTransAt {
    if ([curMonthTransAt isEqual:[NSNull null]]) {
        curMonthTransAt = @"0";
    }
    _curMonthTransAt = curMonthTransAt;
}
@end
