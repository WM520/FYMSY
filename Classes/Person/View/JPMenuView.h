//
//  JPMenuView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

#define lineHeight JPRealValue(4)

@interface JPMenuView : UIView
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, assign) NSInteger lastTag;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^jpMenuBlock)(NSInteger tag);
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<NSString *>*)dataSource;
@end
