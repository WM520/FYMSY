//
//  JPNetTools1_1.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNetTools1_0_2.h"

@implementation JPNetTools1_0_2
/** 二维码扫描结果*/
+ (void)getQrCodeScanningResultsWithQrcodeid:(NSString *)qrcodeid callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:qrcodeid forKey:@"qrcodeid"];
    
    [params setObject:@"JBB07" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

/** 商户自助进件状态查询*/
+ (void)getBusinessSelfHelpStateWithUserName:(NSString *)userName callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:userName forKey:@"userName"];
    
    [params setObject:@"JBB08" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

/** 商户自助商户信息获取*/
+ (void)getBusinessSelfHelpBusinessInfoWithUserName:(NSString *)userName callback:(JPNetCallback)callback {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:userName forKey:@"userName"];
    
    [params setObject:@"JBB09" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [manager POST:JPNewServerUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (callback) {
                callback(responseObject[@"resultCode"], responseObject[@"resultMsg"], responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error - %@", error);
        if (callback) {
            callback (@"-1", @"网络异常，请稍后再试", @{});
        }
    }];
}

+ (void)uploadImage:(UIImage *)image isUpdate:(BOOL)isUpdate checkContent:(NSString *)checkContent tagStr:(NSString *)tagStr progress:(ZJNetProgress)progress callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    //  data里面需要存放string类型的字符串
    NSString *update = isUpdate ? @"true" : @"false";
    NSString *dataString = [NSString stringWithFormat:@"{\"checkContent\":\"%@\",\"isUpdate\":%@}",checkContent , update];
    
    [params setObject:@"JBB11" forKey:@"serviceCode"];
    [params setObject:dataString forKey:@"data"];
        
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", @"text/json", @"text/javascript,multipart/form-data", @"image/jpeg", @"application/octet-stream", nil];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //上传图片/文字，只能同POST
    [manager POST:JPImgServerUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image,1);
        NSString *str = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMddHHmmssFFF"];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        // 注意：这个name一定要和后台的参数字段一样 否则不成功
        [formData appendPartWithFileData:imageData
                                    name:@"imgFile"
                                fileName:fileName
                                mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(1.f * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功
        if (callback) {
            callback(responseObject[@"resultCode"], tagStr, responseObject[@"data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        if (callback) {
            callback (@"-1", @"网络异常，请稍后再试", @{});
        }
    }];
}

/** 证件资料列表信息获取*/
+ (void)getInfoListWithType:(NSString *)type callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:type forKey:@"type"];
    
    [params setObject:@"JBB05" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [manager POST:JPNewServerUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (callback) {
                callback(responseObject[@"resultCode"], responseObject[@"resultMsg"], responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error - %@", error);
        if (callback) {
            callback (@"-1", @"网络异常，请稍后再试", @{});
        }
    }];
}

/** 开户省市*/
+ (void)getOpenAccountCityWithParent:(NSString *)parent level:(NSString *)level callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:parent forKey:@"parent"];
    [data setObject:level forKey:@"level"];
    
    [params setObject:@"JBB03" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

/** 注册省市区县*/
+ (void)getRegisterAddressWithParent:(NSString *)parent level:(NSString *)level qrcodeId:(NSString *)qrcodeId callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:parent forKey:@"parent"];
    [data setObject:level forKey:@"level"];
    [data setObject:qrcodeId forKey:@"qrcodeId"];
    
    [params setObject:@"JBB01" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    NSLog(@"params - %@", params);
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

/** 行业类型获取*/
+ (void)getIndustryTypeWithName:(NSString *)name callback:(JPNetCallback)callback {

    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:name forKey:@"name"];
    
    [params setObject:@"JBB02" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

/** 商户名称和用户名存在校验*/
+ (void)vaildBusinessInfoWithCheckCode:(NSString *)checkCode
                              qrCodeId:(NSString *)qrCodeId
                               content:(NSString *)content
                              callback:(JPNetCallback)callback {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:checkCode forKey:@"checkCode"];
    [data setObject:content forKey:@"content"];
    if (qrCodeId) {
        [data setObject:qrCodeId forKey:@"qrCodeId"];
    }
    
    [params setObject:@"JBB06" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

/** 银行名称获取*/
+ (void)getBankNameWithProvince:(NSString *)province city:(NSString *)city bankName:(NSString *)bankName callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:province forKey:@"province"];
    [data setObject:city forKey:@"city"];
    [data setObject:bankName forKey:@"bankName"];
    
    [params setObject:@"JBB04" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

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
                          callback:(JPNetCallback)callback {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *data = @{}.mutableCopy;
    
    [data setObject:merchantCategory forKey:@"merchantCategory"];
    [data setObject:certificateImgType forKey:@"certificateImgType"];
    [data setObject:merchantName forKey:@"merchantName"];
    [data setObject:merchantShortName forKey:@"merchantShortName"];
    [data setObject:registerProvinceCode forKey:@"registerProvinceCode"];
    [data setObject:registerCityCode forKey:@"registerCityCode"];
    [data setObject:registerDistrictCode forKey:@"registerDistrictCode"];
    [data setObject:registerAddress forKey:@"registerAddress"];
    [data setObject:industryType forKey:@"industryType"];
    [data setObject:mcc forKey:@"mcc"];
    [data setObject:industryNo forKey:@"industryNo"];
    [data setObject:legalPersonName forKey:@"legalPersonName"];
    [data setObject:username forKey:@"username"];
    [data setObject:accountIdcard forKey:@"accountIdcard"];
    [data setObject:accountType forKey:@"accountType"];
    [data setObject:accountProvinceCode forKey:@"accountProvinceCode"];
    [data setObject:accountCityCode forKey:@"accountCityCode"];
    [data setObject:accountBankNameId forKey:@"accountBankNameId"];
    [data setObject:alliedBankCode forKey:@"alliedBankCode"];
    [data setObject:accountBankBranchName forKey:@"accountBankBranchName"];
    [data setObject:account forKey:@"account"];
    [data setObject:accountName forKey:@"accountName"];
    [data setObject:contactMobilePhone forKey:@"contactMobilePhone"];
    [data setObject:qrcodeId forKey:@"qrcodeId"];
    [data setObject:merchantId forKey:@"merchantId"];
    if (remark) {
        [data setObject:remark forKey:@"remark"];
    }
    [data setObject:imgs forKey:@"imgs"];
    
    [params setObject:@"JBB10" forKey:@"serviceCode"];
    [params setObject:data forKey:@"data"];
    
    NSLog(@"params = %@", params);
    
    [JPNetworking postUrl_V1_0_2:JPNewServerUrl params:params callback:^(NSString *resultCode, NSString *msg, id resp) {
        if (callback) {
            callback (resultCode, msg, resp);
        }
    }];
}

@end
