//
//  JPNewsTitleView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNewsTitleView.h"

@interface JPNewsTitleView ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *titleLab;
@end
@implementation JPNewsTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (!self.logoView) {
            self.logoView = [UIImageView new];
            [self addSubview:self.logoView];
        }
        if (!self.titleLab) {
            self.titleLab = [UILabel new];
            self.titleLab.font = JP_DefaultsFont;
            self.titleLab.textColor = JP_Content_Color;
            [self addSubview:self.titleLab];
        }
        weakSelf_declare;
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(31), JPRealValue(32)));
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(10));
            make.right.equalTo(weakSelf.mas_right);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.height.equalTo(@(JPRealValue(32)));
        }];
    }
    return self;
}
- (void)setType:(JPNewsType)type {
    if (type == JPNewsTypeCollection) {
        self.logoView.image = [UIImage imageNamed:@"jp_news_collection"];
        self.titleLab.text = @"收款";
    } else {
        self.logoView.image = [UIImage imageNamed:@"jp_news_refund"];
        self.titleLab.text = @"退款";
    }
}
@end
