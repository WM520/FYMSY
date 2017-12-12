//
//  JPMenuView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPMenuView.h"

@implementation JPMenuView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<NSString *>*)dataSource {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
        [self handleUserInterface];
    }
    return self;
}

- (void)handleUserInterface {
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat buttonWidth = kScreenWidth / self.dataSource.count;
    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        UIButton *button = [self viewWithTag:i + 100];
        if (!button) {
            self.lastTag = 100;
            self.selectedIndex = 0;
            
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, self.frame.size.height - lineHeight);
            button.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(28)];
            button.tag = i + 100;
            if (self.selectedIndex == 0) {
                if (i == 0) {
                    [button setTitle:self.dataSource[0] forState:UIControlStateNormal];
                    [button setTitleColor:JPBaseColor forState:UIControlStateNormal];
                } else {
                    [button setTitle:self.dataSource[i] forState:UIControlStateNormal];
                    [button setTitleColor:JP_Content_Color forState:UIControlStateNormal];
                }
            }
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:button];
    }
    [self addSubview:self.lineView];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - lineHeight, kScreenWidth / self.dataSource.count, lineHeight)];
        _lineView.backgroundColor = JPBaseColor;
    }
    return _lineView;
}

- (void)buttonClick:(UIButton *)sender {
    UIButton *lastButton = [self viewWithTag:self.lastTag];
    [lastButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
    
    [sender setTitleColor:JPBaseColor forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.frame = CGRectMake((sender.tag - 100) * (kScreenWidth / self.dataSource.count), self.frame.size.height - lineHeight, kScreenWidth / self.dataSource.count, lineHeight);
    }];
    self.lastTag = sender.tag;
    if (self.jpMenuBlock) {
        self.jpMenuBlock(sender.tag);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    UIButton *lastButton = [self viewWithTag:self.lastTag];
    [lastButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
    
    UIButton *selectedButton = [self viewWithTag:100 + selectedIndex];
    [selectedButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
    
    self.lastTag = selectedIndex + 100;
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.frame = CGRectMake(selectedIndex * (kScreenWidth / self.dataSource.count), self.frame.size.height - lineHeight, kScreenWidth / self.dataSource.count, lineHeight);
    }];
}

@end
