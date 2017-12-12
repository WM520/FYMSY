//
//  KYSLinkagePickerView.h
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray* (^KYSLinkagePickerViewAnalyzeOriginData)();

typedef void (^KYSLinkagePickerViewCompleteSelected)(NSArray *);



@interface KYSLinkagePickerView : UIView

@property(nonatomic,strong)NSArray *widthInComponents;                  //每项的宽度
@property(nonatomic,strong)NSArray *heightInComponents;                 //每项的高度
@property(nonatomic,strong)NSMutableArray *selectedIndexInComponents;   //设置默认选中项

//类方法直接显示
+ (instancetype)KYSShowWithAnalyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData)analyzeBlock
                          completeBlock:(KYSLinkagePickerViewCompleteSelected)completeBlock;

//设置默认选中项，转换并设置数据源,block 返回相应格式的数据源
- (void)setDataArrayWithAnalyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData) block;

//显示
- (void)KYSShow;

@end
