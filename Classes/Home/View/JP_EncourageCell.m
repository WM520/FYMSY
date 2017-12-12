//
//  JP_EncourageCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/7.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JP_EncourageCell.h"

@interface JP_EncourageCell ()
@property (nonatomic, strong) UIView *pointView;
@end
@implementation JP_EncourageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.pointView];
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView addSubview:self.dateLab];
        [self.contentView addSubview:self.numLab];
    }
    return self;
}
#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(60));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(14), JPRealValue(14)));
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.pointView.mas_top);
        make.centerX.equalTo(weakSelf.pointView.mas_centerX);
        make.width.equalTo(@1);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pointView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.centerX.equalTo(weakSelf.pointView.mas_centerX);
        make.width.equalTo(@1);
    }];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.pointView.mas_right).offset(JPRealValue(30));
        make.centerY.equalTo(weakSelf.pointView.mas_centerY);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-60));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
}

#pragma mark - Lazy
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [UIView new];
        _topLineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _topLineView;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _bottomLineView;
}
- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [UIView new];
        _pointView.backgroundColor = JP_NoticeRedColor;
        _pointView.layer.cornerRadius = JPRealValue(7);
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}
- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [UILabel new];
        _dateLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _dateLab.textColor = JP_Content_Color;
    }
    return _dateLab;
}
- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.text = @"0元";
        _numLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _numLab.textColor = JP_NoticeRedColor;
        _numLab.textAlignment = NSTextAlignmentRight;
    }
    return _numLab;
}
@end

@interface JP_EncourageHeaderView ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation JP_EncourageHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.merchantLab];
        [self.contentView addSubview:self.logoView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.encourageLab];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo((UIEdgeInsets){0, 0, 0, 0});
        make.left.and.top.and.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@(JPRealValue(280)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(40));
        make.size.mas_equalTo(CGSizeMake(3, JPRealValue(34)));
    }];
    [self.merchantLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineView.mas_right).offset(JPRealValue(10));
        make.centerY.equalTo(weakSelf.lineView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(60));
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(JPRealValue(30));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.logoView.mas_centerY);
    }];
    [self.encourageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-60));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
    }];
}
#pragma mark - Lazy
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"jp_home_banner"];
    }return _bgView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = JP_NoticeRedColor;
    }
    return _lineView;
}
- (UILabel *)merchantLab {
    if (!_merchantLab) {
        _merchantLab = [UILabel new];
        _merchantLab.font = [UIFont boldSystemFontOfSize:JPRealValue(34)];
        _merchantLab.textColor = JP_Content_Color;
    }
    return _merchantLab;
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"jp_home_encourage"];
    }
    return _logoView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _titleLab.text = @"累计已取得鼓励金";
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UILabel *)encourageLab {
    if (!_encourageLab) {
        _encourageLab = [UILabel new];
        _encourageLab.text = @"0元";
        _encourageLab.font = [UIFont boldSystemFontOfSize:JPRealValue(40)];
        _encourageLab.textColor = JP_NoticeRedColor;
        _encourageLab.textAlignment = NSTextAlignmentRight;
    }
    return _encourageLab;
}
@end
