//
//  JPRegisterModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/6.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

// !!!: 行业名称
@interface JPIndustryModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mcc;
@end

// !!!: 开户省市
@interface JPCityModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@end

// !!!: 银行名称
@interface JPBankModel : NSObject
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankCode;
@end




// !!!: 二维码扫描结果
@interface JPQRCodeModel : NSObject
@property (nonatomic, assign) BOOL isUsed;
@property (nonatomic, copy) NSString *reviewStatus;
/** 00 审核通过     01 审核中      02 审核不通过*/
@property (nonatomic, copy) NSString *statusCode;
@end

// !!!: 商户自助进件状态查询
@interface JPStateQueryModel : NSObject
/** 商户名称*/
@property (nonatomic, copy) NSString *merchantName;
/** 审核不通过原因*/
@property (nonatomic, copy) NSString *unpassCause;
/** 法人代表名称*/
@property (nonatomic, copy) NSString *legalPerson;
/** 状态码*/
@property (nonatomic, copy) NSString *statusCode;
/** 审核状态*/
@property (nonatomic, copy) NSString *reviewStatus;
@end

// !!!: 进件信息提交成功
@interface JPCommitSucModel : NSObject
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@end

// !!!: 商户自助商户信息获取
@class JPMerchantstatus;
@interface JPUserInfoModel : NSObject
/** 行业类型-大类*/
@property (nonatomic, copy) NSString *industryType;
/** 行业类型-小类*/
@property (nonatomic, copy) NSString *industryNo;
/** 账户类型 1-对公，2-对私*/
@property (nonatomic, assign) NSInteger accountType;
/** 开户账号名称*/
@property (nonatomic, copy) NSString *accountName;
/** 银行编码*/
@property (nonatomic, copy) NSString *accountBankNameId;
/** 开户地省名称*/
@property (nonatomic, copy) NSString *accountProvinceName;
/** 开户地省编码*/
@property (nonatomic, copy) NSString *accountProvinceCode;
/** 开户地市名称*/
@property (nonatomic, copy) NSString *accountCityName;
/** 开户地市编码*/
@property (nonatomic, copy) NSString *accountCityCode;
/** 支行名称*/
@property (nonatomic, copy) NSString *accountBankBranchName;
/** 开户银行账号*/
@property (nonatomic, copy) NSString *account;
/** 预留手机号*/
@property (nonatomic, copy) NSString *contactMobilePhone;
/** 身份证号*/
@property (nonatomic, copy) NSString *accountIdcard;
/** 商户id*/
@property (nonatomic, assign) NSInteger merchantId;
/** 商户号*/
@property (nonatomic, copy) NSString *merchantNo;
/** 商户类别(证件类别)*/
@property (nonatomic, copy) NSString *certificateImgType;
/** 商户名称*/
@property (nonatomic, copy) NSString *merchantName;
/** 商户简称*/
@property (nonatomic, copy) NSString *merchantShortName;
/** 注册省份名称*/
@property (nonatomic, copy) NSString *registerProvinceName;
/** 注册省份编码*/
@property (nonatomic, copy) NSString *registerProvinceCode;
/** 注册地市名称*/
@property (nonatomic, copy) NSString *registerCityName;
/** 注册地市编码*/
@property (nonatomic, copy) NSString *registerCityCode;
/** 注册区县名称*/
@property (nonatomic, copy) NSString *registerDistrictName;
/** 注册区县编码*/
@property (nonatomic, copy) NSString *registerDistrictCode;
/** 详细地址*/
@property (nonatomic, copy) NSString *registerAddress;
/** 法人姓名*/
@property (nonatomic, copy) NSString *legalPersonName;
/** 用户名*/
@property (nonatomic, copy) NSString *userName;
/** <#desc#>*/
@property (nonatomic, copy) NSString *accountTypeName;
/** <#desc#>*/
@property (nonatomic, copy) NSString *contact;
/** 证件资料*/
@property (nonatomic, strong) NSArray *imgs;
/** 商户状态*/
@property (nonatomic, strong) JPMerchantstatus *merchantStatus;
@end

@interface JPMerchantstatus : NSObject
/** 审核状态*/
@property (nonatomic, copy) NSString *reviewStatus;
/** 返回码*/
@property (nonatomic, copy) NSString *statusCode;
@end

