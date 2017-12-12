//
//  JPQuestionExtentionCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPQuestionExtentionCell.h"

@interface JPQuestionExtentionCell ()

@end
@implementation JPQuestionExtentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self addTextView];
    }
    return self;
}

- (void)addTextView {
    self.textView = [YYTextView new];
    self.textView.font = [UIFont systemFontOfSize:JPRealValue(28)];
    self.textView.textColor = JP_Content_Color;
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
    [self.contentView addSubview:self.textView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
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
