//
//  JPNetworkUtils.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^netStateBlock)(NSInteger netState);
@interface JPNetworkUtils : NSObject
/**
 网络监测

 @param block 判断结果回调
 */
+ (void)netWorkState:(netStateBlock)block;
@end
