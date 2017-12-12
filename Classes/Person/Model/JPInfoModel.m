//
//  JPInfoModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPInfoModel.h"

@implementation JPInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"infoID":@"id"
             };
}
@end
