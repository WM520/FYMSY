//
//  UIView+JPExtention.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JPExtention)
/*
 在分类中声明@property，只会生成方法的声明，不会生成方法的实现和带有_下划线的成员变量
 */
@property (nonatomic, assign) CGSize  jp_size;
@property (nonatomic, assign) CGFloat jp_width;
@property (nonatomic, assign) CGFloat jp_height;
@property (nonatomic, assign) CGFloat jp_centerX;
@property (nonatomic, assign) CGFloat jp_centerY;
@property (nonatomic, assign) CGFloat jp_x;
@property (nonatomic, assign) CGFloat jp_y;
@property (nonatomic, assign) CGFloat jp_bottom;
@end
