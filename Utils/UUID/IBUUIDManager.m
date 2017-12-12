//
//  IBUUIDManager.m
//  JiePos
//
//  Created by iBlocker on 2017/8/28.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBUUIDManager.h"
#import "IBKeychainStore.h"

#define  KEY_USERNAME_PASSWORD @"com.jiepos.app.jiepos"

@implementation IBUUIDManager

+ (NSString *)getUUID {
    NSString * strUUID = (NSString *)[IBKeychainStore load:KEY_USERNAME_PASSWORD];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID) {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [IBKeychainStore save:KEY_USERNAME_PASSWORD data:strUUID];
    }
    return strUUID;
}

@end
