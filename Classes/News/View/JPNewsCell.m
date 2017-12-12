//
//  JPNewsCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNewsCell.h"
#import "JPNewsTitleView.h"

@interface JPNewsCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) JPNewsTitleView *titleView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *dealStateLab;
/** 应付金额*/
@property (nonatomic, strong) UILabel *totalAmtLab;
@property (nonatomic, strong) UILabel *totalAmt;
/** 优惠金额*/
@property (nonatomic, strong) UILabel *couponAmtLab;
@property (nonatomic, strong) UILabel *couponAmt;
/** 交易类型*/
@property (nonatomic, strong) UILabel *dealTypeLab;
@property (nonatomic, strong) UILabel *dealType;
/** 商户名称*/
@property (nonatomic, strong) UILabel *businessNameLab;
@property (nonatomic, strong) UILabel *businessName;
/** 交易时间*/
@property (nonatomic, strong) UILabel *dealTimeLab;
@property (nonatomic, strong) UILabel *dealTime;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *showDeatilLab;
@property (nonatomic, strong) UIImageView *indicatorView;
@end
@implementation JPNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self handleUserInterce];
    }
    return self;
}

- (void)handleUserInterce {
    self.contentView.backgroundColor = JP_viewBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bgView) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor= [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 8;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.borderWidth = 0.3;
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        [self.contentView addSubview:self.bgView];
    }
    if (!self.titleView) {
        self.titleView = [JPNewsTitleView new];
        self.titleView.type = JPNewsTypeCollection;
        [self.bgView addSubview:self.titleView];
    }
    if (!self.titleLab) {
        self.titleLab = [UILabel new];
        self.titleLab.font = [UIFont boldSystemFontOfSize:JPRealValue(48)];
        self.titleLab.textColor = [UIColor colorWithHexString:@"333333"];
        self.titleLab.text = [NSString strmethodComma:@"+576878.2"];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.titleLab];
    }
    if (!self.dealStateLab) {
        self.dealStateLab = [UILabel new];
        self.dealStateLab.font = JP_DefaultsFont;
        self.dealStateLab.textColor = JP_NoticeText_Color;
        self.dealStateLab.textAlignment = NSTextAlignmentCenter;
        self.dealStateLab.text = @"交易成功";
        [self.bgView addSubview:self.dealStateLab];
    }
    //  !!!: 虚线
    {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(JPRealValue(90), JPRealValue(202))];
        [path addLineToPoint:CGPointMake(kScreenWidth - JPRealValue(90), JPRealValue(202))];
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        [pathLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]]; // 设置线为虚线
        pathLayer.lineWidth = 0.5;
        pathLayer.strokeColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        pathLayer.path = path.CGPath;
        [self.layer addSublayer:pathLayer];
    }
    //  !!!: 应付金额
    if (!self.totalAmtLab) {
        self.totalAmtLab = [UILabel new];
        self.totalAmtLab.text = @"应付金额";
        self.totalAmtLab.textColor = JP_Content_Color;
        self.totalAmtLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
        [self.bgView addSubview:self.totalAmtLab];
    }
    if (!self.totalAmt) {
        self.totalAmt = [UILabel new];
        self.totalAmt.textColor = JP_Content_Color;
        self.totalAmt.font = JP_DefaultsFont;
        self.totalAmt.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.totalAmt];
    }
    //  !!!: 优惠金额
    if (!self.couponAmtLab) {
        self.couponAmtLab = [UILabel new];
        self.couponAmtLab.text = @"优惠金额";
        self.couponAmtLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
        self.couponAmtLab.textColor = JP_Content_Color;
        [self.bgView addSubview:self.couponAmtLab];
    }
    if (!self.couponAmt) {
        self.couponAmt = [UILabel new];
        self.couponAmt.textColor = JP_Content_Color;
        self.couponAmt.font = JP_DefaultsFont;
        self.couponAmt.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.couponAmt];
    }
    //  !!!: 交易类型
    if (!self.dealTypeLab) {
        self.dealTypeLab = [UILabel new];
        self.dealTypeLab.text = @"交易方式";
        self.dealTypeLab.textColor = JP_NoticeText_Color;
        self.dealTypeLab.font = JP_DefaultsFont;
        [self.bgView addSubview:self.dealTypeLab];
    }
    if (!self.dealType) {
        self.dealType = [UILabel new];
        self.dealType.text = @"招商银行";
        self.dealType.textColor = JP_Content_Color;
        self.dealType.textAlignment = NSTextAlignmentRight;
        self.dealType.font = JP_DefaultsFont;
        [self.bgView addSubview:self.dealType];
    }
    //  !!!: 商户名称
    if (!self.businessNameLab) {
        self.businessNameLab = [UILabel new];
        self.businessNameLab.text = @"商户名称";
        self.businessNameLab.textColor = JP_NoticeText_Color;
        self.businessNameLab.font = JP_DefaultsFont;
        [self.bgView addSubview:self.businessNameLab];
    }
    if (!self.businessName) {
        self.businessName = [UILabel new];
        self.businessName.text = @"江苏杰博实信息技术有限公司";
        self.businessName.textColor = JP_Content_Color;
        self.businessName.textAlignment = NSTextAlignmentRight;
        self.businessName.font = JP_DefaultsFont;
        [self.bgView addSubview:self.businessName];
    }
    //  !!!: 交易时间
    if (!self.dealTimeLab) {
        self.dealTimeLab = [UILabel new];
        self.dealTimeLab.text = @"交易时间";
        self.dealTimeLab.textColor = JP_NoticeText_Color;
        self.dealTimeLab.font = JP_DefaultsFont;
        [self.bgView addSubview:self.dealTimeLab];
    }
    if (!self.dealTime) {
        self.dealTime = [UILabel new];
        self.dealTime.text = @"2017-05-26 15:00:00";
        self.dealTime.textColor = JP_Content_Color;
        self.dealTime.textAlignment = NSTextAlignmentRight;
        self.dealTime.font = JP_DefaultsFont;
        [self.bgView addSubview:self.dealTime];
    }
    if (!self.lineView) {
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self.bgView addSubview:self.lineView];
    }
    if (!self.showDeatilLab) {
        self.showDeatilLab = [UILabel new];
        self.showDeatilLab.text = @"查看详情";
        self.showDeatilLab.textColor = JP_Content_Color;
        self.showDeatilLab.font = JP_DefaultsFont;
        [self.bgView addSubview:self.showDeatilLab];
    }
    if (!self.indicatorView) {
        self.indicatorView = [UIImageView new];
        self.indicatorView.image = [UIImage imageNamed:@"jp_news_indicator"];
        [self.bgView addSubview:self.indicatorView];
    }
}

