//
//  UIImage+JPExtention.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JPExtention)

/** 图片裁剪（圆角）*/
- (UIImage *)jp_imageByRoundCornerRadius:(CGFloat)radius;

- (UIImage *)jp_imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;

- (UIImage *)jp_imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

+ (UIImage *)jp_imageWithColor:(UIColor *)color;

/** 图片压缩到指定大小*/
- (UIImage *)jp_scalingImageForSize:(CGSize)targetSize;
- (UIImage *)jp_scaleToTargetWidth:(CGFloat)targetWidth;

- (UIImage *)jp_imageWithCornerRadius:(CGFloat)radius;
@end
