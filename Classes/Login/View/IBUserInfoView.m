//
//  IBUserInfoView.m
//  JiePos
//
//  Created by iBlocker on 2017/9/4.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBUserInfoView.h"

// !!!: 类别选择
@interface IBCateSelectView ()
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
/** 按钮*/
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
/** 名称标签*/
@property (nonatomic, strong) JPRequestLabel *titleLab;
@end
@implementation IBCateSelectView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JP_viewBackgroundColor;
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.leftButton];
        [self.bgView addSubview:self.rightButton];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
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

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

- (void)setLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}
- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [JPSelectButton buttonWithType:UIButtonTypeCustom];
        _leftButton.selected = YES;
        _leftButton.tag = 666;
        [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [JPSelectButton buttonWithType:UIButtonTypeCustom];
        _rightButton.selected = NO;
        _rightButton.tag = 888;
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - Action
- (void)buttonClick:(JPSelectButton *)sender {
    if (self.ib_cateSelectBlock) {
        self.ib_cateSelectBlock(sender.tag);
    }
}
@end

// !!!: 有标题的输入框
@interface IBInputView ()
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
/** 名称标签*/
@property (nonatomic, strong) JPRequestLabel *titleLab;
@end
@implementation IBInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JP_viewBackgroundColor;
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.inputField];
    }
    return self;
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}

- (UITextField *)inputField {
    if (!_inputField) {
        if (!_inputField) {
            _inputField = [UITextField new];
            _inputField.font = JP_DefaultsFont;
            _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _inputField.textColor = JP_Content_Color;
            [_inputField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
            [_inputField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
            
            //监听开始编辑状态
            [_inputField addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventEditingDidBegin];// 可在自定义selector处
            //监听编辑完成的状态
            [_inputField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEnd];// 可在自定义selector处
        }
    }
    return _inputField;
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

#pragma mark - Methods
- (void)startEditing {
    self.bgView.layer.borderColor = JPBaseColor.CGColor;
}

- (void)endEditing {
    self.bgView.layer.borderColor = JP_LineColor.CGColor;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo((CGSize){width, JPRealValue(30)});
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(weakSelf.bgView.mas_height);
    }];
}
@end

// !!!: 带标题的单选框
@interface IBOneSelectView ()
/** 背景变色框*/
@property (nonatomic, strong) UIButton  *bgButton;
/** 右侧小角标*/
@property (nonatomic, strong) UIImageView *tipView;
/** 名称标签*/
@property (nonatomic, strong) JPRequestLabel *titleLab;
@end

@implementation IBOneSelectView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JP_viewBackgroundColor;
        
        [self addSubview:self.bgButton];
        [self.bgButton addSubview:self.titleLab];
        [self.bgButton addSubview:self.tipView];
        [self.bgButton addSubview:self.textLab];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgButton.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, JPRealValue(30)));
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.bgButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgButton.mas_centerY);
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

- (void)setIsEditing:(BOOL)isEditing {
    weakSelf_declare;
    if (isEditing) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgButton.layer.borderColor = JPBaseColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgButton.layer.borderColor = JP_LineColor.CGColor;
            weakSelf.bgButton.backgroundColor = [UIColor whiteColor];
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

#pragma mark - Getter
- (UIView *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.layer.cornerRadius = JPRealValue(10);
        _bgButton.layer.masksToBounds = YES;
        _bgButton.layer.borderWidth = 0.5;
        _bgButton.layer.borderColor = JP_LineColor.CGColor;
        _bgButton.backgroundColor = [UIColor whiteColor];
        [_bgButton addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}
- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UIImageView *)tipView {
    if (!_tipView) {
        _tipView = [UIImageView new];
        _tipView.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView.userInteractionEnabled = YES;
    }
    return _tipView;
}
- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.font = JP_DefaultsFont;
        _textLab.textColor = JP_NoticeText_Color;
    }
    return _textLab;
}

- (void)bgButtonClick:(UIButton *)sender {
    if (self.block) {
        self.block(self);
    }
}
@end

// !!!: 不带标题的双选框
@implementation IBOnlyTwoSelectView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JP_viewBackgroundColor;
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self.leftButton addSubview:self.leftView];
        [self.rightButton addSubview:self.rightView];
        [self.leftButton addSubview:self.leftLab];
        [self.rightButton addSubview:self.rightLab];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    CGFloat width = (kScreenWidth - JPRealValue(120)) / 2.0;
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-50));
        make.size.mas_equalTo(CGSizeMake(width, JPRealValue(70)));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(50));
        make.right.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.leftButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.rightButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.left.equalTo(weakSelf.leftButton.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.leftView.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
    [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
        make.left.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.rightView.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}
#pragma mark - Getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.tag = 10086;
        _leftButton.layer.cornerRadius = JPRealValue(10);
        _leftButton.layer.masksToBounds = YES;
        _leftButton.layer.borderWidth = 0.5;
        _leftButton.layer.borderColor = JP_LineColor.CGColor;
        _leftButton.backgroundColor = [UIColor whiteColor];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.tag = 10010;
        _rightButton.layer.cornerRadius = JPRealValue(10);
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.borderWidth = 0.5;
        _rightButton.layer.borderColor = JP_LineColor.CGColor;
        _rightButton.backgroundColor = [UIColor whiteColor];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [UIImageView new];
        _leftView.image = [UIImage imageNamed:@"jp_login_tip"];
        _leftView.userInteractionEnabled = YES;
    }
    return _leftView;
}
- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [UIImageView new];
        _rightView.image = [UIImage imageNamed:@"jp_login_tip"];
        _rightView.userInteractionEnabled = YES;
    }
    return _rightView;
}
- (UILabel *)leftLab {
    if (!_leftLab) {
        _leftLab = [UILabel new];
        _leftLab.font = JP_DefaultsFont;
        _leftLab.textColor = JP_NoticeText_Color;
    }
    return _leftLab;
}
- (UILabel *)rightLab {
    if (!_rightLab) {
        _rightLab = [UILabel new];
        _rightLab.font = JP_DefaultsFont;
        _rightLab.textColor = JP_NoticeText_Color;
    }
    return _rightLab;
}

