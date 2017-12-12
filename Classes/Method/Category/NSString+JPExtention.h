//
//  NSString+JPExtention.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JPExtention)

//  简单富文本
+ (NSMutableAttributedString *)attributeString:(NSString *)originString rangeStr:(NSString *)rangeStr rangeColor:(UIColor *)rangeColor rangeFont:(UIFont *)rangeFont;

//  金额格式化，除小数点后，其它每3位加逗号
+ (NSString *)strmethodComma:(NSString *)string;

+ (BOOL)judgePassWordLegal:(NSString *)text;

/**
 *  手机号中间4位转化为*
 */
+ (NSString *)secretWithMobile:(NSString *)mobile;

/**
 获取文本高度

 @param text 文本
 @param width 宽度
 @param font 字体尺寸
 @return 文本高度
 */
+ (CGRect)getHeightOfText:(NSString *)text
                    width:(CGFloat)width
                     font:(UIFont *)font;

/**
 判断是不是Email
 */
- (BOOL)isEmail;
/**
 判断Url是否正确
 */
- (BOOL)isURLString;
/**
 判断手机号是否正确
 */
- (BOOL)isPhone;
/**
 判断是否是中文
 */
- (BOOL)isChinese;

//  身份证号认证
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;
@end
