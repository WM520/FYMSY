//
//  KYSNormalPickerView.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 2016/11/17.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KYSLinkagePickerViewCompleteSelectedBlock)(NSArray *);

@interface KYSNormalPickerView : UIView

@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,strong)NSArray *widthInComponents;                  //每项的宽度
@property(nonatomic,strong)NSArray *heightInComponents;                 //每项的高度
@property(nonatomic,strong)NSMutableArray *selectedIndexInComponents;   //设置默认选中项

@property(nonatomic,copy)KYSLinkagePickerViewCompleteSelectedBlock selectedBlock;//选择完成回调

//类方法直接显示
/*
  注意数据类型是数组包含数组
  @[@[@"1",@"2",@"3"]]
 */
+ (instancetype)KYSShowWithDataArray:(NSArray *) dataArray
                       completeBlock:(KYSLinkagePickerViewCompleteSelectedBlock) selectedBlock;


//显示
- (void)KYSShow;

@end
