//
//  JPCodeModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCodeModel.h"

@implementation JPCodeModel
- (void)setMerchantName:(NSString *)merchantName {
    if (merchantName.length <= 0) {
        merchantName = [NSString secretWithMobile:[JPUserEntity sharedUserEntity].jp_user];
    }
    _merchantName = merchantName;
}
@end
