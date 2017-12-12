//
//  JPLoginViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 若登录的商户为一码付商户：
 1、交易状态包含交易成功、交易失败两种状态。若不选择默认查询所有的交易状态；
 2、支付方式包含支付宝、微信。
 若登录商户为普通云POS（K9）商户：
 1、交易状态包含交易成功、交易失败、交易冲正这几种状态；若不选择默认查询所有的交易状态。
 2、支付方式包含支付宝、微信、借记卡、贷记卡（银联：等后期上线此种支付方式之后要同步更改，此版（v1.0）不不包含）。
 */
@interface JPLoginViewController : UIViewController

@end
