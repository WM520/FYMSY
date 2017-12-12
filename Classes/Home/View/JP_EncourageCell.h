//
//  JP_EncourageCell.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/7.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JP_EncourageCell : UITableViewCell
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *numLab;
@end

@interface JP_EncourageHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *merchantLab;
@property (nonatomic, strong) UILabel *encourageLab;
@end
