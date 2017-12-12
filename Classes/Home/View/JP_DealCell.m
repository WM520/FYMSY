//
//  JP_DealCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/10.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JP_DealCell.h"

@implementation JPDealFlowExtentionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self handleUserIdentifier];
    }
    return self;
}
#pragma mark - Method
- (void)handleUserIdentifier {
    self.businessID = [YYLabel new];
    self.businessID.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.businessID];
    
    
    self.serverBusiness = [YYLabel new];
    self.serverBusiness.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.serverBusiness];
    
    
    self.terminalNo = [YYLabel new];
    self.terminalNo.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.terminalNo];
    
    
    self.dealType = [YYLabel new];
    self.dealType.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.dealType];
    
    
    self.dealState = [YYLabel new];
    self.dealState.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.dealState];
    
    
    self.payWay = [YYLabel new];
    self.payWay.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.payWay];
    
    self.payCardNo = [YYLabel new];
    self.payCardNo.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.payCardNo];
    
    
    self.poundage = [YYLabel new];
    self.poundage.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.poundage];
    
    
    self.actualMoney = [YYLabel new];
    self.actualMoney.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.actualMoney];
    
    
    self.signingMoney = [YYLabel new];
    self.signingMoney.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.signingMoney];
    
    
    self.platfromNo = [YYLabel new];
    self.platfromNo.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.platfromNo];
    
    self.returnCode = [YYLabel new];
    self.returnCode.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.returnCode];
    
}