#pragma mark - Action
- (void)leftButtonClick:(UIButton *)sender {
    if (self.ib_leftBlock) {
        self.ib_leftBlock(self, sender, self.leftLab);
    }
}
- (void)rightButtonClick:(UIButton *)sender {
    if (self.ib_rightBlock) {
        self.ib_rightBlock(self, sender, self.rightLab);
    }
}

@end

@interface IBOnlyInputView ()
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
@end
@implementation IBOnlyInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JP_viewBackgroundColor;
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.inputField];
    }
    return self;
}
#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(weakSelf.bgView.mas_height);
    }];
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.font = JP_DefaultsFont;
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.textColor = JP_Content_Color;
        [_inputField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
        [_inputField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
        
        //监听开始编辑状态
        [_inputField addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventEditingDidBegin];// 可在自定义selector处
        //监听编辑完成的状态
        [_inputField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEnd];// 可在自定义selector处
    }
    return _inputField;
}

#pragma mark - Methods
- (void)startEditing {
    self.bgView.layer.borderColor = JPBaseColor.CGColor;
}

- (void)endEditing {
    self.bgView.layer.borderColor = JP_LineColor.CGColor;
}

@end

// !!!: 不带标题的单选框
@interface IBOnlyOneSelectView ()
/** 背景变色框*/
@property (nonatomic, strong) UIButton  *bgButton;
/** 右侧小角标*/
@property (nonatomic, strong) UIImageView *tipView;
@end
@implementation IBOnlyOneSelectView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JP_viewBackgroundColor;
        
        [self addSubview:self.bgButton];
        [self.bgButton addSubview:self.tipView];
        [self.bgButton addSubview:self.textLab];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.bgButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgButton.mas_centerY);
        make.left.equalTo(weakSelf.bgButton.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}
#pragma mark - Setter
- (void)setIsEditing:(BOOL)isEditing {
    weakSelf_declare;
    if (isEditing) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgButton.layer.borderColor = JPBaseColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgButton.layer.borderColor = JP_LineColor.CGColor;
            weakSelf.bgButton.backgroundColor = [UIColor whiteColor];
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}
#pragma mark - Getter
- (UIView *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.layer.cornerRadius = JPRealValue(10);
        _bgButton.layer.masksToBounds = YES;
        _bgButton.layer.borderWidth = 0.5;
        _bgButton.layer.borderColor = JP_LineColor.CGColor;
        _bgButton.backgroundColor = [UIColor whiteColor];
        [_bgButton addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}
- (UIImageView *)tipView {
    if (!_tipView) {
        _tipView = [UIImageView new];
        _tipView.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView.userInteractionEnabled = YES;
    }
    return _tipView;
}
- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.font = JP_DefaultsFont;
        _textLab.textColor = JP_NoticeText_Color;
    }
    return _textLab;
}

#pragma mark - Action
- (void)bgButtonClick:(UIButton *)sender {
    if (self.block) {
        self.block(self);
    }
}
@end

//  !!!: - 备注输入框
@interface IBRemarkView ()
/** 背景*/
//@property (nonatomic, strong) UIView *bgView;

@end
@implementation IBRemarkView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JP_viewBackgroundColor;
        [self addSubview:self.txtView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(JPRealValue(15));
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-50));
    }];
}

- (void)setRemarkString:(NSString *)remarkString {
    self.txtView.ib_text = remarkString;
    _remarkString = remarkString;
}

- (NSString *)remarkString {
    return self.txtView.ib_text;
}

- (void)setCanEdit:(BOOL)canEdit {
    self.txtView.userInteractionEnabled = canEdit;
    _canEdit = canEdit;
}

- (IBTextView *)txtView {
    if (!_txtView) {
        _txtView = [IBTextView new];
//        _txtView.placeholder = @"";
    }
    return _txtView;
}

@end

@interface IBBaseInfoView ()
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;
@end
@implementation IBBaseInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nextButton];
        [self addSubview:self.previousButton];
    }
    return self;
}

#pragma mark - Getter
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(JPRealValue(64), JPRealValue(40), kScreenWidth - JPRealValue(128), JPRealValue(90));
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.titleLabel.font = JP_DefaultsFont;
//        [_nextButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
//        [_nextButton setBackgroundImage:[UIImage imageNamed:@"jp_button_highlighted"] forState:UIControlStateHighlighted];
        _nextButton.backgroundColor = JPBaseColor;
        _nextButton.layer.cornerRadius = 5;
        _nextButton.layer.masksToBounds = YES;
        [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)previousButton {
    if (!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previousButton.frame = CGRectMake(JPRealValue(64), JPRealValue(150), kScreenWidth - JPRealValue(128), JPRealValue(90));
        [_previousButton setTitle:@"已有账号，去登录" forState:UIControlStateNormal];
        [_previousButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        _previousButton.titleLabel.font = JP_DefaultsFont;
        [_previousButton addTarget:self action:@selector(previousButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousButton;
}

#pragma mark - Action
- (void)nextButtonClick:(UIButton *)sender {
    if (self.nextBlock) {
        self.nextBlock();
    }
}

- (void)previousButtonClick:(UIButton *)sender {
    if (self.previousBlock) {
        self.previousBlock();
    }
}
@end
