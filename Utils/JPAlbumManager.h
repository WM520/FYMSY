//
//  JPAlbumManager.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/11.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class UIImage;
typedef void (^JPAlbumSaveHandler)(UIImage *image, NSError *error);

/**
 * @brief 将图片写入相册,使用ALAssetLibrary
 *
 * @param  image    需要写入的图片
 * @param  album    相册名称，如果相册不存在，则新建相册
 * @param  completionHandler 回调
 */
extern void JPImageWriteToPhotosAlbum(UIImage *image, NSString *album, JPAlbumSaveHandler completionHandler);

@interface JPAlbumManager : NSObject
+ (instancetype)sharedManager;

/**
 * @brief 将图片写入相册,使用ALAssetLibrary
 *
 * @param  image    需要写入的图片
 * @param  album    相册名称，如果相册不存在，则新建相册
 * @param  completionHandler 回调
 */
- (void)saveImage:(UIImage *)image toAlbum:(NSString *)album completionHandler:(JPAlbumSaveHandler)completionHandler;
@end

@interface ALAssetsLibrary (JPAssetsLibrary)

- (void)writeImage:(UIImage *)image toAlbum:(NSString *)album completionHandler:(JPAlbumSaveHandler)completionHandler;

@end
