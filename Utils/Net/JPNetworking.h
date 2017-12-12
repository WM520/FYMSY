//
//  JPNetworking.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

typedef void(^JPNetCallback)(NSString *code, NSString *msg, id resp);
typedef void(^ZJNetCallback)(id resp);
typedef void(^ZJNetProgress)(CGFloat progress);

@interface JPNetworking : NSObject
//  GET
+ (void)getUrl:(NSString *)url params:(NSDictionary *)params progress:(ZJNetProgress)progress callback:(ZJNetCallback)callback;
//  POST
+ (void)postUrl:(NSString *)url params:(id)params progress:(ZJNetProgress)progress callback:(ZJNetCallback)callback;
+ (void)postUrl_V1_0_2:(NSString *)url params:(id)params callback:(JPNetCallback)callback;//  V1.0.2之后的接口
//  上传图片
+ (void)uploadImagesAtUrl:(NSString *)path params:(NSDictionary *)params images:(NSArray<UIImage *> *)images progress:(ZJNetProgress)progress callback:(ZJNetCallback)callback;
@end
