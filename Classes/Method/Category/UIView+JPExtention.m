//
//  UIView+JPExtention.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "UIView+JPExtention.h"

@implementation UIView (JPExtention)

- (void)setJp_size:(CGSize)jp_size {
    CGRect frame = self.frame;
    frame.size = jp_size;
    self.frame = frame;
}

- (CGSize)jp_size {
    return self.frame.size;
}

- (void)setJp_width:(CGFloat)jp_width {
    CGRect frame = self.frame;
    frame.size.width = jp_width;
    self.frame = frame;
}

- (CGFloat)jp_width {
    return  self.frame.size.width;
}

- (void)setJp_height:(CGFloat)jp_height {
    CGRect frame = self.frame;
    frame.size.height = jp_height;
    self.frame = frame;
}

- (CGFloat)jp_height {
    return self.frame.size.height;
}

- (void)setJp_centerX:(CGFloat)jp_centerX {
    CGPoint center = self.center;
    center.x = jp_centerX;
    self.center = center;
}

- (CGFloat)jp_centerX {
    return self.center.x;
}

- (void)setJp_centerY:(CGFloat)jp_centerY {
    CGPoint center = self.center;
    center.y = jp_centerY;
    self.center = center;
}

- (CGFloat)jp_centerY {
    return self.center.y;
}

- (void)setJp_x:(CGFloat)jp_x {
    CGRect frame = self.frame;
    frame.origin.x = jp_x;
    self.frame = frame;
}

- (CGFloat)jp_x {
    return self.frame.origin.x;
}

- (void)setJp_y:(CGFloat)jp_y {
    CGRect frame = self.frame;
    frame.origin.y = jp_y;
    self.frame = frame;
}

- (CGFloat)jp_y {
    return  self.frame.origin.y;
}

- (CGFloat)jp_bottom {
    //    return self.SG_y + self.SG_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setJp_bottom:(CGFloat)jp_bottom {
    self.jp_y = jp_bottom - self.jp_height;
}
@end