- (void)setDealModel:(JPDealFlowModel *)dealModel {
    UIColor *orignColor = nil;
    UIColor *finalColor = nil;
    if (self.colorType == JPDealTextColorTypeFailed && [dealModel.transName isEqualToString:@"交易失败"]) {
        orignColor = [UIColor redColor];
        finalColor = [UIColor redColor];
    } else {
        orignColor = JP_NoticeText_Color;
        finalColor = JP_Content_Color;
    }
    self.businessID.attributedText = [self getAttributeStringWithKeyStr:@"商户号：" valueStr:dealModel.mchntCd originColor:orignColor finalColor:finalColor];
    self.serverBusiness.attributedText = [self getAttributeStringWithKeyStr:@"服务商：" valueStr:dealModel.instName originColor:orignColor finalColor:finalColor];
    self.terminalNo.attributedText = [self getAttributeStringWithKeyStr:@"终端号：" valueStr:dealModel.termId originColor:orignColor finalColor:finalColor];
    
    self.dealType.attributedText = [self getAttributeStringWithKeyStr:@"交易类型：" valueStr:dealModel.opeName originColor:orignColor finalColor:finalColor];
    self.dealState.attributedText = [self getAttributeStringWithKeyStr:@"交易状态：" valueStr:dealModel.transName originColor:orignColor finalColor:finalColor];
    self.payWay.attributedText = [self getAttributeStringWithKeyStr:@"支付方式：" valueStr:dealModel.payName originColor:orignColor finalColor:finalColor];
    self.payCardNo.attributedText = [self getAttributeStringWithKeyStr:@"支付卡号：" valueStr:dealModel.priAcctNo originColor:orignColor finalColor:finalColor];//    dealModel.transactionId
    self.poundage.attributedText = [self getAttributeStringWithKeyStr:@"手续费（元）：" valueStr:dealModel.merFee originColor:orignColor finalColor:finalColor];
    
    self.actualMoney.attributedText = [self getAttributeStringWithKeyStr:@"实到金额（元）：" valueStr:dealModel.realmoney originColor:orignColor finalColor:finalColor];
    self.signingMoney.attributedText = [self getAttributeStringWithKeyStr:@"签约费率：" valueStr:dealModel.rate originColor:orignColor finalColor:finalColor];
    self.platfromNo.attributedText = [self getAttributeStringWithKeyStr:@"平台流水账号：" valueStr:dealModel.sysTraNo originColor:orignColor finalColor:finalColor];
    self.returnCode.attributedText = [self getAttributeStringWithKeyStr:@"返回码：" valueStr:dealModel.respCd originColor:orignColor finalColor:finalColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.businessID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.serverBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_right);
        make.centerY.equalTo(weakSelf.businessID.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.terminalNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.businessID.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.dealType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.terminalNo.mas_top);
        make.left.equalTo(weakSelf.terminalNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.dealState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.terminalNo.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dealState.mas_top);
        make.left.equalTo(weakSelf.dealState.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.payCardNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.dealState.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.poundage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.payCardNo.mas_top);
        make.left.equalTo(weakSelf.payCardNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.actualMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.payCardNo.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.signingMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.actualMoney.mas_top);
        make.left.equalTo(weakSelf.actualMoney.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.platfromNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.actualMoney.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.returnCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.platfromNo.mas_top);
        make.left.equalTo(weakSelf.platfromNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
}
- (NSMutableAttributedString *)getAttributeStringWithKeyStr:(NSString *)keyStr valueStr:(NSString *)valueStr originColor:(UIColor *)originColor finalColor:(UIColor *)finalColor {
    NSMutableAttributedString *combiStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", keyStr, valueStr]];
    if (keyStr.length > 0) {
        NSRange range1 = [[combiStr string] rangeOfString:keyStr options:NSCaseInsensitiveSearch];
        //文字颜色
        [combiStr yy_setColor:originColor range:range1];
    }
    if (valueStr.length > 0) {
        NSRange range2 = [[combiStr string] rangeOfString:valueStr options:NSCaseInsensitiveSearch];
        //文字颜色
        [combiStr yy_setColor:finalColor range:range2];
    }
    return combiStr;
}
@end

@implementation JPDealFlowExtentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self handleUserIdentifier];
    }
    return self;
}
#pragma mark - Method
- (void)handleUserIdentifier {
    self.businessID = [YYLabel new];
    self.businessID.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.businessID];
    
    
    self.serverBusiness = [YYLabel new];
    self.serverBusiness.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.serverBusiness];
    
    
    self.terminalNo = [YYLabel new];
    self.terminalNo.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.terminalNo];
    
    
    self.dealType = [YYLabel new];
    self.dealType.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.dealType];
    
    
    self.dealState = [YYLabel new];
    self.dealState.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.dealState];
    
    
    self.payWay = [YYLabel new];
    self.payWay.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.payWay];
    
    self.payCardNo = [YYLabel new];
    self.payCardNo.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.payCardNo];
    
    
    self.poundage = [YYLabel new];
    self.poundage.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.poundage];
    
    
    self.originDealMoney = [YYLabel new];
    self.originDealMoney.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.originDealMoney];
    
    
    self.reductionMoney = [YYLabel new];
    self.reductionMoney.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.reductionMoney];
    
    
    self.actualMoney = [YYLabel new];
    self.actualMoney.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.actualMoney];
    
    
    self.signingMoney = [YYLabel new];
    self.signingMoney.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.signingMoney];
    
    
    self.platfromNo = [YYLabel new];
    self.platfromNo.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.platfromNo];
    
    self.returnCode = [YYLabel new];
    self.returnCode.font = [UIFont systemFontOfSize:JPRealValue(24)];
    [self.contentView addSubview:self.returnCode];
    
}

