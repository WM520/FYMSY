//
//  JPApplyUserInfoCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/25.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPUserInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

// !!!: JPOnlyOneSelectCell
@implementation JPOnlyOneSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.bgView) {
            self.bgView = [UIView new];
            self.bgView.layer.cornerRadius = JPRealValue(10);
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.borderWidth = 0.5;
            self.bgView.layer.borderColor = JP_LayerColor.CGColor;
            [self.contentView addSubview:self.bgView];
        }
        if (!self.tipView) {
            self.tipView = [UIImageView new];
            self.tipView.image = [UIImage imageNamed:@"jp_login_tip"];
            self.tipView.userInteractionEnabled = YES;
            [self.bgView addSubview:self.tipView];
        }
        if (!self.textLab) {
            self.textLab = [UILabel new];
//            self.textLab.text = @"选择省/市/区/县";
            self.textLab.font = JP_DefaultsFont;
            self.textLab.textColor = JP_NoticeText_Color;
            [self.bgView addSubview:self.textLab];
        }
        
        weakSelf_declare;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
            make.height.equalTo(@(JPRealValue(70)));
        }];
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
        }];
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.tipView.mas_left).offset(JPRealValue(-20));
            make.height.equalTo(@(JPRealValue(30)));
        }];
    }
    return self;
}
- (void)setIsEditing:(BOOL)isEditing {
    weakSelf_declare;
    if (isEditing) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JPBaseColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JP_LayerColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}
@end

// !!!: JPOnlyTwoSelectCell
@implementation JPOnlyTwoSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.leftButton) {
            self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftButton.tag = 10086;
            self.leftButton.layer.cornerRadius = JPRealValue(10);
            self.leftButton.layer.masksToBounds = YES;
            self.leftButton.layer.borderWidth = 0.5;
            self.leftButton.layer.borderColor = JP_LayerColor.CGColor;
            [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.leftButton];
        }
        if (!self.rightButton) {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightButton.tag = 10010;
            self.rightButton.layer.cornerRadius = JPRealValue(10);
            self.rightButton.layer.masksToBounds = YES;
            self.rightButton.layer.borderWidth = 0.5;
            self.rightButton.layer.borderColor = JP_LayerColor.CGColor;
            [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.rightButton];
        }
        if (!self.tipView1) {
            self.tipView1 = [UIImageView new];
            self.tipView1.image = [UIImage imageNamed:@"jp_login_tip"];
            self.tipView1.userInteractionEnabled = YES;
            [self.leftButton addSubview:self.tipView1];
        }
        if (!self.tipView2) {
            self.tipView2 = [UIImageView new];
            self.tipView2.image = [UIImage imageNamed:@"jp_login_tip"];
            self.tipView2.userInteractionEnabled = YES;
            [self.rightButton addSubview:self.tipView2];
        }
        if (!self.textLab1) {
            self.textLab1 = [UILabel new];
//            self.textLab1.text = @"选择市";
            self.textLab1.font = JP_DefaultsFont;
            self.textLab1.textColor = JP_NoticeText_Color;
            [self.leftButton addSubview:self.textLab1];
        }
        if (!self.textLab2) {
            self.textLab2 = [UILabel new];
//            self.textLab2.text = @"选择区/县";
            self.textLab2.font = JP_DefaultsFont;
            self.textLab2.textColor = JP_NoticeText_Color;
            [self.rightButton addSubview:self.textLab2];
        }
        
        weakSelf_declare;
        CGFloat width = (kScreenWidth - JPRealValue(120)) / 2.0;
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
            make.size.mas_equalTo(CGSizeMake(width, JPRealValue(70)));
        }];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
            make.right.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.height.equalTo(@(JPRealValue(70)));
        }];
        
        [self.tipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.leftButton.mas_right).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
        }];
        [self.tipView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.rightButton.mas_right).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
        }];
        [self.textLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
            make.left.equalTo(weakSelf.leftButton.mas_left).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.tipView1.mas_left).offset(JPRealValue(-20));
            make.height.equalTo(@(JPRealValue(30)));
        }];
        [self.textLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
            make.left.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.tipView2.mas_left).offset(JPRealValue(-20));
            make.height.equalTo(@(JPRealValue(30)));
        }];
    }
    return self;
}

#pragma mark - Action
- (void)leftButtonClick:(UIButton *)sender {
    if (self.jpOnlyTwoSelect_leftBlock) {
        self.jpOnlyTwoSelect_leftBlock(sender, self.textLab1);
    }
}
- (void)rightButtonClick:(UIButton *)sender {
    if (self.jpOnlyTwoSelect_rightBlock) {
        self.jpOnlyTwoSelect_rightBlock(sender, self.textLab2);
    }
}
@end

