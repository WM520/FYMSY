//
//  JPAboutUsViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPAboutUsViewController.h"

@interface JPAboutUsViewController ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *versionInfoLab;
@property (nonatomic, strong) UIView      *introduceView;
@property (nonatomic, strong) UILabel     *introduceLab;
@end

@implementation JPAboutUsViewController

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"jp_person_set_feiyanLogo"];
    }
    return _logoView;
}

- (UILabel *)versionInfoLab {
    if (!_versionInfoLab) {
        _versionInfoLab = [UILabel new];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        _versionInfoLab.text = [NSString stringWithFormat:@"v %@", localVersion];
        
        _versionInfoLab.font = JP_DefaultsFont;
        _versionInfoLab.textColor = JP_NoticeText_Color;
        _versionInfoLab.textAlignment = NSTextAlignmentCenter;
    }
    return _versionInfoLab;
}

- (UIView *)introduceView {
    if (!_introduceView) {
        _introduceView = [UIView new];
        _introduceView.backgroundColor = [UIColor whiteColor];
    }
    return _introduceView;
}

- (UILabel *)introduceLab {
    if (!_introduceLab) {
        _introduceLab = [UILabel new];
        _introduceLab.numberOfLines = 0;
        _introduceLab.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = JPRealValue(10);// 字体的行间距
        paragraphStyle.paragraphSpacing = JPRealValue(5);
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:JP_DefaultsFont,
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]
                                     };
        _introduceLab.attributedText = [[NSAttributedString alloc] initWithString:JPFeiYanIntroduce attributes:attributes];
    }
    return _introduceLab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.versionInfoLab];
    [self.view addSubview:self.introduceView];
    [self.introduceView addSubview:self.introduceLab];
    
    weakSelf_declare;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).offset(JPRealValue(50));
    }];
    [self.versionInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.logoView.mas_bottom).offset(JPRealValue(10));
        make.centerX.equalTo(weakSelf.logoView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(300), JPRealValue(30)));
    }];
    [self.introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.versionInfoLab.mas_bottom).offset(JPRealValue(40));
        make.height.equalTo(@(JPRealValue(200)));
    }];
    [self.introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.introduceView.mas_top).offset(JPRealValue(20));
        make.left.equalTo(weakSelf.introduceView.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.introduceView.mas_right).offset(JPRealValue(-30));
        make.bottom.equalTo(weakSelf.introduceView.mas_bottom).offset(JPRealValue(-20));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
