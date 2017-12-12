//
//  JPRegisterProgressView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/23.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPRegisterProgressView.h"

@interface JPRegisterProgressView ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *stepView;
@end
@implementation JPRegisterProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}

- (void)handleUserInterface {
    self.backgroundColor = JP_viewBackgroundColor;
    
    self.bgView = [UIImageView new];
    self.bgView.image = [UIImage imageNamed:@"jp_login_registerStepBg"];
    self.bgView.userInteractionEnabled = YES;
    [self addSubview:self.bgView];
    
    self.stepView = [UIImageView new];
    [self addSubview:self.stepView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(weakSelf);
        make.height.equalTo(@(JPRealValue(240)));
    }];
    
    [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_bottom);
    }];
}

- (void)setSteps:(JPProgressOfApplySteps)steps {
    switch (steps) {
        case JPStepsBaseInfo:
            self.stepView.image = [UIImage imageNamed:@"jp_login_registerStep1"];
            break;
        case JPStepsBillingInfo:
            self.stepView.image = [UIImage imageNamed:@"jp_login_registerStep2"];
            break;
        case JPStepsCertificateInfo:
            self.stepView.image = [UIImage imageNamed:@"jp_login_registerStep3"];
            break;
        default:
            break;
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
