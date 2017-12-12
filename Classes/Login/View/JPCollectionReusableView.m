//
//  JPCollectionReusableView.m
//  ColletionView
//
//  Created by Jason_LJ on 2017/6/1.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCollectionReusableView.h"
#import "JPRegisterProgressView.h"

//  !!!:JPCollectHeaderView
@interface JPCollectHeaderView ()
@property (nonatomic, strong) JPRegisterProgressView *progressView;
@end
@implementation JPCollectHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.progressView];
    }
    return self;
}
- (JPRegisterProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[JPRegisterProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, JPRealValue(360))];
        _progressView.steps = JPStepsCertificateInfo;
    }
    return _progressView;
}
@end

//  !!!:JPCollectFooterView
@implementation JPCollectFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float origin_y = JPRealValue(30);
        
        UILabel *promptLab = [[UILabel alloc] initWithFrame:CGRectMake(JPRealValue(30), origin_y + JPRealValue(30), kScreenWidth - JPRealValue(60), JPRealValue(60))];
        promptLab.text = @"注：图片清晰可见，信息完整无缺失，身份照片真实，严禁经过处理";
        promptLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        promptLab.textColor = JP_NoticeRedColor;
        promptLab.numberOfLines = 0;
        promptLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:promptLab];
        
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(JPRealValue(64), origin_y + JPRealValue(120), kScreenWidth - JPRealValue(128), JPRealValue(90));
        [nextButton setTitle:@"确定提交" forState:UIControlStateNormal];
        nextButton.titleLabel.font = JP_DefaultsFont;
        nextButton.backgroundColor = JPBaseColor;
        nextButton.layer.cornerRadius = 5;
        nextButton.layer.masksToBounds = YES;
        [nextButton addTarget:self action:@selector(handleNextEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        self.confirmButton = nextButton;
        
        UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previousButton.frame = CGRectMake(JPRealValue(64), origin_y + JPRealValue(230), kScreenWidth - JPRealValue(128), JPRealValue(90));
        [previousButton setTitle:@"返回上一步" forState:UIControlStateNormal];
        [previousButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        previousButton.titleLabel.font = JP_DefaultsFont;
        [previousButton addTarget:self action:@selector(handlePreviousEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:previousButton];
    }
    return self;
}
#pragma mark - action
- (void)handleNextEvent:(UIButton *)sender {
    if (self.jp_commitUserInfoBlock) {
        self.jp_commitUserInfoBlock();
    }
}
- (void)handlePreviousEvent:(UIButton *)sender {
    if (self.jp_backBlock) {
        self.jp_backBlock();
    }
}
@end
