//
//  SJAxisView.m
//  SJChartViewDemo
//
//  Created by Jaesun on 16/9/6.
//  Copyright © 2016年 S.J. All rights reserved.
//

#import "SJAxisView.h"

#import "SJChartLineView.h"

/**
 *  Y轴刻度标签 与 Y轴 之间 空隙
 */
#define HORIZON_YMARKLAB_YAXISLINE 10.f

/**
 *  Y轴刻度标签  宽度
 */
#define YMARKLAB_WIDTH 60.f

/**
 *  Y轴刻度标签  高度
 */
#define YMARKLAB_HEIGHT 16.f
/**
 *  X轴刻度标签  宽度
 */

#define XMARKLAB_WIDTH 60.f

/**
 *  X轴刻度标签  高度
 */
#define XMARKLAB_HEIGHT 16.f

/**
 *  最上边的Y轴刻度标签距离顶部的 距离
 */
#define YMARKLAB_TO_TOP 30.f

@interface SJAxisView() 

/**
 *  与x轴平行的网格线的间距(与坐标系视图的高度和y轴刻度标签的个数相关)
 */
@property (nonatomic, assign) CGFloat yScaleMarkLEN;

@end

@implementation SJAxisView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        axisViewHeight = frame.size.height;
        axisViewWidth = frame.size.width;
        
        CGFloat  start_X = HORIZON_YMARKLAB_YAXISLINE + YMARKLAB_WIDTH;
        CGFloat  start_Y = YMARKLAB_HEIGHT / 2.0 + YMARKLAB_TO_TOP;
        
        self.startPoint = CGPointMake(start_X, start_Y);
    }
    
    return self;
}

- (void)setXScaleMarkLEN:(CGFloat)xScaleMarkLEN {
    _xScaleMarkLEN = xScaleMarkLEN;
}

- (void)setYMarkTitles:(NSArray *)yMarkTitles {
    _yMarkTitles = yMarkTitles;
}

- (void)setXMarkTitles:(NSArray *)xMarkTitles {
    _xMarkTitles = xMarkTitles;
}

#pragma mark 绘图
- (void)mapping {

    if(self.yMarkTitles.count == 1) {
        
        NSLog(@"怎么只有一条数据呢，没比较，折线图意义何在？");
        
        return;
    }

    if(self.xMarkTitles.count == 1) {
        
        NSLog(@"怎么只有一条数据呢，没比较，折线图意义何在？");
        return;
    }
    
    self.yScaleMarkLEN = (self.frame.size.height - YMARKLAB_HEIGHT - XMARKLAB_HEIGHT - YMARKLAB_TO_TOP) / (self.yMarkTitles.count - 1);
   
    self.yAxis_L = self.yScaleMarkLEN * (self.yMarkTitles.count - 1);
    
    if (self.xScaleMarkLEN == 0) {
        self.xScaleMarkLEN = (axisViewWidth - HORIZON_YMARKLAB_YAXISLINE - YMARKLAB_WIDTH - XMARKLAB_WIDTH / 2.0) / (self.xMarkTitles.count - 1);
    }
    else {
        axisViewWidth = self.xScaleMarkLEN * (self.xMarkTitles.count - 1) + HORIZON_YMARKLAB_YAXISLINE + YMARKLAB_WIDTH + XMARKLAB_WIDTH / 2.0;
    }
    
    self.xAxis_L = self.xScaleMarkLEN * (self.xMarkTitles.count - 1);
    
    self.frame  = CGRectMake(0, 0, axisViewWidth, axisViewHeight);
    
    [self setupYMarkLabs];
    [self setupXMarkLabs];
    
//    [self drawYAxsiLine];
    [self drawXAxsiLine];
    
    //  需求中不需要这条线
//    [self drawYGridline];
    [self drawXGridline];
}

#pragma mark 更新坐标轴数据
- (void)reloadDatas {
    [self clearView];
    [self mapping];
}

#pragma mark  Y轴上的刻度标签
- (void)setupYMarkLabs {

    CGFloat maxValue = [[self.yMarkTitles valueForKeyPath:@"@max.floatValue"] floatValue];
    for (int i = 0; i < self.yMarkTitles.count; i ++) {
        
        UILabel *markLab = [self viewWithTag:i + 999];
        if (!markLab) {
            markLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.startPoint.y - YMARKLAB_HEIGHT / 2 + i * self.yScaleMarkLEN - self.yScaleMarkLEN / 2.0, YMARKLAB_WIDTH, YMARKLAB_HEIGHT)];
            markLab.textAlignment = NSTextAlignmentRight;
            markLab.textColor = JP_NoticeText_Color;
            markLab.tag = i + 999;
            if (maxValue >= 100000) {
                markLab.font = [UIFont systemFontOfSize:10.0];
            } else {
                markLab.font = [UIFont systemFontOfSize:12.0];
            }
            markLab.text = [NSString stringWithFormat:@"%@", self.yMarkTitles[self.yMarkTitles.count - 1 - i]];
            [self addSubview:markLab];
        }
    }
}

