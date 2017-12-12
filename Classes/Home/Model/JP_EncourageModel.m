//
//  JP_EncourageModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/7.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JP_EncourageModel.h"

@implementation JP_EncourageModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"encourageID":@"id"
             };
}

- (NSString *)totalFees {
    if (!_totalFees) {
        _totalFees = @"0";
        return _totalFees;
    } else {
        return [NSString stringWithFormat:@"%.2f", _totalFees.doubleValue];
    }
}

- (NSString *)byMonth {
    if (!_byMonth) {
        _byMonth = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM"];
    }
    return _byMonth;
}
@end
