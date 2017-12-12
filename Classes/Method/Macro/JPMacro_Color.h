//
//  JPMacro_Color.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#ifndef JPMacro_Color_h
#define JPMacro_Color_h

#define JPRGBColor(R, G, B, a) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:a]

//  基础色 蓝色
#define JPBaseColor [UIColor colorWithHexString:@"709bfc"]
//  线的颜色
#define JP_LineColor [UIColor colorWithHexString:@"c3c3c3"]
//  提示文本颜色
#define JP_NoticeText_Color [UIColor colorWithHexString:@"888888"]
//  文字色
#define JP_Content_Color [UIColor colorWithHexString:@"555555"]
//  背景色
#define JP_viewBackgroundColor [UIColor colorWithHexString:@"f4f9fc"]
//  边框线颜色
#define JP_LayerColor [UIColor colorWithHexString:@"cccccc"]
//  提示文字红色
#define JP_NoticeRedColor [UIColor colorWithHexString:@"f06060"]

#endif /* JPMacro_Color_h */
