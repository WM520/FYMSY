//
//  AppDelegate+checkVersions.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "AppDelegate+checkVersions.h"

@interface IBVersionModel : NSObject
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *isUpdate;
@property (nonatomic, copy) NSString *isVoice;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *version;
@end
@implementation IBVersionModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}
@end

@implementation AppDelegate (checkVersions)

#pragma mark - 监测版本更新
- (void)checkVersion {

    NSString *url = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_version_url];
    
    //获取本地软件的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"fym" forKey:@"appCode"];
    [params setObject:@"ios" forKey:@"platform"];
    
    weakSelf_declare;
    [JPNetworking postUrl:url params:params progress:nil callback:^(id resp) {
        //updateFlag    0非强制更新,1强制更新
        JPLog(@"更新 - %@", resp);
        if ([resp isKindOfClass:[NSDictionary class]]) {
            
            IBVersionModel *model = [IBVersionModel yy_modelWithJSON:resp];
            
            BOOL isUpdate = [model.isUpdate boolValue];
            
            if ([localVersion compare:model.version] == NSOrderedAscending) {
                if (isUpdate) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.center = weakSelf.window.center;
                    btn.bounds = CGRectMake(0, 0, 100, 40);
                    [btn setTitle:@"立即更新" forState:UIControlStateNormal];
                    [btn setTitleColor:JP_NoticeRedColor forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(gotoItunes) forControlEvents:UIControlEventTouchUpInside];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"体验新版本" message:model.desc delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert setValue:btn forKey:@"accessoryView"];
                    [alert show];
                } else {
                    JPLog(@"不更新");
                }
            }
        }
    }];
}

- (void)gotoItunes {
    //  https://itunes.apple.com/cn/app/飞燕码上付/id1230358841?mt=8
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/%E9%A3%9E%E7%87%95%E7%A0%81%E4%B8%8A%E4%BB%98/id1230358841?l=zh&ls=1&mt=8"]];
}

@end
