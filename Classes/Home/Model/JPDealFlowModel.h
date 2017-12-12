//
//  JPDealFlowModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDealFlowModel : NSObject

/**
 "feeFlag": 1,
 "rate": 0.6,
 "undiscountableAmount": 0,
 "respCd": "00",
 "recCrtDt": "20170707",
 "merchantShortName": "极速碰撞台球室",
 "transName": "交易成功",
 "termId": "00000000",
 "payChannel": "apqrcode",
 "sysTraNo": "558935",
 "merFee": 0,
 "transactionId": "199530090247201707072278197779",
 "instName": "宁波奕彩融通电子商务有限公司",
 "feeIn": 1,
 "refundFail": 0,
 "transIn": "01",
 "merchantName": "极速台球室",
 "discountableAmount": 0.01,
 "refundSuccess": 1,
 "recCrtTs": "20170707144558",
 "baseSingleMaxMoney": null,
 "totalAmount": null,
 "opeName": "支付宝一码付",
 "transactionTimeStart": null,
 "mchntCd": "998320179320003",
 "realmoney": 0.01,
 "platProcCd": "JA001",
 "feeOut": -1,
 "payName": "支付宝一码付",
 "transAt": 0.01
 */
@property (nonatomic, copy) NSString *feeFlag;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *undiscountableAmount;
@property (nonatomic, copy) NSString *respCd;
@property (nonatomic, copy) NSString *recCrtDt;
@property (nonatomic, copy) NSString *merchantShortName;
@property (nonatomic, copy) NSString *transName;
@property (nonatomic, copy) NSString *termId;
@property (nonatomic, copy) NSString *payChannel;
@property (nonatomic, copy) NSString *sysTraNo;
@property (nonatomic, copy) NSString *merFee;
@property (nonatomic, copy) NSString *transactionId;
@property (nonatomic, copy) NSString *instName;
@property (nonatomic, copy) NSString *feeIn;
@property (nonatomic, copy) NSString *refundFail;
@property (nonatomic, copy) NSString *transIn;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *discountableAmount;
@property (nonatomic, copy) NSString *refundSuccess;
@property (nonatomic, copy) NSString *recCrtTs;
@property (nonatomic, copy) NSString *baseSingleMaxMoney;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *opeName;
@property (nonatomic, copy) NSString *transactionTimeStart;
@property (nonatomic, copy) NSString *mchntCd;
@property (nonatomic, copy) NSString *realmoney;
@property (nonatomic, copy) NSString *platProcCd;
@property (nonatomic, copy) NSString *feeOut;
@property (nonatomic, copy) NSString *payName;
@property (nonatomic, copy) NSString *transAt;
@property (nonatomic, copy) NSString *priAcctNo;
@end
