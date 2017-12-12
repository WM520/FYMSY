//
//  SJLineChart.m
//  SJChartViewDemo
//
//  Created by Jaesun on 16/9/9.
//  Copyright © 2016年 S.J. All rights reserved.
//

#import "SJLineChart.h"

#import "SJChartLineView.h"
#import "SJAxisView.h"

@interface SJLineChart() {
    
    NSMutableArray *keyArray;
    NSMutableArray *valueArray;
    
}

/**
 *  表名标签
 */
@property (nonatomic, strong) UILabel *titleLab;

/**
 *  显示折线图的可滑动视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  折线图
 */
@property (nonatomic, strong) SJChartLineView *chartLineView;

/**
 *  X轴刻度标签 和 对应的折线图点的值
 */
@property (nonatomic, strong) NSArray *xMarkTitlesAndValues;

@end

@implementation SJLineChart

- (void)setXScaleMarkLEN:(CGFloat)xScaleMarkLEN {
    _xScaleMarkLEN = xScaleMarkLEN;
}

- (void)setYMarkTitles:(NSArray *)yMarkTitles {
    _yMarkTitles = yMarkTitles;
}



- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
 
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
}

- (void)setXMarkTitlesAndValues:(NSArray *)xMarkTitlesAndValues titleKey:(NSString *)titleKey valueKey:(NSString *)valueKey {
    
    _xMarkTitlesAndValues = xMarkTitlesAndValues;
    
    if (keyArray) {
        [keyArray removeAllObjects];
    }
    else {
        keyArray = [NSMutableArray arrayWithCapacity:0];

    }
    
    if (valueArray) {
        [valueArray removeAllObjects];
    }
    else {
        valueArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    for (NSDictionary *dic in xMarkTitlesAndValues) {
        
        [keyArray addObject:[dic objectForKey:titleKey]];
        [valueArray addObject:[dic objectForKey:valueKey]];
    }
}

#pragma mark 绘图
- (void)mapping {
    
    static CGFloat topToContainView = 0.f;
    
    if (self.title) {
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.frame), 20)];
        self.titleLab.text = self.title;
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        topToContainView = 25;
    }
    
    if (!self.xMarkTitlesAndValues) {
        
        keyArray = @[@1,@2,@3,@4,@5].mutableCopy;
        valueArray = @[@2,@2,@2,@2,@2].mutableCopy;
        
        NSLog(@"折线图keyArray");
        NSLog(@"折线图需要一个转折点值的数组valueArray");
    }

    if (!self.xMarkTitles) {
        self.xMarkTitles = @[@0,@1,@2,@3,@4,@5];
        NSLog(@"折线图需要一个显示X轴刻度标签的数组xMarkTitles");
    }
    
    if (!self.yMarkTitles) {
        self.yMarkTitles = @[@0,@1,@2,@3,@4,@5];
        NSLog(@"折线图需要一个显示Y轴刻度标签的数组yMarkTitles");
    }
    

    if (self.maxValue == 0) {
        self.maxValue = 5;
        NSLog(@"折线图需要一个最大值maxValue");
        
    }
        
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topToContainView, self.frame.size.width,self.frame.size.height - topToContainView)];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:self.scrollView];
    
    self.chartLineView = [[SJChartLineView alloc] initWithFrame:self.scrollView.bounds];

    //  传值
    self.chartLineView.yMarkTitles = self.yMarkTitles;
    self.chartLineView.xMarkTitles = self.xMarkTitles;
    self.chartLineView.xScaleMarkLEN = self.xScaleMarkLEN;
    self.chartLineView.valueArray = valueArray;
    self.chartLineView.keyArray = keyArray;
    self.chartLineView.maxValue = self.maxValue;
    self.chartLineView.xMarkTitles = self.xMarkTitles;
    
    [self.scrollView addSubview:self.chartLineView];
    
    [self.chartLineView mapping];
    
    self.scrollView.contentSize = self.chartLineView.bounds.size;
   
}

#pragma mark 更新数据
- (void)reloadDatas {
    [self.chartLineView reloadDatas];
}


@end
