//
//  JPPhotoView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/5/24.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPPhotoView : UIView
@property (nonatomic, copy) void (^jp_takePhotoBlock)();
@property (nonatomic, copy) void (^jp_accessAlbumBlock)();
@end
