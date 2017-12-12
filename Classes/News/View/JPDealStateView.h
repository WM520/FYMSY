//
//  JPDealStateView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JPDealState) {
    JPDealStateSuccess = 0, //  交易成功
    JPDealStateFailed,      //  交易失败
};

@interface JPDealStateView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, assign) JPDealState state;
@end
