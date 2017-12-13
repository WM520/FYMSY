//
//  NotificationService.m
//  JPServiceNotification
//
//  Created by iBlocker on 2017/10/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>
#import <JPExtentionKit/JPExtentionKit.h>
#import <YYModel/YYModel.h>
#import "IBDataBase.h"
#import "IBNewsModel.h"

@interface NotificationService ()<AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    self.bestAttemptContent.sound = nil;
    
    // Modify the notification content here...
//    self.bestAttemptContent.body = [NSString stringWithFormat:@"%@ [来自Jiepos]", self.bestAttemptContent.body];
    
    //  获取共享域的偏好设置
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.JieposExtention"];
    
    //  解析推送自定义参数transInfo
    NSDictionary *transInfo = [self dictionaryWithUserInfo:self.bestAttemptContent.userInfo];
    IBNewsModel *model = [IBNewsModel yy_modelWithJSON:transInfo];
    
    BOOL canSound = [userDefault boolForKey:@"voice_value"];
    NSString *voiceString = nil;
    if (canSound) {
        if ([model.transactionCode isEqualToString:@"T00002"] ||
            [model.transactionCode isEqualToString:@"T00003"] ||
            [model.transactionCode isEqualToString:@"T00009"] ||
            [model.transactionCode isEqualToString:@"W00003"] ||
            [model.transactionCode isEqualToString:@"W00004"] ||
            [model.transactionCode isEqualToString:@"A00003"] ||
            [model.transactionCode isEqualToString:@"A00004"]) {
            voiceString = [NSString stringWithFormat:@"退款%@元！", model.transactionMoney];
        } else {
            voiceString = [NSString stringWithFormat:@"收款%@元！", model.transactionMoney];
        }
    }
    //  数据本地存储
    [[IBDataBase sharedDataBase] addModel:model];
    //  语音合成
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;
    AVSpeechUtterance *speechUtterance = [AVSpeechUtterance speechUtteranceWithString:voiceString];
    
    //设置语言类别（不能被识别，返回值为nil）
    speechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    //设置语速快慢
    speechUtterance.rate = 0.55;
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    //语音合成器会生成音频
    [self.synthesizer speakUtterance:speechUtterance];
    

    
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

//  解析推送消息数据
- (NSDictionary *)dictionaryWithUserInfo:(NSDictionary *)userInfo {
    
    if (userInfo.count <= 0) {
        return nil;
    }
    NSArray *keys = userInfo.allKeys;
    if ([keys containsObject:@"transInfo"]) {
        
        NSString *jsonString = userInfo[@"transInfo"];
        if ([jsonString containsString:@"\\"]) {
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        }
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    } else {
        return nil;
    }
}

@end
