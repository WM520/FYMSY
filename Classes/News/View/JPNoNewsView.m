//
//  JPNoNewsView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/27.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNoNewsView.h"

@implementation JPNoNewsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}

- (void)handleUserInterface {
    self.backgroundColor = JP_viewBackgroundColor;
    
    UIImageView *bgView = [self viewWithTag:100];
    if (!bgView) {
        bgView = [UIImageView new];
        bgView.tag = 100;
        [self addSubview:bgView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImageView *bgView = [self viewWithTag:100];
    weakSelf_declare;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(JPRealValue(-60));
    }];
}

- (void)setResult:(JPResult)result {
    UIImageView *bgView = [self viewWithTag:100];
    switch (result) {
        case JPResultNoNews:
        {
            bgView.image = [UIImage imageNamed:@"jp_result_noNews"];
        }
            break;
        case JPResultNoData:
        {
            bgView.image = [UIImage imageNamed:@"jp_result_noData"];
        }
            break;
        case JPResultNoNet:
        {
            bgView.image = [UIImage imageNamed:@"jp_result_noNet"];
        }
            break;
        case JPResultNoNotice:
        {
            bgView.image = [UIImage imageNamed:@"jp_result_noNotice"];
        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.result == JPResultNoNet) {
        if ([self.delegate respondsToSelector:@selector(touchScreen:)]) {
            [self.delegate touchScreen:self];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
