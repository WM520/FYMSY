//
//  JPCollectionReusableView.h
//  ColletionView
//
//  Created by Jason_LJ on 2017/6/1.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

//  !!!:JPCollectHeaderView
@interface JPCollectHeaderView : UICollectionReusableView

@end
//  !!!:JPCollectFooterView
@interface JPCollectFooterView : UICollectionReusableView
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) void (^jp_commitUserInfoBlock)();
@property (nonatomic, copy) void (^jp_backBlock)();
@end
