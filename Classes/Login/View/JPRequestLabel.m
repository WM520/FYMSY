//
//  JPRequestLabel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/22.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPRequestLabel.h"

#define starWidth  JPRealValue(24)

@implementation JPRequestLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *starLabel = [UILabel new];
        starLabel.text = @"*";
        starLabel.font = [UIFont systemFontOfSize:starWidth];
        starLabel.textColor = [UIColor redColor];
        [self addSubview:starLabel];
        
        weakSelf_declare;
        [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right);
            make.top.equalTo(weakSelf.mas_top);
            make.size.mas_equalTo(CGSizeMake(starWidth, starWidth));
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
