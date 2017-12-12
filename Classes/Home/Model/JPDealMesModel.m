//
//  JPDealMesModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealMesModel.h"

@implementation JPDealMesModel
//把数组里面带有对象的类型专门按照这个方法，这个格式写出来*****
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{
             @"tranStatList2" : JPDealStateModel.class,
                @"mercList"   : JPDealBusinessNameModel.class,
                  @"payList2" : JPDealPayWayModel.class
             };
}

@end
