//
//  JPApplyUserInfoCell.h
//  JiePos
//
//  Created by Jason_LJ on 2017/5/25.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPRequestLabel.h"
#import "JPSelectButton.h"

// !!!: JPOnlyOneSelectCell
@interface JPOnlyOneSelectCell : UITableViewCell
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
/** 右侧小角标*/
@property (nonatomic, strong) UIImageView *tipView;
/** 选择后的文字*/
@property (nonatomic, strong) UILabel *textLab;
/** 是否编辑状态*/
@property (nonatomic, assign) BOOL  isEditing;
@end

// !!!: JPOnlyTwoSelectCell
@interface JPOnlyTwoSelectCell : UITableViewCell
/** 按钮*/
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
/** 右侧小角标*/
@property (nonatomic, strong) UIImageView *tipView1;
@property (nonatomic, strong) UIImageView *tipView2;
/** 选择后的文字*/
@property (nonatomic, strong) UILabel *textLab1;
@property (nonatomic, strong) UILabel *textLab2;
/** 回调*/
@property (nonatomic, copy) void (^jpOnlyTwoSelect_leftBlock)(UIButton *leftButton, UILabel *leftLab);
@property (nonatomic, copy) void (^jpOnlyTwoSelect_rightBlock)(UIButton *rightButton, UILabel *rightLab);
@end

// !!!: JPOneSelectCell
@interface JPOneSelectCell : UITableViewCell
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
/** 右侧小角标*/
@property (nonatomic, strong) UIImageView *tipView;
/** 选择后的文字*/
@property (nonatomic, strong) UILabel *textLab;
/** 名称*/
@property (nonatomic, strong) NSString *title;
/** 名称标签*/
@property (nonatomic, strong) JPRequestLabel *titleLab;
/** 是否编辑状态*/
@property (nonatomic, assign) BOOL  isEditing;
@end

// !!!: JPTwoSelectCell
@interface JPTwoSelectCell : UITableViewCell
/** 按钮*/
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
/** 右侧小角标*/
@property (nonatomic, strong) UIImageView *tipView1;
@property (nonatomic, strong) UIImageView *tipView2;
/** 选择后的文字*/
@property (nonatomic, strong) UILabel *textLab1;
@property (nonatomic, strong) UILabel *textLab2;
/** 名称*/
@property (nonatomic, strong) NSString *title;
/** 名称标签*/
@property (nonatomic, strong) JPRequestLabel *titleLab;
/** 回调*/
@property (nonatomic, copy) void (^jpTwoSelect_leftBlock)(UIButton *leftButton, UILabel *leftLab);
@property (nonatomic, copy) void (^jpTwoSelect_rightBlock)(UIButton *rightButton, UILabel *rightLab);
@end

// !!!: JPInputCell
@interface JPInputCell : UITableViewCell
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
/** 名称*/
@property (nonatomic, strong) NSString *title;
/** 名称标签*/
@property (nonatomic, strong) JPRequestLabel *titleLab;
/** 输入框*/
@property (nonatomic, strong) UITextField *inputField;
@end

// !!!: JPOnlyInputCell
@interface JPOnlyInputCell : UITableViewCell
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
/** 输入框*/
@property (nonatomic, strong) UITextField *inputField;
@end

// !!!: JPCateSelectCell
@interface JPCateSelectCell : UITableViewCell
/** 背景变色框*/
@property (nonatomic, strong) UIView  *bgView;
/** 按钮*/
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
/** 名称*/
@property (nonatomic, strong) NSString *title;
/** 名称标签*/
@property (nonatomic, strong) JPRequestLabel *titleLab;
/** 回调*/
@property (nonatomic, copy) void (^jp_cateSelectBlock)(NSInteger tag);
- (void)setLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
@end

//  !!!: - JPCredentialsCell
@interface JPCredentialsCell : UICollectionViewCell
@property (nonatomic, copy) void (^credentialsDeleteImageBlock)(JPCredentialsCell *item);
/** 图片路径*/
@property (nonatomic, copy) NSString *imgUrl;
/** 占位名称*/
@property (nonatomic, copy) NSString *placeholderName;
/** 图片*/
@property (nonatomic, strong) UIImage *image;
/** 是否有图片*/
@property (nonatomic, assign) BOOL hasImage;
/** 是否可编辑*/
@property (nonatomic, assign) BOOL canEditing;
/** 背景图片*/
@property (nonatomic, strong) UIImageView *bgView;
/** 图片标识*/
@property (nonatomic, copy) NSString *imgCode;
/** 是否必传*/
@property (nonatomic, assign) BOOL isNeed;
/** 图片发生修改*/
@property (nonatomic, assign) BOOL valueHasChange;
/** 添加图片*/
@property (nonatomic, strong) UIImageView *addView;
/** 图片名*/
@property (nonatomic, strong) UILabel *imgNameLab;
@end