// !!!: JPOneSelectCell
@implementation JPOneSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.bgView) {
            self.bgView = [UIView new];
            self.bgView.layer.cornerRadius = JPRealValue(10);
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.borderWidth = 0.5;
            self.bgView.layer.borderColor = JP_LayerColor.CGColor;
            [self.contentView addSubview:self.bgView];
        }
        if (!self.titleLab) {
            self.titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
            self.titleLab.font = JP_DefaultsFont;
            self.titleLab.textColor = JP_Content_Color;
            [self.bgView addSubview:self.titleLab];
        }
        
        if (!self.tipView) {
            self.tipView = [UIImageView new];
            self.tipView.image = [UIImage imageNamed:@"jp_login_tip"];
            self.tipView.userInteractionEnabled = YES;
            [self.bgView addSubview:self.tipView];
        }
        if (!self.textLab) {
            self.textLab = [UILabel new];
            self.textLab.text = @"选择省/市/区/县";
            self.textLab.font = JP_DefaultsFont;
            self.textLab.textColor = JP_NoticeText_Color;
            [self.bgView addSubview:self.textLab];
        }
        
        weakSelf_declare;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
            make.height.equalTo(@(JPRealValue(70)));
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            //        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
            make.width.equalTo(@(JPRealValue(10)));
            make.height.equalTo(@(JPRealValue(30)));
        }];
        
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
        }];
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.tipView.mas_left).offset(JPRealValue(-20));
            make.height.equalTo(@(JPRealValue(30)));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    weakSelf_declare;
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    self.titleLab.text = title;
}

- (void)setIsEditing:(BOOL)isEditing {
    weakSelf_declare;
    if (isEditing) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JPBaseColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JP_LayerColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}
@end

// !!!: JPTwoSelectCell
@implementation JPTwoSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.leftButton) {
            self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftButton.tag = 10086;
            self.leftButton.layer.cornerRadius = JPRealValue(10);
            self.leftButton.layer.masksToBounds = YES;
            self.leftButton.layer.borderWidth = 0.5;
            self.leftButton.layer.borderColor = JP_LayerColor.CGColor;
            [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.leftButton];
        }
        if (!self.rightButton) {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightButton.tag = 10010;
            self.rightButton.layer.cornerRadius = JPRealValue(10);
            self.rightButton.layer.masksToBounds = YES;
            self.rightButton.layer.borderWidth = 0.5;
            self.rightButton.layer.borderColor = JP_LayerColor.CGColor;
            [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.rightButton];
        }
        if (!self.titleLab) {
            self.titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
            self.titleLab.font = JP_DefaultsFont;
            self.titleLab.textColor = JP_Content_Color;
            [self.leftButton addSubview:self.titleLab];
        }
        if (!self.tipView1) {
            self.tipView1 = [UIImageView new];
            self.tipView1.image = [UIImage imageNamed:@"jp_login_tip"];
            self.tipView1.userInteractionEnabled = YES;
            [self.leftButton addSubview:self.tipView1];
        }
        if (!self.tipView2) {
            self.tipView2 = [UIImageView new];
            self.tipView2.image = [UIImage imageNamed:@"jp_login_tip"];
            self.tipView2.userInteractionEnabled = YES;
            [self.rightButton addSubview:self.tipView2];
        }
        if (!self.textLab1) {
            self.textLab1 = [UILabel new];
            //            self.textLab1.text = @"选择市";
            self.textLab1.font = JP_DefaultsFont;
            self.textLab1.textColor = JP_NoticeText_Color;
            [self.leftButton addSubview:self.textLab1];
        }
        if (!self.textLab2) {
            self.textLab2 = [UILabel new];
            //            self.textLab2.text = @"选择区/县";
            self.textLab2.font = JP_DefaultsFont;
            self.textLab2.textColor = JP_NoticeText_Color;
            [self.rightButton addSubview:self.textLab2];
        }
        
        weakSelf_declare;
//        CGFloat width = (kScreenWidth - JPRealValue(120)) / 2.0;
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(250), JPRealValue(70)));
        }];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
            make.right.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.height.equalTo(@(JPRealValue(70)));
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftButton.mas_left).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
            make.width.equalTo(@(JPRealValue(10)));
            make.height.equalTo(@(JPRealValue(30)));
        }];
        
        [self.tipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.leftButton.mas_right).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
        }];
        [self.tipView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.rightButton.mas_right).offset(JPRealValue(-20));
            make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
        }];
        [self.textLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
            make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.tipView1.mas_left).offset(JPRealValue(-20));
            make.height.equalTo(@(JPRealValue(30)));
        }];
        [self.textLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
            make.left.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.tipView2.mas_left).offset(JPRealValue(-20));
            make.height.equalTo(@(JPRealValue(30)));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    weakSelf_declare;
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.leftButton.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    self.titleLab.text = title;
}