- (void)setNewsModel:(IBNewsModel *)newsModel {
    JPLog(@"transactionCode - %@", newsModel.transactionCode);
    if ([newsModel.transactionCode isEqualToString:JPAvailDealTypeT00002] ||
        [newsModel.transactionCode isEqualToString:JPAvailDealTypeT00003] || [newsModel.transactionCode isEqualToString:JPAvailDealTypeT00009] ||
        [newsModel.transactionCode isEqualToString:JPAvailDealTypeW00003] ||
        [newsModel.transactionCode isEqualToString:JPAvailDealTypeW00004] ||
        [newsModel.transactionCode isEqualToString:JPAvailDealTypeA00003] ||
        [newsModel.transactionCode isEqualToString:JPAvailDealTypeA00004]) {
        self.titleView.type = JPNewsTypeRefund;
        self.titleLab.text = [NSString strmethodComma:[NSString stringWithFormat:@"-%@", newsModel.transactionMoney]];
    } else {
        self.titleView.type = JPNewsTypeCollection;
        self.titleLab.text = [NSString strmethodComma:[NSString stringWithFormat:@"+%@", newsModel.transactionMoney]];
    }
    
    NSString *totalAmt = nil;
    if ([JPUserEntity sharedUserEntity].applyType == 1) {
        totalAmt = newsModel.transactionMoney;
    } else {
        totalAmt = newsModel.totalAmt;
        if (!totalAmt || [totalAmt doubleValue] == 0) {
            totalAmt = @"0";
        }
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元", totalAmt]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:JPRealValue(36)] range:NSMakeRange(0, attrStr.length - 2)];
    self.totalAmt.attributedText = attrStr;
    
    NSString *couponAmt = newsModel.couponAmt;
    if (!couponAmt || [couponAmt doubleValue] == 0) {
        couponAmt = @"0";
    }
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元", couponAmt]];
    [attrStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:JPRealValue(36)] range:NSMakeRange(0, attrStr2.length - 2)];
    self.couponAmt.attributedText = attrStr2;
    
    self.dealStateLab.text = newsModel.transactionResult;
    self.dealType.text = newsModel.payType;
    
    NSString *tenantsName = newsModel.tenantsName;
    if (!tenantsName || tenantsName.length <= 0) {
        tenantsName = [JPUserEntity sharedUserEntity].merchantName;
    }
    self.businessName.text = tenantsName;
    self.dealTime.text = newsModel.transactionTime;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float bgWidth = kScreenWidth - JPRealValue(60);
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(JPRealValue(-20));
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(45));
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(JPRealValue(100), JPRealValue(32)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleView.mas_bottom).offset(JPRealValue(32));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-30));
        make.height.equalTo(@(JPRealValue(42)));
    }];
    [self.dealStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(JPRealValue(20));
        make.left.and.right.equalTo(weakSelf.titleLab);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    
    [self.totalAmtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.dealStateLab.mas_bottom).offset(JPRealValue(60));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.totalAmt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-30));
        make.top.equalTo(weakSelf.totalAmtLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(bgWidth - JPRealValue(210), JPRealValue(30)));
    }];
    [self.couponAmtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.totalAmtLab.mas_bottom).offset(JPRealValue(28));
        make.left.equalTo(weakSelf.totalAmtLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.couponAmt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.totalAmt.mas_right);
        make.top.equalTo(weakSelf.couponAmtLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(bgWidth - JPRealValue(210), JPRealValue(30)));
    }];
    
    [self.dealTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.couponAmtLab.mas_bottom).offset(JPRealValue(40));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.dealType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-30));
        make.top.equalTo(weakSelf.dealTypeLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(bgWidth - JPRealValue(210), JPRealValue(30)));
    }];
    [self.businessNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dealTypeLab.mas_bottom).offset(JPRealValue(28));
        make.left.equalTo(weakSelf.dealTypeLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.businessName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.dealType.mas_right);
        make.top.equalTo(weakSelf.businessNameLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(bgWidth - JPRealValue(210), JPRealValue(30)));
    }];
    [self.dealTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.businessNameLab.mas_bottom).offset(JPRealValue(28));
        make.left.equalTo(weakSelf.businessNameLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.dealTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.businessName.mas_right);
        make.top.equalTo(weakSelf.dealTimeLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(bgWidth - JPRealValue(210), JPRealValue(30)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dealTimeLab.mas_bottom).offset(JPRealValue(20));
        make.left.and.right.equalTo(weakSelf.bgView);
        make.height.equalTo(@0.5);
    }];
    [self.showDeatilLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.dealTimeLab.mas_left);
        make.centerY.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(-50));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.showDeatilLab.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
//        make.size.mas_equalTo(CGSizeMake(JPRealValue(13), JPRealValue(21)));
    }];
}

@end
