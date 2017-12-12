//
//  JPBillingInfoViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/5/23.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPBaseViewController.h"
//  结算信息
@interface JPBillingInfoViewController : JPBaseViewController
@property (nonatomic, strong) NSString *qrcodeid;
/** 是否是企业类*/
@property (nonatomic, assign) BOOL isEnterprise;
/** 是否有营业执照*/
@property (nonatomic, assign) BOOL hasLicence;
/** 商户名称*/
@property (nonatomic, copy) NSString *merchantName;
/** 商户简称*/
@property (nonatomic, copy) NSString *merchantShortName;
/** 法人姓名*/
@property (nonatomic, copy) NSString *legalName;
/** 用户名*/
@property (nonatomic, copy) NSString *userName;
/** 身份证号码*/
@property (nonatomic, copy) NSString *IDCardNumber;
/** 注册地址省/直辖市/自治区编码*/
@property (nonatomic, copy) NSString *registerProvince;
/** 注册地址市编码*/
@property (nonatomic, copy) NSString *registerCity;
/** 注册地址区县编码*/
@property (nonatomic, copy) NSString *registerCounty;
/** 详细地址*/
@property (nonatomic, copy) NSString *detailAddress;
/** 主行业*/
@property (nonatomic, copy) NSString *mainIndustry;
/** 次行业*/
@property (nonatomic, copy) NSString *secondaryIndustry;
/** 次行业编码*/
@property (nonatomic, copy) NSString *mcc;
/** 备注*/
@property (nonatomic, copy) NSString *remark;
@end
