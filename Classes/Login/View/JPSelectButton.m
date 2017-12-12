//
//  JPSelectButton.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/22.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPSelectButton.h"

@implementation JPSelectButton

- (void)setSelected:(BOOL)selected {

    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.titleLabel.font = JP_DefaultsFont;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    if (!selected) {
        [self setImage:[UIImage imageNamed:@"jp_selectType_normal"] forState:UIControlStateNormal];
        [self setTitleColor:JP_NoticeText_Color forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:@"jp_selectType_selected"] forState:UIControlStateNormal];
        [self setTitleColor:JP_Content_Color forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
