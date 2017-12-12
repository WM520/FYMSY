//
//  IBUserInfoView.h
//  JiePos
//
//  Created by iBlocker on 2017/9/4.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBTextView.h"

// !!!: 类别选择
@interface IBCateSelectView : UIView
/** 名称*/
@property (nonatomic, strong) NSString *title;
/** 回调*/
@property (nonatomic, copy) void (^ib_cateSelectBlock)(NSInteger tag);
- (void)setLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
@end

// !!!: 有标题的输入框
@interface IBInputView : UIView
/** 名称*/
@property (nonatomic, strong) NSString *title;
/** 输入框*/
@property (nonatomic, strong) UITextField *inputField;
@end

// !!!: 带标题的单选框
@class IBOneSelectView;
typedef void (^ib_oneSelectBlock)(IBOneSelectView *blockView);
@interface IBOneSelectView : UIView
/** 选择后的文字*/
@property (nonatomic, strong) UILabel *textLab;
/** 名称*/
@property (nonatomic, strong) NSString *title;
/** 是否编辑状态*/
@property (nonatomic, assign) BOOL  isEditing;
@property (nonatomic, copy) ib_oneSelectBlock block;
@end

// !!!: 不带标题的双选框
@interface IBOnlyTwoSelectView : UIView
/** 按钮*/
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
/** 右侧小角标*/
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *rightView;
/** 选择后的文字*/
@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UILabel *rightLab;
/** 回调*/
@property (nonatomic, copy) void (^ib_leftBlock)(IBOnlyTwoSelectView *blockView, UIButton *leftButton, UILabel *leftLab);
@property (nonatomic, copy) void (^ib_rightBlock)(IBOnlyTwoSelectView *blockView, UIButton *rightButton, UILabel *rightLab);
@end

// !!!: 不带标题的输入框
@interface IBOnlyInputView : UIView
/** 输入框*/
@property (nonatomic, strong) UITextField *inputField;
@end

// !!!: 不带标题的单选框
@class IBOnlyOneSelectView;
typedef void (^ib_onlyOneSelectBlock)(IBOnlyOneSelectView *blockView);
@interface IBOnlyOneSelectView : UIView
/** 选择后的文字*/
@property (nonatomic, strong) UILabel *textLab;
/** 是否编辑状态*/
@property (nonatomic, assign) BOOL  isEditing;
@property (nonatomic, copy) ib_onlyOneSelectBlock block;
@end

//  !!!: - 备注输入框
@interface IBRemarkView : UIView {
    NSString *_remarkString;
}
/** 备注信息输入框*/
@property (nonatomic, strong) IBTextView *txtView;
/** 备注信息*/
@property (nonatomic, copy) NSString *remarkString;
/** 是否可编辑*/
@property (nonatomic, assign) BOOL canEdit;
@end

//  !!!: - 基本信息
typedef void (^ib_nextBlock)();
typedef void (^ib_previousBlock)();
@interface IBBaseInfoView : UIView
@property (nonatomic, copy) ib_nextBlock nextBlock;
@property (nonatomic, copy) ib_previousBlock previousBlock;
@end
