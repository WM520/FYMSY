//
//  JPRegisterProgressHeaderView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/22.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPRegisterProgressHeaderView.h"

@interface JPRegisterProgressHeaderView ()
//@property (nonatomic, strong) UIImageView *bgView;
//@property (nonatomic, strong) UIImageView *stepView;
@property (nonatomic, strong) JPRegisterProgressView *progressView;
@end
@implementation JPRegisterProgressHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
//        [self handleUserInterface];
        [self.contentView addSubview:self.progressView];
    }
    return self;
}

- (JPRegisterProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[JPRegisterProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, JPRealValue(340))];
    }
    return _progressView;
}

- (void)handleUserInterface {
    self.contentView.backgroundColor = JP_viewBackgroundColor;
    
//    self.bgView = [UIImageView new];
//    self.bgView.image = [UIImage imageNamed:@"jp_login_registerStepBg"];
//    [self.contentView addSubview:self.bgView];
//    
//    self.stepView = [UIImageView new];
//    [self.contentView addSubview:self.stepView];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    weakSelf_declare;
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.and.right.equalTo(weakSelf.contentView);
//        make.height.equalTo(@(JPRealValue(240)));
//    }];
//    
//    [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
//        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
//    }];
//}

- (void)setSteps:(JPProgressOfApplySteps)steps {
    switch (steps) {
        case JPStepsBaseInfo:
//            self.stepView.image = [UIImage imageNamed:@"jp_login_registerStep1"];
            self.progressView.steps = JPStepsBaseInfo;
            break;
        case JPStepsBillingInfo:
//            self.stepView.image = [UIImage imageNamed:@"jp_login_registerStep2"];
            self.progressView.steps = JPStepsBillingInfo;
            break;
        case JPStepsCertificateInfo:
//            self.stepView.image = [UIImage imageNamed:@"jp_login_registerStep3"];
            self.progressView.steps = JPStepsCertificateInfo;
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
