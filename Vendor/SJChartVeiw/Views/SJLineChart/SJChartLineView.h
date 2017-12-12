//
//  SJChartLineView.h
//  SJChartViewDemo
//
//  Created by Jaesun on 16/9/9.
//  Copyright © 2016年 S.J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAxisView.h"

@interface SJChartLineView : SJAxisView

@property (nonatomic, strong) NSArray *valueArray;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSArray *xMarkTitles;

@property (nonatomic, assign) CGFloat maxValue;

/**
 *  绘图
 */
- (void)mapping;

/**
 *  更新折线图数据
 */
- (void)reloadDatas;

@end

