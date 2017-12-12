//
//  JPSelfHelpModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPSelfHelpDataModel, Merchantstatus, JPCertificateData, JPImageModel;
@interface JPSelfHelpModel : NSObject
/** 返回消息*/
@property (nonatomic, copy) NSString *resultMsg;
/** 返回数据*/
@property (nonatomic, strong) JPSelfHelpDataModel *data;
/** 返回码*/
@property (nonatomic, copy) NSString *resultCode;
@end

@interface JPSelfHelpDataModel : NSObject
/** 商户id*/
@property (nonatomic, assign) NSInteger merchantId;
/** 商户名称*/
@property (nonatomic, copy) NSString *merchantName;
/** 商户简称*/
@property (nonatomic, copy) NSString *merchantShortName;
/** 商户类别编码*/
@property (nonatomic, assign) NSInteger merchantCategory;
/** 商户类别*/
@property (nonatomic, copy) NSString *merchantCategoryName;
/** 商户类别(证件类别) 根据商户类别的值来动态赋值，0-企业类；1-个体有照，2无*/
@property (nonatomic, assign) NSInteger certificateImgType;
/** 商户状态*/
@property (nonatomic, strong) Merchantstatus *merchantStatus;
/** 注册省份编码*/
@property (nonatomic, copy) NSString *registerProvinceCode;
/** 注册省份名称*/
@property (nonatomic, copy) NSString *registerProvinceName;
/** 注册地市编码*/
@property (nonatomic, copy) NSString *registerCityCode;
/** 注册地市名称*/
@property (nonatomic, copy) NSString *registerCityName;
/** 注册区县编码*/
@property (nonatomic, copy) NSString *registerDistrictCode;
/** 注册区县名称*/
@property (nonatomic, copy) NSString *registerDistrictName;
/** 详细地址*/
@property (nonatomic, copy) NSString *registerAddress;
/** 商户号*/
@property (nonatomic, copy) NSString *merchantNo;
/** 行业类型编码-大类*/
@property (nonatomic, copy) NSString *industryTypeCode;
/** 行业类型-大类*/
@property (nonatomic, copy) NSString *industryType;
/** 行业类型编码-小类*/
@property (nonatomic, copy) NSString *mcc;
/** 行业类型-小类*/
@property (nonatomic, copy) NSString *industryNo;
/** 法人姓名*/
@property (nonatomic, copy) NSString *legalPersonName;
/** 用户名*/
@property (nonatomic, copy) NSString *userName;
/** 账户类型 1-对公，2-对私*/
@property (nonatomic, assign) NSInteger accountType;
/** 账户类型名称*/
@property (nonatomic, assign) NSInteger accountTypeName;
/** 身份证号*/
@property (nonatomic, copy) NSString *accountIdcard;
/** 开户地省编码*/
@property (nonatomic, copy) NSString *accountProvinceCode;
/** 开户地名称*/
@property (nonatomic, copy) NSString *accountProvinceName;
/** 开户地市编码*/
@property (nonatomic, copy) NSString *accountCityCode;
/** 开户地市名称*/
@property (nonatomic, copy) NSString *accountCityName;
/** 银行编码*/
@property (nonatomic, copy) NSString *accountBankNameId;
/** 银行名称*/
@property (nonatomic, copy) NSString *accountBankName;
/** 支行编码*/
@property (nonatomic, copy) NSString *alliedBankCode;
/** 支行编码*/
@property (nonatomic, copy) NSString *accountBankBranchCode;
/** 支行名称*/
@property (nonatomic, copy) NSString *accountBankBranchName;
/** 开户银行账号*/
@property (nonatomic, copy) NSString *account;
/** 开户账号名称*/
@property (nonatomic, copy) NSString *accountName;
/** 预留手机号*/
@property (nonatomic, copy) NSString *contactMobilePhone;
/** 证件资料*/
@property (nonatomic, strong) NSArray<JPCertificateData *> *imgs;
/** <#desc#>*/
@property (nonatomic, copy) NSString *contact;
@end

@interface Merchantstatus : NSObject
/** 审核状态*/
@property (nonatomic, copy) NSString *reviewStatus;
/** 状态码*/
@property (nonatomic, copy) NSString *statusCode;
@end

// !!!: 证件资料列表信息获取
@class JPCertificateData, JPImageModel;
@interface JPDocumentsModel : NSObject
/** 返回码*/
@property (nonatomic, copy) NSString *resultCode;
/** 返回信息*/
@property (nonatomic, copy) NSString *resultMsg;
/** 数据列表*/
@property (nonatomic, strong) NSArray<JPCertificateData *> *data;
@end

@interface JPCertificateData : NSObject
/** 是否必传*/
@property (nonatomic, assign) NSInteger isNeed;
/** 图片名称*/
@property (nonatomic, copy) NSString *imgName;
/** 图片列表*/
@property (nonatomic, strong) NSArray<JPImageModel *> *imgList;
/** 图片码*/
@property (nonatomic, copy) NSString *imgCode;
@end

@interface JPImageModel : NSObject
/** 图片描述*/
@property (nonatomic, copy) NSString *imgDesc;
/** 是否必传*/
@property (nonatomic, assign) NSInteger isNeed;
/** 图片路径*/
@property (nonatomic, copy) NSString *url;
@end
