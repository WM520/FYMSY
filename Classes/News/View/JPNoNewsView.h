//
//  JPNoNewsView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/27.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JPResult) {
    JPResultNoNews = 0, //  无消息
    JPResultNoData,     //  无数据
    JPResultNoNet,      //  无网
    JPResultNoNotice,   //  无公告
};

@class JPNoNewsView;

@protocol JPResultDelegate <NSObject>
@optional
- (void)touchScreen:(JPNoNewsView *)resultView;
@end

@interface JPNoNewsView : UIView
@property (nonatomic, assign) JPResult result;
@property (nonatomic, retain) id<JPResultDelegate> delegate;
@end
