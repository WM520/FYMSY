//
//  JPMerchantsSHViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"

//  商户自助
@interface JPMerchantsSHViewController : JPViewController
/** 申请进度*/
@property (nonatomic, assign) JPApplyProgress applyProgress;
@property (nonatomic, copy) NSString *reviewStatus;
@end
