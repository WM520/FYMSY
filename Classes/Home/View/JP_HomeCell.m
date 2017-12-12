//
//  JP_HomeCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/7.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JP_HomeCell.h"

@interface JP_HomeCell ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *searchButton;
@end
@implementation JP_HomeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.detailButton];
        [self.bgView addSubview:self.searchButton];
        [self.bgView addSubview:self.sumLab];
    }
    return self;
}

- (void)setCellType:(JP_HomeCellType)cellType {
    switch (cellType) {
        case JP_HomeCellTypeYesterday: {
            //  昨日累计交易金额
            self.bgView.image = [UIImage imageNamed:@"jp_home_yesterday1"];
            self.titleLab.text = @"昨日累计交易金额（元）";
            self.detailButton.hidden = YES;
            self.searchButton.hidden = YES;
        }
            break;
        case JP_HomeCellTypeThisWeek: {
            //  本周累计返还鼓励金
            self.bgView.image = [UIImage imageNamed:@"jp_home_theweek1"];
            self.titleLab.text = @"本月累计返还鼓励金（元）";
            self.searchButton.hidden = YES;
        }
            break;
        case JP_HomeCellTypeDealSearch: {
            //  交易查询
            self.bgView.image = [UIImage imageNamed:@"jp_home_dealsearch1"];
            self.titleLab.text = @"";
            self.detailButton.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-20));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(60));
        make.top.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(24));
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-35));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(110), JPRealValue(40)));
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(weakSelf.bgView);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(212), JPRealValue(56)));
    }];
    [self.sumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY).offset(JPRealValue(25));
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:JPRealValue(26)];
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_detailButton setImage:[UIImage imageNamed:@"jp_home_small_indicator"] forState:UIControlStateNormal];
        _detailButton.imageEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(90), 0, JPRealValue(-20));
        _detailButton.titleEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(-16), 0, 0);
        _detailButton.userInteractionEnabled = NO;
        
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(20)];
        _detailButton.layer.cornerRadius = JPRealValue(5);
        _detailButton.layer.masksToBounds = YES;
        _detailButton.layer.borderWidth = 1;
        _detailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _detailButton;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"交易查询" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"jp_home_big_indicator"] forState:UIControlStateNormal];
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(160), 0, JPRealValue(-20));
        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(-20), 0, JPRealValue(20));
        _searchButton.userInteractionEnabled = NO;
        
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(34)];
        _searchButton.layer.cornerRadius = JPRealValue(6);
        _searchButton.layer.masksToBounds = YES;
        _searchButton.layer.borderWidth = 1;
        _searchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _searchButton;
}

- (UILabel *)sumLab {
    if (!_sumLab) {
        _sumLab = [UILabel new];
        _sumLab.textAlignment = NSTextAlignmentCenter;
        _sumLab.font = [UIFont boldSystemFontOfSize:JPRealValue(60)];
        _sumLab.textColor = [UIColor whiteColor];
    }
    return _sumLab;
}
@end
