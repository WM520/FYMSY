//
//  UIColor+JPFormHex.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JPFormHex)
///颜色转换 十六进制的颜色转换为UIColor
//+ (UIColor *)colorWithHex:(UInt32)hex;

+ (UIColor *)colorWithHexString:(NSString *)color;

///
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
