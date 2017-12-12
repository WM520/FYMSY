//
//  JPNewsTitleView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/5/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, JPNewsType) {
    JPNewsTypeCollection = 1,   //  收款
    JPNewsTypeRefund     = 2,   //  退款
};
@interface JPNewsTitleView : UIView
@property (nonatomic, assign) JPNewsType type;
@end