#pragma mark - Action
- (void)leftButtonClick:(UIButton *)sender {
    if (self.jpTwoSelect_leftBlock) {
        self.jpTwoSelect_leftBlock(sender, self.textLab1);
    }
}
- (void)rightButtonClick:(UIButton *)sender {
    if (self.jpTwoSelect_rightBlock) {
        self.jpTwoSelect_rightBlock(sender, self.textLab2);
    }
}
@end

// !!!: JPInputCell
@implementation JPInputCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.bgView) {
            self.bgView = [UIView new];
            self.bgView.layer.cornerRadius = JPRealValue(10);
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.borderWidth = 0.5;
            self.bgView.layer.borderColor = JP_LayerColor.CGColor;
            [self.contentView addSubview:self.bgView];
        }
        if (!self.titleLab) {
            self.titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
            self.titleLab.font = JP_DefaultsFont;
            self.titleLab.textColor = JP_Content_Color;
            [self.bgView addSubview:self.titleLab];
        }
        if (!self.inputField) {
            self.inputField = [UITextField new];
            self.inputField.font = JP_DefaultsFont;
            self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.inputField.textColor = JP_Content_Color;
            [self.inputField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
            [self.inputField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
            
            //监听开始编辑状态
            [self.inputField addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventEditingDidBegin];// 可在自定义selector处
            //监听编辑完成的状态
            [self.inputField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEnd];// 可在自定义selector处
            [self.bgView addSubview:self.inputField];
        }
        
        weakSelf_declare;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
            make.height.equalTo(@(JPRealValue(70)));
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            make.width.equalTo(@(JPRealValue(10)));
            make.height.equalTo(@(JPRealValue(30)));
        }];
        
        [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
            make.height.equalTo(weakSelf.bgView.mas_height);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    weakSelf_declare;
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    self.titleLab.text = title;
}

- (void)startEditing {
    self.bgView.layer.borderColor = JPBaseColor.CGColor;
}

- (void)endEditing {
    self.bgView.layer.borderColor = JP_LayerColor.CGColor;
}

@end

// !!!: JPOnlyInputCell
@implementation JPOnlyInputCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.bgView) {
            self.bgView = [UIView new];
            self.bgView.layer.cornerRadius = JPRealValue(10);
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.borderWidth = 0.5;
            self.bgView.layer.borderColor = JP_LayerColor.CGColor;
            [self.contentView addSubview:self.bgView];
        }
        if (!self.inputField) {
            self.inputField = [UITextField new];
            self.inputField.font = JP_DefaultsFont;
            self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.inputField.textColor = JP_Content_Color;
            [self.inputField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
            [self.inputField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
            
            //监听开始编辑状态
            [self.inputField addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventEditingDidBegin];// 可在自定义selector处
            //监听编辑完成的状态
            [self.inputField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEnd];// 可在自定义selector处
            [self.bgView addSubview:self.inputField];
        }
        
        weakSelf_declare;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
            make.height.equalTo(@(JPRealValue(70)));
        }];
        
        [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
            make.height.equalTo(weakSelf.bgView.mas_height);
        }];
    }
    return self;
}

- (void)startEditing {
    self.bgView.layer.borderColor = JPBaseColor.CGColor;
}

- (void)endEditing {
    self.bgView.layer.borderColor = JP_LayerColor.CGColor;
}

@end

// !!!: JPCateSelectCell
@implementation JPCateSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.bgView) {
            self.bgView = [UIView new];
            [self.contentView addSubview:self.bgView];
        }
        if (!self.titleLab) {
            self.titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
            self.titleLab.font = JP_DefaultsFont;
            self.titleLab.textColor = JP_Content_Color;
            [self.bgView addSubview:self.titleLab];
        }
        if (!self.leftButton) {
            self.leftButton = [JPSelectButton buttonWithType:UIButtonTypeCustom];
            self.leftButton.selected = YES;
            self.leftButton.tag = 666;
            [self.leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.bgView addSubview:self.leftButton];
        }
        if (!self.rightButton) {
            self.rightButton = [JPSelectButton buttonWithType:UIButtonTypeCustom];
            self.rightButton.selected = NO;
            self.rightButton.tag = 888;
            [self.rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.bgView addSubview:self.rightButton];
        }
        
        weakSelf_declare;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
            make.height.equalTo(@(JPRealValue(70)));
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.bgView.mas_centerY);
            //        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
            make.width.equalTo(@(JPRealValue(10)));
            make.height.equalTo(@(JPRealValue(30)));
        }];
        
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(140), JPRealValue(50)));
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftButton.mas_right).offset(JPRealValue(20));
            make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(140), JPRealValue(50)));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    weakSelf_declare;
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    self.titleLab.text = title;
}

- (void)buttonClick:(JPSelectButton *)sender {
    if (self.jp_cateSelectBlock) {
        self.jp_cateSelectBlock(sender.tag);
    }
}

