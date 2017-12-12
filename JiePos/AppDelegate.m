//
//  AppDelegate.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+checkVersions.h"
//  推送
#import <UserNotifications/UserNotifications.h>
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>
//  语音播报
#import <AVFoundation/AVFoundation.h>
//  iOS 10以下推送消息栏
#import <EBBannerView/EBBannerView.h>

#import "IBNewsModel.h"
#import "IBDataBase.h"

@interface AppDelegate () {
    SystemSoundID _soundFileObject;
}
@end
@implementation AppDelegate

//  播放音频文件
- (void)playMusic:(NSString *)name type:(NSString *)type {
    //得到音效文件的地址
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    //将地址字符串转换成url
    NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
    
    //生成系统音效id
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_soundFileObject);
    
    //播放系统音效
    AudioServicesPlaySystemSound(_soundFileObject);
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // !!!: 注册极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //  iOS 10.0以上走推送扩展，声音由文字合成语音，不需要UNAuthorizationOptionSound
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //  iOS 10.0以下需要设置UIUserNotificationTypeSound，通过后台的sound来播放本地音频文件
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:@"19c2762c254577cf78bd8365" channel:@"Publish channel" apsForProduction:YES];
    
    // !!!: 初始化友盟统计
    [self handleUMMobClick];
    
    // !!!: 只执行一次，默认开关全部打开
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.JieposExtention"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [userDefault setBool:YES forKey:@"noti_value"];
        [userDefault setBool:YES forKey:@"voice_value"];
        [userDefault synchronize];
    });
    
    // !!!: 配置信息
    {
        //  iOS 11适配
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            UITableView.appearance.estimatedRowHeight = 0;
            UITableView.appearance.estimatedSectionHeaderHeight = 0;
            UITableView.appearance.estimatedSectionFooterHeight = 0;
        }
        //  HUD
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setForegroundColor:UIColor.blackColor];
        [SVProgressHUD setBackgroundColor:UIColor.whiteColor];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        //  键盘管理
        [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
        [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    }
    
    // !!!: 版本更新
    [self checkVersion];

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // !!!: 设置主Window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupRootViewController];
    
    return YES;
}

#pragma mark - 注册友盟统计
- (void)handleUMMobClick {
    UMConfigInstance.appKey = JP_UMMobClickAppKey;
    UMConfigInstance.ePolicy = SEND_INTERVAL;// 最小间隔发送
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark - 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken\n[第%d行] - %@", __LINE__, deviceToken);
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JP_UserDefults setObject:token forKey:@"deviceToken"];
        [JP_UserDefults synchronize];
    });
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"willPresentNotification:withCompletionHandler:\n[第%d行] - %@", __LINE__, userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"didReceiveNotificationResponse\n[第%d行] - %@", __LINE__, userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

// Required, iOS 7 Support
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification:fetchCompletionHandler:\n[第%d行] - %@", __LINE__, userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    //  iOS 10之前前台没有通知栏
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
        //  应用在前台
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [EBBannerView showWithContent:@"交易结果通知"];
            
            //  获取共享域的偏好设置
            NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.JieposExtention"];
            
            //  解析推送自定义参数transInfo
            NSDictionary *transInfo = [self dictionaryWithUserInfo:userInfo];
            IBNewsModel *model = [IBNewsModel yy_modelWithJSON:transInfo];
            BOOL canSound = [userDefault boolForKey:@"voice_value"];
            if (canSound) {
                if ([model.transactionCode isEqualToString:@"T00002"] ||
                    [model.transactionCode isEqualToString:@"T00003"] ||
                    [model.transactionCode isEqualToString:@"T00009"] ||
                    [model.transactionCode isEqualToString:@"W00003"] ||
                    [model.transactionCode isEqualToString:@"W00004"] ||
                    [model.transactionCode isEqualToString:@"A00003"] ||
                    [model.transactionCode isEqualToString:@"A00004"]) {
                    [self playMusic:@"jprefund" type:@"mp3"];
                } else {
                    [self playMusic:@"jpcollection" type:@"mp3"];
                }
            }
        }
        NSDictionary *transInfo = [self dictionaryWithUserInfo:userInfo];
        IBNewsModel *model = [IBNewsModel yy_modelWithJSON:transInfo];
        [[IBDataBase sharedDataBase] addModel:model];
    }
}

// Required,For systems with less than or equal to iOS6
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification\n[第%d行] - %@", __LINE__, userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

#pragma mark - App的各种状态
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        //  程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
//        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//            JPLog(@"%ld - %@ - %ld", iResCode, iAlias, seq);
//        } seq:0];
//    }];
    NSLog(@"applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}

#pragma mark - 设置根视图控制器
- (void)setupRootViewController {
    //  设置登录界面为根视图
    JPNavigationController *loginNav = [[JPNavigationController alloc] initWithRootViewController:[JPLoginViewController new]];
    self.window.rootViewController = loginNav;
}

//  解析推送消息数据
- (NSDictionary *)dictionaryWithUserInfo:(NSDictionary *)userInfo {
    
    if (userInfo.count <= 0) {
        return nil;
    }
    // FIXME: 需注释
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&parseError];

    NSString *mes = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"mes - %@", [mes stringByReplacingOccurrencesOfString:@"\\" withString:@""]);
    
    NSArray *keys = userInfo.allKeys;
    if ([keys containsObject:@"extra"]) {
        NSDictionary *infoDic = userInfo[@"extra"];
        NSString *jsonString = infoDic[@"transInfo"];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        if(err) {
            JPLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    } else if ([keys containsObject:@"transInfo"]) {
        
        NSString *jsonString = userInfo[@"transInfo"];
        if ([jsonString containsString:@"\\"]) {
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        }
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        if(err) {
            JPLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    } else {
        return nil;
    }
}

@end






