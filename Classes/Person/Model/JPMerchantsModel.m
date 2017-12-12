//
//  JPSelfHelpModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPMerchantsModel.h"

@implementation JPSelfHelpModel

@end

@implementation JPSelfHelpDataModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"imgs" : [JPCertificateData class]};
}
@end

@implementation Merchantstatus

@end


// !!!: 证件资料列表信息获取
@implementation JPDocumentsModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [JPCertificateData class]};
}
@end

@implementation JPCertificateData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"imgList" : [JPImageModel class]};
}
@end

@implementation JPImageModel

@end

