//
//  JPNetTools1_1.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNetworking.h"

//  商户自助
@interface JPNetTools1_0_2 : JPNetworking
/** 二维码扫描结果*/
+ (void)getQrCodeScanningResultsWithQrcodeid:(NSString *)qrcodeid callback:(JPNetCallback)callback;

/** 商户自助进件状态查询*/
+ (void)getBusinessSelfHelpStateWithUserName:(NSString *)userName callback:(JPNetCallback)callback;

/** 商户自助商户信息获取*/
+ (void)getBusinessSelfHelpBusinessInfoWithUserName:(NSString *)userName callback:(JPNetCallback)callback;

/** 图片上传*/
+ (void)uploadImage:(UIImage *)image isUpdate:(BOOL)isUpdate checkContent:(NSString *)checkContent tagStr:(NSString *)tagStr progress:(ZJNetProgress)progress callback:(JPNetCallback)callback;

/** 证件资料列表信息获取*/
+ (void)getInfoListWithType:(NSString *)type callback:(JPNetCallback)callback;

/** 开户省市*/
+ (void)getOpenAccountCityWithParent:(NSString *)parent level:(NSString *)level callback:(JPNetCallback)callback;

/** 注册省市区县*/
+ (void)getRegisterAddressWithParent:(NSString *)parent level:(NSString *)level qrcodeId:(NSString *)qrcodeId callback:(JPNetCallback)callback;

/** 行业类型获取*/
+ (void)getIndustryTypeWithName:(NSString *)name callback:(JPNetCallback)callback;

/** 商户名称和用户名存在校验*/
+ (void)vaildBusinessInfoWithCheckCode:(NSString *)checkCode qrCodeId:(NSString *)qrCodeId content:(NSString *)content callback:(JPNetCallback)callback;

/** 银行名称获取*/
+ (void)getBankNameWithProvince:(NSString *)province city:(NSString *)city bankName:(NSString *)bankName callback:(JPNetCallback)callback;

/**
 商户进件资料提交
 
 @param merchantCategory        商户类别    1-企业类；2-个体
 @param certificateImgType      证件照类别   根据商户类别的值来动态赋值，0-企业类；1-个体有照，2无
 @param merchantName            商户名称
 @param merchantShortName       商户简称
 @param registerProvinceCode    注册省份    传code
 @param registerCityCode        注册地市    传code
 @param registerDistrictCode    注册区县    传code
 @param registerAddress         注册详细地址
 @param industryType            行业类型-大类     直接传名称
 @param mcc                     行业类型-小类     小类编码
 @param industryNo              行业类型描述-小类
 @param legalPersonName         法人姓名
 @param username                用户名
 @param accountIdcard           身份证号
 @param accountType             账户类型    1-对公，2-对私
 @param accountProvinceCode     开户地省份   传code
 @param accountCityCode         开户地市    传code
 @param accountBankNameId       银行名称    传名称
 @param alliedBankCode          银联号     支行的code
 @param accountBankBranchName   支行名称    传名称
 @param account                 开户银行帐号
 @param accountName             开户账号名称
 @param contactMobilePhone      预留手机号
 @param qrcodeId                二维码     商户入住时必传
 @param merchantId              主键      商户修改时必传
 @param remark                  备注
 @param imgs                    图片集合    证件照集合，同证件资料获取
 @param callback                回调
 */
+ (void)commitWithMerchantCategory:(NSString *)merchantCategory
                certificateImgType:(NSString *)certificateImgType
                      merchantName:(NSString *)merchantName
                 merchantShortName:(NSString *)merchantShortName
              registerProvinceCode:(NSString *)registerProvinceCode
                  registerCityCode:(NSString *)registerCityCode
              registerDistrictCode:(NSString *)registerDistrictCode
                   registerAddress:(NSString *)registerAddress
                      industryType:(NSString *)industryType
                               mcc:(NSString *)mcc
                        industryNo:(NSString *)industryNo
                   legalPersonName:(NSString *)legalPersonName
                          username:(NSString *)username
                     accountIdcard:(NSString *)accountIdcard
                       accountType:(NSString *)accountType
               accountProvinceCode:(NSString *)accountProvinceCode
                   accountCityCode:(NSString *)accountCityCode
                 accountBankNameId:(NSString *)accountBankNameId
                    alliedBankCode:(NSString *)alliedBankCode
             accountBankBranchName:(NSString *)accountBankBranchName
                           account:(NSString *)account
                       accountName:(NSString *)accountName
                contactMobilePhone:(NSString *)contactMobilePhone
                          qrcodeId:(NSString *)qrcodeId
                        merchantId:(NSString *)merchantId
                            remark:(NSString *)remark
                              imgs:(id)imgs
                          callback:(JPNetCallback)callback;

@end
