//
//  JPCredentialsHelper.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCredentialsHelper.h"

@implementation JPCredentialsHelper

/**
 证件照上传参数配置
 
 @param imgName 图片名
 @param isNeed 是否必选
 @param imgCode 图片标识
 @param imgIsNeed 是否必选
 @param imgDesc 图片描述
 @param url 图片路径
 @return 证件照上传参数配置
 */
+ (NSDictionary *)addImgName:(NSString *)imgName
                      isNeed:(BOOL)isNeed
                     imgCode:(NSString *)imgCode
                   imgIsNeed:(BOOL)imgIsNeed
                     imgDesc:(NSString *)imgDesc
                         url:(NSString *)url {
    
    NSMutableDictionary *mutableDic = @{}.mutableCopy;
    
    [mutableDic setObject:imgName forKey:@"imgName"];
    [mutableDic setObject:@(isNeed) forKey:@"isNeed"];
    [mutableDic setObject:imgCode forKey:@"imgCode"];
    
    NSMutableArray *arr = @[].mutableCopy;
    NSMutableDictionary *dic = @{}.mutableCopy;
    
    [dic setObject:@(imgIsNeed) forKey:@"isNeed"];
    [dic setObject:imgDesc forKey:@"imgDesc"];
    [dic setObject:url forKey:@"url"];
    
    [arr addObject:dic];
    
    [mutableDic setObject:arr forKey:@"imgList"];
    
    return mutableDic;
}

@end
