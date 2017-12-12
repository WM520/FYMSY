//
//  JPPhotoView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/24.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPPhotoView.h"

@interface JPPhotoView ()
/**
 背景
 */
@property (nonatomic, strong) UIView    *bgView;
/**
 分割线
 */
@property (nonatomic, strong) UIView    *lineView;
/**
 照相
 */
@property (nonatomic, strong) UIButton  *takePhotoButton;
/**
 访问相册
 */
@property (nonatomic, strong) UIButton  *accessAlbumButton;
@end
@implementation JPPhotoView

float __cornerRadius = 5;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}

- (void)handleUserInterface {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    if (!self.bgView) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = __cornerRadius;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
    }
    if (!self.lineView) {
        self.lineView = [UIView new];
        self.lineView.backgroundColor = JP_LineColor;
        [self.bgView addSubview:self.lineView];
    }
    if (!self.takePhotoButton) {
        self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        //TODO:uiview 单边圆角或者单边框
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.takePhotoButton.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(__cornerRadius, __cornerRadius)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.takePhotoButton.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.takePhotoButton.layer.mask = maskLayer;
        
        self.takePhotoButton.titleLabel.font = JP_DefaultsFont;
        [self.takePhotoButton setTitle:@"\t\t\t拍照" forState:UIControlStateNormal];
        [self.takePhotoButton setTitleColor:JP_NoticeText_Color forState:UIControlStateNormal];
//        [self.takePhotoButton setImage:[UIImage imageNamed:@"jp_person_photoCamera"] forState:UIControlStateNormal];
        [self.takePhotoButton addTarget:self action:@selector(takePhotos:) forControlEvents:UIControlEventTouchUpInside];
        self.takePhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.bgView addSubview:self.takePhotoButton];
        
        UIImageView *cameraView = [UIImageView new];
        cameraView.image = [UIImage imageNamed:@"jp_person_photoCamera"];
        cameraView.userInteractionEnabled = YES;
        [self.takePhotoButton addSubview:cameraView];
        weakSelf_declare;
        [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.takePhotoButton.mas_centerY);
            make.right.equalTo(weakSelf.takePhotoButton.mas_right).offset(JPRealValue(-20));
        }];
    }
    if (!self.accessAlbumButton) {
        self.accessAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.accessAlbumButton.titleLabel.font = JP_DefaultsFont;
        [self.accessAlbumButton setTitle:@"\t\t\t从相册选择" forState:UIControlStateNormal];
        [self.accessAlbumButton setTitleColor:JP_NoticeText_Color forState:UIControlStateNormal];
//        [self.accessAlbumButton setImage:[UIImage imageNamed:@"jp_person_photoPicture"] forState:UIControlStateNormal];
        [self.accessAlbumButton addTarget:self action:@selector(accessAlbums:) forControlEvents:UIControlEventTouchUpInside];
        self.accessAlbumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.bgView addSubview:self.accessAlbumButton];
        
        UIImageView *albumView = [UIImageView new];
        albumView.image = [UIImage imageNamed:@"jp_person_photoPicture"];
        albumView.userInteractionEnabled = YES;
        [self.accessAlbumButton addSubview:albumView];
        weakSelf_declare;
        [albumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.accessAlbumButton.mas_centerY);
            make.right.equalTo(weakSelf.accessAlbumButton.mas_right).offset(JPRealValue(-20));
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(530), JPRealValue(165)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.left.and.right.equalTo(weakSelf.bgView);
        make.height.equalTo(@0.5);
    }];
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
        make.top.equalTo(weakSelf.bgView.mas_top);
        make.right.equalTo(weakSelf.bgView.mas_right);
        make.bottom.equalTo(weakSelf.lineView.mas_top);
    }];
    [self.accessAlbumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.right.equalTo(weakSelf.bgView.mas_right);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom);
    }];
}

- (void)takePhotos:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.jp_takePhotoBlock) {
        self.jp_takePhotoBlock();
    }
}

- (void)accessAlbums:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.jp_accessAlbumBlock) {
        self.jp_accessAlbumBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = touches.anyObject;
    CGPoint location2 = [touch locationInView:self.bgView];
    
//    NSLog(@"%@",NSStringFromCGPoint(location2));
    if (NSStringFromCGPoint(location2)) {
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
