//
//  JPDealFlowViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"

@interface JPDealFlowViewController : JPViewController

/**
 "Integer msgFlag
 （msgFalg=1代表消息通知的交易列表，否则为交易查询列表），
 Integer mercFlag(0:不选择下拉框，1：选择下拉框条件，不可为空)，
 String merchantNo,
 Integer merchantId,
 （mercNo和mercId不管是选择条件还是不选择都传参）,
 String userName,
 String startTime（20170326162749）,
 String endTime（20170326162749），
 String currentPageTime，(上一页的最后一行数据的交易日期：20170326162749)，
 String type（交易状态),
 String payChannel（交易方式），
 Integer startRow（每页的开始行）"
 */
@property (nonatomic, assign) NSInteger msgFlag;
@property (nonatomic, assign) NSInteger mercFlag;
@property (nonatomic, strong) NSString *merchantNo;
@property (nonatomic, assign) NSInteger merchantId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *payChannel;
@property (nonatomic, assign) BOOL isRed;
@property (nonatomic, strong) NSString *businessShortName;
@end
