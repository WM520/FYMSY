//
//  JPDealStateModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealStateModel.h"

@implementation JPDealStateModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"businessNameId":@"id"
             };
}
@end
