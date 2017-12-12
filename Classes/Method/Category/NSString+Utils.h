//
//  NSString+Utils.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/22.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
// !!!: 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;
// !!!: 正则匹配用户密码6-20位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password;
// !!!: 正则匹配用户姓名,2-10位的中文
+ (BOOL)checkUserName:(NSString *)userName;
// !!!: 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard:(NSString *)idCard;
@end
