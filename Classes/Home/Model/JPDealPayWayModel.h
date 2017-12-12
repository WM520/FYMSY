//
//  JPDealPayWayModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDealPayWayModel : NSObject
/**
 "id": null,
 "code": null,
 "describe": null,
 "payChannelName": null,
 "payChannel": "wxqrcode",
 "feeFlag": null,
 "cardAttr": null,
 "name": "微信一码付",
 "refundFlag": null
 */
//@property (nonatomic, copy) NSString *payID;
//@property (nonatomic, copy) NSString *code;
//@property (nonatomic, copy) NSString *describe;
//@property (nonatomic, copy) NSString *payChannelName;
@property (nonatomic, copy) NSString *payChannel;
//@property (nonatomic, copy) NSString *feeFlag;
//@property (nonatomic, copy) NSString *cardAttr;
@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *refundFlag;
@end
