//
//  JPCodeViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCodeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JPCodeViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *codeBgView;
@property (nonatomic, strong) UILabel *merchantsNameLab;
@property (nonatomic, strong) UIImageView *qrcodeView;
@property (nonatomic, strong) UILabel *supportLab;
@property (nonatomic, strong) UIImageView *aliView;
@property (nonatomic, strong) UIImageView *wechatView;
@property (nonatomic, strong) UIImageView *nodataView;
@end
@implementation JPCodeViewController

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JPBaseColor;
    [self handleUserInterface];
    
    if ([self.codeModel.url isURLString]) {
        
        [self qrcodeViewWithUrlString:self.codeModel.url];
        self.nodataView.hidden = YES;
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    } else {
        self.nodataView.hidden = NO;
    }
}

#pragma mark - Method
- (void)handleUserInterface {
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.logoView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.codeBgView];
    [self.bgView addSubview:self.merchantsNameLab];
    [self.bgView addSubview:self.qrcodeView];
    [self.bgView addSubview:self.supportLab];
    [self.bgView addSubview:self.aliView];
    [self.bgView addSubview:self.wechatView];
    [self.bgView addSubview:self.nodataView];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(JPRealValue(40));
        make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(JPRealValue(-100));
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(45));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.logoView.mas_centerY);
    }];
    [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(90));
        make.left.and.right.equalTo(weakSelf.bgView);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(-286));
    }];
    [self.merchantsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.codeBgView.mas_top);
        make.left.equalTo(weakSelf.logoView.mas_left);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(130)));
    }];
    
    CGFloat width = kScreenWidth - JPRealValue(260);
    [self.qrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX);
        make.top.equalTo(weakSelf.merchantsNameLab.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    [self.supportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.codeBgView.mas_bottom).offset(JPRealValue(50));
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX);
    }];
    [self.aliView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.supportLab.mas_bottom).offset(JPRealValue(50));
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX).offset(JPRealValue(-102));
    }];
    [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.aliView.mas_top);
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX).offset(JPRealValue(102));
    }];
    [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(weakSelf.qrcodeView);
    }];
}

#pragma mark - Lazy
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"f4f9fc"];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"jp_qrcode_feiyanlogo"];
    }
    return _logoView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"飞燕码上付收款码";
        _titleLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UIView *)codeBgView {
    if (!_codeBgView) {
        _codeBgView = [UIView new];
        _codeBgView.backgroundColor = [UIColor whiteColor];
    }
    return _codeBgView;
}
- (UILabel *)merchantsNameLab {
    if (!_merchantsNameLab) {
        _merchantsNameLab = [UILabel new];
        _merchantsNameLab.text = self.codeModel.merchantName;
        _merchantsNameLab.textColor = [UIColor colorWithHexString:@"608dff"];
        _merchantsNameLab.font = [UIFont systemFontOfSize:JPRealValue(40)];
        _merchantsNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _merchantsNameLab;
}
- (UIImageView *)qrcodeView {
    if (!_qrcodeView) {
        _qrcodeView = [UIImageView new];
    }
    return _qrcodeView;
}
- (UILabel *)supportLab {
    if (!_supportLab) {
        _supportLab = [UILabel new];
        _supportLab.text = @"使用支付宝微信扫一扫付款";
        _supportLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _supportLab.textAlignment = NSTextAlignmentCenter;
        _supportLab.textColor = JP_Content_Color;
    }
    return _supportLab;
}
- (UIImageView *)aliView {
    if (!_aliView) {
        _aliView = [UIImageView new];
        _aliView.image = [UIImage imageNamed:@"ali"];
    }
    return _aliView;
}
- (UIImageView *)wechatView {
    if (!_wechatView) {
        _wechatView = [UIImageView new];
        _wechatView.image = [UIImage imageNamed:@"wechat"];
    }
    return _wechatView;
}
- (UIImageView *)nodataView {
    if (!_nodataView) {
        _nodataView = [UIImageView new];
        _nodataView.image = [UIImage imageNamed:@"jp_result_noPaymentCode"];
    }
    return _nodataView;
}

#pragma mark - Action
- (void)rightItemClicked:(UIBarButtonItem *)sender {
    
    [MobClick event:@"qrcode_save"];
    
    UIImage *image = [self makeImageWithView:self.bgView];
    [[JPAlbumManager sharedManager] saveImage:image toAlbum:@"飞燕截图" completionHandler:^(UIImage *image, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"保存失败！"];
        }
    }];
}

//  二维码生成
- (void)qrcodeViewWithUrlString:(NSString *)urlString {
    //二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //将字符串转换成NSData
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    self.qrcodeView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0*[UIScreen mainScreen].scale];
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    //    self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 0.5);//设置阴影的偏移量
    //    self.qrcodeView.layer.shadowRadius = 1;//设置阴影的半径
    //    self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    //    self.qrcodeView.layer.shadowOpacity = 0.3;
}
//改变二维码大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

//  把View写成图片
- (UIImage *)makeImageWithView:(UIView *)view {
    
    CGSize size = (CGSize){kScreenWidth - JPRealValue(60), kScreenHeight - JPRealValue(140)};
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

