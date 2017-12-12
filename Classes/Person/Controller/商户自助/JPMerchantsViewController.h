//
//  JPMerchantsViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/28.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"

@interface JPMerchantsViewController : JPViewController
/** 申请进度*/
@property (nonatomic, assign) JPApplyProgress applyProgress;
@property (nonatomic, strong) JPStateQueryModel *merchantsModel;
@end
