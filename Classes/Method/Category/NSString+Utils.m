//
//  NSString+Utils.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/22.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)
// !!!: 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber {
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

// !!!: 正则匹配用户密码6-20位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

// !!!: 正则匹配用户姓名,2-10位的中文
+ (BOOL)checkUserName:(NSString *)userName {
    NSString *pattern = @"^[\u4E00-\u9FA5]{2,10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

// !!!: 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard:(NSString *)idCard {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
@end