#pragma mark  X轴上的刻度标签
- (void)setupXMarkLabs {

    for (int i = 0;i < self.xMarkTitles.count; i ++) {
        
        UILabel *markLab = [self viewWithTag:i + 888];
        if (!markLab) {
            markLab = [[UILabel alloc] initWithFrame:CGRectMake(self.startPoint.x - XMARKLAB_WIDTH / 2 + i * self.xScaleMarkLEN, self.yAxis_L + self.startPoint.y + YMARKLAB_HEIGHT / 2, XMARKLAB_WIDTH, XMARKLAB_HEIGHT)];
            markLab.textAlignment = NSTextAlignmentCenter;
            markLab.font = [UIFont systemFontOfSize:11.0];
            markLab.textColor = JP_NoticeText_Color;
            markLab.tag = i + 888;
            
            NSDate *date = [NSDate dateFromString:self.xMarkTitles[i] withFormat:@"M月dd日"];
            NSInteger weekends = [date dayOfWeek];
            if (weekends == 1) {
                markLab.text = self.xMarkTitles[i];
            }
            [self addSubview:markLab];
        }
    }
}

#pragma mark  Y轴
- (void)drawYAxsiLine {
    UIBezierPath *yAxisPath = [[UIBezierPath alloc] init];
    [yAxisPath moveToPoint:CGPointMake(self.startPoint.x, self.startPoint.y + self.yAxis_L)];
    [yAxisPath addLineToPoint:CGPointMake(self.startPoint.x, self.startPoint.y)];
    
    CAShapeLayer *yAxisLayer = [CAShapeLayer layer];
    [yAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], @0, nil]];
//    [yAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1.5], nil]];    // 设置线为虚线
    yAxisLayer.lineWidth = 0.5;
    yAxisLayer.strokeColor = [UIColor redColor].CGColor;
    yAxisLayer.path = yAxisPath.CGPath;
    [self.layer addSublayer:yAxisLayer];
}

#pragma mark  X轴
- (void)drawXAxsiLine {
    UIBezierPath *xAxisPath = [[UIBezierPath alloc] init];
    [xAxisPath moveToPoint:CGPointMake(self.startPoint.x, self.yAxis_L + self.startPoint.y)];
    [xAxisPath addLineToPoint:CGPointMake(self.xAxis_L + self.startPoint.x, self.yAxis_L + self.startPoint.y)];
    
    CAShapeLayer *xAxisLayer = [CAShapeLayer layer];
//    [xAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1.5], nil]];
    [xAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], @0, nil]];
//    xAxisLayer.lineWidth = 0.5;
//    xAxisLayer.strokeColor = [UIColor redColor].CGColor;
    xAxisLayer.lineWidth = 0.2;
    xAxisLayer.strokeColor = JP_NoticeText_Color.CGColor;
    xAxisLayer.path = xAxisPath.CGPath;
    [self.layer addSublayer:xAxisLayer];
}

#pragma mark  与 Y轴 平行的网格线
- (void)drawYGridline {
    for (int i = 0; i < self.xMarkTitles.count - 1; i ++) {
        
        CGFloat curMark_X = self.startPoint.x + self.xScaleMarkLEN * (i + 1);
        
        UIBezierPath *yAxisPath = [[UIBezierPath alloc] init];
        [yAxisPath moveToPoint:CGPointMake(curMark_X, self.yAxis_L + self.startPoint.y)];
        [yAxisPath addLineToPoint:CGPointMake(curMark_X, self.startPoint.y)];
        
        CAShapeLayer *yAxisLayer = [CAShapeLayer layer];
//        [yAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1.5], nil]]; // 设置线为虚线
        [yAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], @0, nil]];
        yAxisLayer.lineWidth = 0.5;
        yAxisLayer.strokeColor = [UIColor blackColor].CGColor;
        yAxisLayer.path = yAxisPath.CGPath;
        [self.layer addSublayer:yAxisLayer];
    }
}

#pragma mark  与 X轴 平行的网格线
- (void)drawXGridline {
    for (int i = 0; i < self.yMarkTitles.count - 1; i ++) {
        
        CGFloat curMark_Y = self.yScaleMarkLEN * i;
        
        UIBezierPath *xAxisPath = [[UIBezierPath alloc] init];
        [xAxisPath moveToPoint:CGPointMake(self.startPoint.x, curMark_Y + self.startPoint.y)];
        [xAxisPath addLineToPoint:CGPointMake(self.startPoint.x + self.xAxis_L, curMark_Y + self.startPoint.y)];
        
        CAShapeLayer *xAxisLayer = [CAShapeLayer layer];
//        [xAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1.5], nil]];
        [xAxisLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], @0, nil]];
        xAxisLayer.lineWidth = 0.2;
//        xAxisLayer.strokeColor = [UIColor blackColor].CGColor;
        xAxisLayer.strokeColor = JP_NoticeText_Color.CGColor;
        xAxisLayer.path = xAxisPath.CGPath;
        [self.layer addSublayer:xAxisLayer];
    }
}

#pragma mark- 清空视图
- (void)clearView {
    
    [self removeAllSubLabs];
    [self removeAllSubLayers];
}

#pragma mark 清空标签
- (void)removeAllSubLabs {
   
    NSArray *subviews = [NSArray arrayWithArray:self.subviews];
   
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark 清空网格线
- (void)removeAllSubLayers{

    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

@end
