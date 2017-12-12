//
//  JPNetworkUtils.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNetworkUtils.h"
#import "AFNetworkReachabilityManager.h"

@implementation JPNetworkUtils
#pragma mark----网络检测
+ (void)netWorkState:(netStateBlock)block {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    //检测的结果
    __block typeof(self) bself = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 0 || status == -1) {
            //弹出提示框
            [bself showWarningView];
            //将netState值传入block中
            block(status);
        } else {
            //将netState值传入block中
            block(status);
        }
    }];
}
#pragma mark---网络断开时弹出提示框
+ (void)showWarningView {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络已断开，请检查网络设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alter show];
}
#pragma mark---alertView点击事件
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"取消");
    } else {
        NSString * urlString = @"App-Prefs:root=WIFI";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}
@end
