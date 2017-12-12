//
//  IBTextView.m
//  IBWallet
//
//  Created by iBlocker on 2017/10/23.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "IBTextView.h"

@interface IBTextView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UILabel *residueLabel;// 输入文本时剩余字数
@end
@implementation IBTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.textView];
        [self addSubview:self.placeHolderLabel];
        [self addSubview:self.residueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.textView.mas_left).offset(8);
        make.top.equalTo(weakSelf.textView.mas_top).offset(8);
    }];
    [self.residueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.textView.mas_right).offset(JPRealValue(-20));
        make.bottom.equalTo(weakSelf.textView.mas_bottom).offset(JPRealValue(-20));
    }];
}

- (void)setIb_text:(NSString *)ib_text {
    self.textView.text = ib_text;
}

- (NSString *)ib_text {
    return self.textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if([textView.text length] == 0) {
        self.placeHolderLabel.text = @"备注";
    } else {
        self.placeHolderLabel.text = @"";//这里给空
    }
    //计算剩余字数   不需要的也可不写
    int existTextNum = (int)[textView.text length];
    if (existTextNum > 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    int remainTextNum = 50 - (int)[textView.text length];
    self.residueLabel.text = [NSString stringWithFormat:@"%d/50", remainTextNum];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    } else {
        return range.location < 50;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.layer.borderColor = JPBaseColor.CGColor;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.textView.layer.borderColor = JP_LineColor.CGColor;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.layer.borderWidth = 0.5;//边宽
        _textView.layer.cornerRadius = JPRealValue(10);//设置圆角
        _textView.layer.borderColor = JP_LineColor.CGColor;
        _textView.font = JP_DefaultsFont;
        _textView.contentInset = UIEdgeInsetsMake(0, 0, JPRealValue(-60), 0);
    }
    return _textView;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.text = @"";
        _placeHolderLabel.font = JP_DefaultsFont;
        _placeHolderLabel.textColor = JP_NoticeText_Color;
    }
    return _placeHolderLabel;
}

- (UILabel *)residueLabel {
    if (!_residueLabel) {
        _residueLabel = [UILabel new];
        _residueLabel.textAlignment = NSTextAlignmentRight;
        _residueLabel.font = [UIFont systemFontOfSize:JPRealValue(18)];
        _residueLabel.text = [NSString stringWithFormat:@"%@",@"50/50"];
        _residueLabel.textColor = JP_Content_Color;
    }
    return _residueLabel;
}
@end
