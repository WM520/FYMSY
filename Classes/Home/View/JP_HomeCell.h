//
//  JP_HomeCell.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/7.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JP_HomeCellType) {
    JP_HomeCellTypeYesterday    = 0,
    JP_HomeCellTypeThisWeek,
    JP_HomeCellTypeDealSearch,
};
@interface JP_HomeCell : UITableViewCell
@property (nonatomic, assign) JP_HomeCellType cellType;
@property (nonatomic, strong) UILabel *sumLab;
@end