- (void)setLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
}

@end

//  !!!: - JPCredentialsCell
@interface JPCredentialsCell ()
/** 过渡色*/
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 渐变色视图提示标签*/
@property (nonatomic, strong) UILabel *promotLab;
/** 删除按钮*/
@property (nonatomic, strong) UIButton *deleteButton;
/** 右上角角标*/
@property (nonatomic, strong) UIImageView *triangleView;
@end
@implementation JPCredentialsCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.addView];
        [self.contentView addSubview:self.imgNameLab];
        [self.contentView addSubview:self.promotLab];
        [self.contentView addSubview:self.triangleView];
        [self.contentView addSubview:self.deleteButton];
        
        [self.contentView bringSubviewToFront:self.triangleView];
        [self.contentView bringSubviewToFront:self.deleteButton];
        [self.contentView bringSubviewToFront:self.promotLab];
        [self.promotLab.layer addSublayer:self.gradientLayer];
    }
    return self;
}

#pragma mark - Setter
- (void)setImgUrl:(NSString *)imgUrl {
    
    if (imgUrl.length <= 0) {
        self.bgView.image = [UIImage imageNamed:@"jp_login_registerCertificationBg"];
        self.hasImage = NO;
        self.valueHasChange = YES;
    } else {
        [self.bgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        self.hasImage = YES;
        self.valueHasChange = NO;
    }
}

- (void)setImage:(UIImage *)image {
    
    if (!image) {
        self.bgView.image = [UIImage imageNamed:@"jp_login_registerCertificationBg"];
        self.hasImage = NO;
        self.valueHasChange = NO;
    } else {
        self.bgView.image = image;
        self.hasImage = YES;
        self.valueHasChange = YES;
    }
}

- (void)setPlaceholderName:(NSString *)placeholderName {
    self.imgNameLab.text = placeholderName;
    self.promotLab.text = placeholderName;
}

- (void)setCanEditing:(BOOL)canEditing {
    
    self.deleteButton.hidden = !canEditing;
    
    _canEditing = canEditing;
}

- (void)setHasImage:(BOOL)hasImage {
    
    self.addView.hidden = hasImage;
    self.imgNameLab.hidden = hasImage;
    self.promotLab.hidden = !hasImage;
    self.deleteButton.hidden = !self.canEditing ? YES : hasImage ? NO : YES;
    
    _hasImage = hasImage;
}

- (void)setIsNeed:(BOOL)isNeed {
    self.triangleView.hidden = !isNeed;
    _isNeed = isNeed;
}

#pragma mark - Action
- (void)handleDeleteImage:(UIButton *)sender {
    if (self.credentialsDeleteImageBlock) {
        [self setImgUrl:@""];
        self.valueHasChange = YES;
        self.credentialsDeleteImageBlock(self);
    }
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    float margin = JPRealValue(180) / 3.0;
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(40));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-40));
        make.left.and.bottom.equalTo(weakSelf.contentView);
    }];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_top).offset(margin);
    }];
    [self.imgNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_top).offset(margin * 2);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, JPRealValue(24)));
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-40));
        make.centerY.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(40));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(80), JPRealValue(80)));
    }];
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right);
        make.top.equalTo(weakSelf.bgView.mas_top);
    }];
    [self.promotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-40));
        make.height.equalTo(@20);
    }];
    self.gradientLayer.frame = CGRectMake(0, 0, self.promotLab.frame.size.width, self.promotLab.frame.size.height);
}

#pragma mark - Lazy
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"jp_login_registerCertificationBg"];
        _bgView.image = image;
    }
    return _bgView;
}
- (UIImageView *)addView {
    if (!_addView) {
        _addView = [UIImageView new];
        _addView.image = [UIImage imageNamed:@"jp_login_copy"];
    }
    return _addView;
}
- (UILabel *)imgNameLab {
    if (!_imgNameLab) {
        _imgNameLab = [UILabel new];
        _imgNameLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _imgNameLab.textAlignment = NSTextAlignmentCenter;
        _imgNameLab.textColor = JP_Content_Color;
    }
    return _imgNameLab;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor colorWithHexString:@"777777"].CGColor];
        _gradientLayer.locations = @[@0, @1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1.0);
    }
    return _gradientLayer;
}
- (UILabel *)promotLab {
    if (!_promotLab) {
        _promotLab = [UILabel new];
        _promotLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _promotLab.textAlignment = NSTextAlignmentCenter;
        _promotLab.textColor = [UIColor whiteColor];
    }
    return _promotLab;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"jp_person_deleteImage"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(handleDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UIImageView *)triangleView {
    if (!_triangleView) {
        _triangleView = [UIImageView new];
        _triangleView.image = [UIImage imageNamed:@"jp_login_request"];
    }
    return _triangleView;
}

@end

