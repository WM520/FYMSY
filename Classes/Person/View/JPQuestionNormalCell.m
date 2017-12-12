//
//  JPQuestionNormalCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPQuestionNormalCell.h"

@interface JPQuestionNormalCell ()
@property (nonatomic, strong) UILabel       *quesLab;
@property (nonatomic, strong) UIImageView   *indicatorView;
@property (nonatomic, strong) UILabel       *lineLab;
@end
@implementation JPQuestionNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lineLab = [UILabel new];
        self.lineLab.backgroundColor = JP_LineColor;
        [self.contentView addSubview:self.lineLab];
        
        self.quesLab = [UILabel new];
        self.quesLab.text = @"1、刷卡无反应";
        self.quesLab.font = [UIFont systemFontOfSize:JPRealValue(28)];
        self.quesLab.textColor = JP_Content_Color;
        [self.contentView addSubview:self.quesLab];
        
        self.indicatorView = [UIImageView new];
        self.indicatorView.image = [UIImage imageNamed:@"jp_home_close"];
        [self.contentView addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.bottom.and.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(25), JPRealValue(25)));
    }];
    
    [self.quesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.indicatorView.mas_left).offset(JPRealValue(26));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
