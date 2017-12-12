//
//  JPDealStateView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealStateView.h"

@interface JPDealStateView ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic ,strong) UILabel *dealLab;
@end

@implementation JPDealStateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}

- (void)handleUserInterface {
    self.logoView = [UIImageView new];
    [self.contentView addSubview:self.logoView];
    
    self.dealLab = [UILabel new];
    self.dealLab.font = JP_DefaultsFont;
    self.dealLab.textColor = JP_NoticeText_Color;
    self.dealLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dealLab];
    
    self.moneyLab = [UILabel new];
    self.moneyLab.font = [UIFont systemFontOfSize:JPRealValue(50)];
    self.moneyLab.textColor = JP_Content_Color;
    self.moneyLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.moneyLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(30));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
    }];
    
    [self.dealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.logoView.mas_bottom).offset(JPRealValue(30));
        make.centerX.equalTo(weakSelf.logoView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(300), JPRealValue(30)));
    }];
    
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dealLab.mas_bottom).offset(JPRealValue(20));
        make.centerX.equalTo(weakSelf.dealLab.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(600), JPRealValue(50)));
    }];
}

- (void)setState:(JPDealState)state {
    switch (state) {
        case JPDealStateSuccess:
        {
            self.logoView.image = [UIImage imageNamed:@"jp_login_resetPsw_suc"];
            self.dealLab.text = @"交易成功";
        }
            break;
        case JPDealStateFailed:
        {
            self.logoView.image = [UIImage imageNamed:@"jp_login_resetPsw_fail"];
            self.dealLab.text = @"交易失败";
        }
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