- (void)setDealModel:(JPDealFlowModel *)dealModel {
    UIColor *orignColor = nil;
    UIColor *finalColor = nil;
    if (self.colorType == JPDealTextColorTypeFailed && [dealModel.transName isEqualToString:@"交易失败"]) {
        orignColor = [UIColor redColor];
        finalColor = [UIColor redColor];
    } else {
        orignColor = JP_NoticeText_Color;
        finalColor = JP_Content_Color;
    }
    self.businessID.attributedText = [self getAttributeStringWithKeyStr:@"商户号：" valueStr:dealModel.mchntCd originColor:orignColor finalColor:finalColor];
    self.serverBusiness.attributedText = [self getAttributeStringWithKeyStr:@"服务商：" valueStr:dealModel.instName originColor:orignColor finalColor:finalColor];
    self.terminalNo.attributedText = [self getAttributeStringWithKeyStr:@"终端号：" valueStr:dealModel.termId originColor:orignColor finalColor:finalColor];
    
    self.dealType.attributedText = [self getAttributeStringWithKeyStr:@"交易类型：" valueStr:dealModel.opeName originColor:orignColor finalColor:finalColor];
    self.dealState.attributedText = [self getAttributeStringWithKeyStr:@"交易状态：" valueStr:dealModel.transName originColor:orignColor finalColor:finalColor];
    self.payWay.attributedText = [self getAttributeStringWithKeyStr:@"支付方式：" valueStr:dealModel.payName originColor:orignColor finalColor:finalColor];
    self.payCardNo.attributedText = [self getAttributeStringWithKeyStr:@"支付卡号：" valueStr:dealModel.priAcctNo originColor:orignColor finalColor:finalColor];//    dealModel.transactionId
    self.poundage.attributedText = [self getAttributeStringWithKeyStr:@"手续费（元）：" valueStr:dealModel.merFee originColor:orignColor finalColor:finalColor];
    
    self.originDealMoney.attributedText = [self getAttributeStringWithKeyStr:@"原交易金额（元）：" valueStr:dealModel.discountableAmount originColor:orignColor finalColor:finalColor];
    
    self.reductionMoney.attributedText = [self getAttributeStringWithKeyStr:@"优惠减免（元）：" valueStr:dealModel.undiscountableAmount originColor:orignColor finalColor:finalColor];
    
    self.actualMoney.attributedText = [self getAttributeStringWithKeyStr:@"实到金额（元）：" valueStr:dealModel.realmoney originColor:orignColor finalColor:finalColor];
    self.signingMoney.attributedText = [self getAttributeStringWithKeyStr:@"签约费率：" valueStr:dealModel.rate originColor:orignColor finalColor:finalColor];
    self.platfromNo.attributedText = [self getAttributeStringWithKeyStr:@"平台流水账号：" valueStr:dealModel.sysTraNo originColor:orignColor finalColor:finalColor];
    self.returnCode.attributedText = [self getAttributeStringWithKeyStr:@"返回码：" valueStr:dealModel.respCd originColor:orignColor finalColor:finalColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.businessID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.serverBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_right);
        make.centerY.equalTo(weakSelf.businessID.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.terminalNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.businessID.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.dealType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.terminalNo.mas_top);
        make.left.equalTo(weakSelf.terminalNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.dealState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.terminalNo.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dealState.mas_top);
        make.left.equalTo(weakSelf.dealState.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.payCardNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.dealState.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.poundage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.payCardNo.mas_top);
        make.left.equalTo(weakSelf.payCardNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.originDealMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.payCardNo.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.reductionMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.originDealMoney.mas_top);
        make.left.equalTo(weakSelf.originDealMoney.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.actualMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.originDealMoney.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.signingMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.actualMoney.mas_top);
        make.left.equalTo(weakSelf.actualMoney.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.platfromNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.actualMoney.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
    
    [self.returnCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.platfromNo.mas_top);
        make.left.equalTo(weakSelf.platfromNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(30)) / 2.0, JPRealValue(24)));
    }];
}
- (NSMutableAttributedString *)getAttributeStringWithKeyStr:(NSString *)keyStr valueStr:(NSString *)valueStr originColor:(UIColor *)originColor finalColor:(UIColor *)finalColor {
    NSMutableAttributedString *combiStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", keyStr, valueStr]];
    if (keyStr.length > 0) {
        NSRange range1 = [[combiStr string] rangeOfString:keyStr options:NSCaseInsensitiveSearch];
        //文字颜色
        [combiStr yy_setColor:originColor range:range1];
    }
    if (valueStr.length > 0) {
        NSRange range2 = [[combiStr string] rangeOfString:valueStr options:NSCaseInsensitiveSearch];
        //文字颜色
        [combiStr yy_setColor:finalColor range:range2];
    }
    return combiStr;
}
@end
