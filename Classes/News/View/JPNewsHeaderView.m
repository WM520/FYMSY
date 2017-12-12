//
//  JPNewsHeaderView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNewsHeaderView.h"

@interface JPNewsHeaderView ()
@property (nonatomic, strong) UILabel *timeLab;
@end
@implementation JPNewsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        if (!self.timeLab) {
            self.timeLab = [UILabel new];
            self.timeLab.text = @"15:30";
            self.timeLab.textAlignment = NSTextAlignmentCenter;
            self.timeLab.textColor = [UIColor whiteColor];
            self.timeLab.font = [UIFont systemFontOfSize:JPRealValue(28)];
            self.timeLab.backgroundColor = [UIColor colorWithHexString:@"d4dce1"];
            self.timeLab.layer.cornerRadius = 5;
            self.timeLab.layer.masksToBounds = YES;
            [self.contentView addSubview:self.timeLab];
        }
        weakSelf_declare;
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(JPRealValue(-15));
            //  先写个0 后面setter方法会根据文本宽度更新
            make.size.mas_equalTo(CGSizeMake(0, JPRealValue(32)));
        }];
    }
    return self;
}

- (void)setTimeString:(NSString *)timeString {
    //  当前时间
    NSDate *currentDate = [NSDate date];
    NSString *todayString = [NSDate stringFromDate:currentDate withFormat:@"yyyy-MM-dd"];
    NSDate *today = [NSDate dateFromString:todayString withFormat:@"yyyy-MM-dd"];
    //  交易时间
    NSDate *dealDate = [NSDate dateFromString:timeString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dealDateString = [NSDate stringFromDate:dealDate withFormat:@"yyyy-MM-dd"];
    NSDate *dealTime = [NSDate dateFromString:dealDateString withFormat:@"yyyy-MM-dd"];
//    JPLog(@"%@ - %@ - %d", todayString, dealDateString, [today compareToDate:dealTime]);
    //  昨天的时间
    NSDate *yestodayDate = [NSDate getYesterday];
    NSString *yestodayString = [NSDate stringFromDate:yestodayDate withFormat:@"yyyy-MM-dd"];
    NSDate *yestodayTime = [NSDate dateFromString:yestodayString withFormat:@"yyyy-MM-dd"];
    
    NSString *resultString = nil;
    if ([today compare:dealTime] == NSOrderedSame) {
        //  交易日期为当天
        resultString = [NSDate stringFromDate:dealDate withFormat:@"HH:mm"];
    } else if ([today compare:dealTime] == NSOrderedDescending) {
        //  交易日期在今天之前
        if ([yestodayTime compare:dealTime] == NSOrderedDescending) {
            //  交易日期在昨天之前
            resultString = [NSDate stringFromDate:dealDate withFormat:@"MM-dd HH:mm"];
        } else if ([yestodayTime compare:dealTime] == NSOrderedSame) {
            //  交易日期为昨天
            resultString = [NSString stringWithFormat:@"昨天 %@", [NSDate stringFromDate:dealDate withFormat:@"HH:mm"]];
        } else {
            resultString = timeString;
        }
    } else {
        resultString = timeString;
    }
    CGRect rect = [resultString boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(28)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JPRealValue(28)]} context:nil];
    float width = rect.size.width + JPRealValue(24);
    weakSelf_declare;
    [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, JPRealValue(32)));
    }];
    self.timeLab.text = resultString;
}

@end
