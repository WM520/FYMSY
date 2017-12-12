//
//  JPDealFlowModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealFlowModel.h"

@implementation JPDealFlowModel
- (void)setTransAt:(NSString *)transAt {
    double trans = [transAt doubleValue];
    _transAt = [NSString stringWithFormat:@"%.2lf", trans];
}
- (void)setMchntCd:(NSString *)mchntCd {
    if (mchntCd.length <= 0 || [mchntCd isEqual:[NSNull null]]) {
        mchntCd = @" ";
    }
    _mchntCd = mchntCd;
}
- (void)setInstName:(NSString *)instName {
    if (instName.length <= 0 || [instName isEqual:[NSNull null]]) {
        instName = @" ";
    }
    _instName = instName;
}
- (void)setTermId:(NSString *)termId {
    if (termId.length <= 0 || [termId isEqual:[NSNull null]]) {
        termId = @" ";
    }
    _termId = termId;
}
- (void)setOpeName:(NSString *)opeName {
    if (opeName.length <= 0 || [opeName isEqual:[NSNull null]]) {
        opeName = @" ";
    }
    _opeName = opeName;
}
- (void)setTransName:(NSString *)transName {
    if (transName.length <= 0 || [transName isEqual:[NSNull null]]) {
        transName = @" ";
    }
    _transName = transName;
}
- (void)setPayName:(NSString *)payName {
    if (payName.length <= 0 || [payName isEqual:[NSNull null]]) {
        payName = @" ";
    }
    _payName = payName;
}
- (void)setPriAcctNo:(NSString *)priAcctNo {
    if (priAcctNo.length <= 0 || [priAcctNo isEqual:[NSNull null]]) {
        priAcctNo = @" ";
    }
    _priAcctNo = priAcctNo;
}
- (void)setMerFee:(NSString *)merFee {
    double fee = [merFee doubleValue];
    _merFee = [NSString stringWithFormat:@"%.2f", fee];
}
- (void)setRealmoney:(NSString *)realmoney {
    double real = [realmoney doubleValue];
    _realmoney = [NSString stringWithFormat:@"%.2f", real];
}
- (void)setRate:(NSString *)rate {
    double ra = [rate doubleValue];
    _rate = [NSString stringWithFormat:@"%.2f", ra];
}
- (void)setSysTraNo:(NSString *)sysTraNo {
    if (sysTraNo.length <= 0 || [sysTraNo isEqual:[NSNull null]]) {
        sysTraNo = @" ";
    }
    _sysTraNo = sysTraNo;
}
- (void)setRespCd:(NSString *)respCd {
    if (respCd.length <= 0 || [respCd isEqual:[NSNull null]]) {
        respCd = @" ";
    }
    _respCd = respCd;
}
- (void)setUndiscountableAmount:(NSString *)undiscountableAmount {
    if (undiscountableAmount.length <= 0 || [undiscountableAmount isEqual:[NSNull null]]) {
        undiscountableAmount = @"";
    }
    _undiscountableAmount = undiscountableAmount;
}
- (void)setDiscountableAmount:(NSString *)discountableAmount {
    if (discountableAmount.length <= 0 || [discountableAmount isEqual:[NSNull null]]) {
        discountableAmount = @"";
    }
    _discountableAmount = discountableAmount;
}
@end
