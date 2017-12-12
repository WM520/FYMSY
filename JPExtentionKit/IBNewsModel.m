//
//  IBNewsModel.m
//  JiePos
//
//  Created by iBlocker on 2017/11/9.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBNewsModel.h"

@implementation IBNewsModel
- (NSString *)transactionCode {
    if (!_transactionCode) {
        _transactionCode = @"";
    }
    return _transactionCode;
}

- (NSString *)tenantsName {
    //  获取共享域的偏好设置
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.JieposExtention"];
    return [userDefault objectForKey:@"merchantName"];
}

- (NSString *)couponAmt {
    if (!_couponAmt || _couponAmt.length <= 0) {
        _couponAmt = @"0";
    }
    return _couponAmt;
}

- (NSString *)totalAmt {
    if (!_totalAmt || _totalAmt.length <= 0) {
        _totalAmt = @"0";
    }
    return _totalAmt;
}
@end
