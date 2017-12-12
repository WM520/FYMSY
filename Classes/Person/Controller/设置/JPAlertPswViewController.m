//
//  JPAlertPswViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPAlertPswViewController.h"
#import "JPForgetPswViewController.h"

@interface JPAlertPswViewController () <UITextFieldDelegate>

@end

@implementation JPAlertPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self handleUserInterface];
}

#pragma mark - Method
- (void)handleUserInterface {
    weakSelf_declare;
    
    //  原密码
    UILabel *oldPassLab = [self.view viewWithTag:100];
    if (!oldPassLab) {
        oldPassLab = [UILabel new];
        oldPassLab.text = @"原密码";
        oldPassLab.textColor = JP_NoticeText_Color;
        oldPassLab.font = JP_DefaultsFont;
        oldPassLab.tag = 100;
        [self.view addSubview:oldPassLab];
        
        [oldPassLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(30));
            make.top.equalTo(weakSelf.view.mas_top).offset(JPRealValue(40));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(160), JPRealValue(30)));
        }];
    }
    
    //  原密码输入框
    UITextField *oldPassField = [self.view viewWithTag:101];
    if (!oldPassField) {
        oldPassField = [UITextField new];
        oldPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
        oldPassField.tag = 101;
        //  测试 使用默认数据 线上环境注释掉
        oldPassField.placeholder = @"请输入原密码";
        oldPassField.secureTextEntry = YES;
        [oldPassField setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
        [oldPassField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
        [self.view addSubview:oldPassField];
        
        [oldPassField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(oldPassLab.mas_centerY);
            make.left.equalTo(oldPassLab.mas_right).offset(JPRealValue(26));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
            make.height.equalTo(@30);
        }];
    }
    //  原密码分割线
    UILabel *oldPassLine = [self.view viewWithTag:102];
    if (!oldPassLine) {
        oldPassLine = [UILabel new];
        oldPassLine.backgroundColor = JP_LineColor;
        oldPassLine.tag = 102;
        [self.view addSubview:oldPassLine];
        
        [oldPassLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oldPassLab.mas_left);
            make.right.equalTo(oldPassField.mas_right);
            make.top.equalTo(oldPassField.mas_bottom).offset(JPRealValue(10));
            make.height.equalTo(@0.5);
        }];
    }
    //  新密码
    UILabel *passLab = [self.view viewWithTag:103];
    if (!passLab) {
        passLab = [UILabel new];
        passLab.text = @"新密码";
        passLab.textColor = JP_NoticeText_Color;
        passLab.font = JP_DefaultsFont;
        passLab.tag = 103;
        [self.view addSubview:passLab];
        
        [passLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oldPassLab.mas_left);
            make.top.equalTo(oldPassLine.mas_bottom).offset(JPRealValue(50));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(160), JPRealValue(30)));
        }];
    }
    
    //  新密码输入框
    UITextField *passField = [self.view viewWithTag:104];
    if (!passField) {
        passField = [UITextField new];
        passField.clearButtonMode = UITextFieldViewModeWhileEditing;
        passField.tag = 104;
        //  测试 使用默认数据 线上环境注释掉
        passField.placeholder = @"请输入6-20位数字、字母或组合";
        passField.secureTextEntry = YES;
        passField.delegate = self;
        [passField setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
        [passField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
        [self.view addSubview:passField];
        
        [passField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(passLab.mas_centerY);
            make.left.equalTo(passLab.mas_right).offset(JPRealValue(26));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
            make.height.equalTo(@30);
        }];
    }
    
    //  新密码分割线
    UILabel *passLine = [self.view viewWithTag:105];
    if (!passLine) {
        passLine = [UILabel new];
        passLine.backgroundColor = JP_LineColor;
        passLine.tag = 105;
        [self.view addSubview:passLine];
        
        [passLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passLab.mas_left);
            make.right.equalTo(passField.mas_right);
            make.top.equalTo(passField.mas_bottom).offset(JPRealValue(10));
            make.height.equalTo(@0.5);
        }];
    }
    
    //  确认新密码
    UILabel *nPassLab = [self.view viewWithTag:106];
    if (!nPassLab) {
        nPassLab = [UILabel new];
        nPassLab.text = @"确认新密码";
        nPassLab.textColor = JP_NoticeText_Color;
        nPassLab.font = JP_DefaultsFont;
        nPassLab.tag = 106;
        [self.view addSubview:nPassLab];
        
        [nPassLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passLab.mas_left);
            make.top.equalTo(passLine.mas_bottom).offset(JPRealValue(50));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(160), JPRealValue(30)));
        }];
    }
    
    //  确认新密码输入框
    UITextField *nPassField = [self.view viewWithTag:107];
    if (!nPassField) {
        nPassField = [UITextField new];
        nPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nPassField.secureTextEntry = YES;
        nPassField.tag = 107;
        nPassField.placeholder = @"请输入6-20位数字、字母或组合";
        nPassField.delegate = self;
        [nPassField setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
        [nPassField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
        [self.view addSubview:nPassField];
        
        [nPassField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nPassLab.mas_centerY);
            make.left.equalTo(nPassLab.mas_right).offset(JPRealValue(26));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
            make.height.equalTo(@30);
        }];
    }
    
    //  确认新密码分割线
    UILabel *nPassLine = [self.view viewWithTag:108];
    if (!nPassLine) {
        nPassLine = [UILabel new];
        nPassLine.backgroundColor = JP_LineColor;
        nPassLine.tag = 108;
        [self.view addSubview:nPassLine];
        
        [nPassLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nPassLab.mas_left);
            make.right.equalTo(nPassField.mas_right);
            make.top.equalTo(nPassField.mas_bottom).offset(JPRealValue(10));
            make.height.equalTo(@0.5);
        }];
    }
    
    //  确认
    UIButton *nextButton = [self.view viewWithTag:109];
    if (!nextButton) {
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setTitle:@"修改登录密码" forState:UIControlStateNormal];
        nextButton.backgroundColor = JPBaseColor;
        nextButton.layer.cornerRadius = 5;
        nextButton.layer.masksToBounds = YES;
        nextButton.tag = 109;
        [nextButton addTarget:self action:@selector(handleNextClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton];
        
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nPassLine.mas_bottom).offset(JPRealValue(60));
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - JPRealValue(60), JPRealValue(80)));
        }];
    }
    
    //  忘记密码
    UIButton *forgetButton = [self.view viewWithTag:110];
    if (!forgetButton) {
        forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [forgetButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(32)];
        forgetButton.tag = 110;
        [forgetButton addTarget:self action:@selector(handleForgetPass) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetButton];
        
        [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextButton.mas_bottom).offset(JPRealValue(60));
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(150, 30));
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
            
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 20) {
            return NO;//限制长度
        }
        return YES;
        
    }
    return YES;
}

- (void)handleNextClick:(UIButton *)sender {

    //  修改登录密码
    UITextField *oldPassField = [self.view viewWithTag:101];
    UITextField *passField = [self.view viewWithTag:104];
    UITextField *nPassField = [self.view viewWithTag:107];
    if (oldPassField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入原密码！"];
        return;
    }
    if ([passField.text isEqualToString:oldPassField.text]) {
        [SVProgressHUD showInfoWithStatus:@"新密码与您输入的原密码一致！"];
        return;
    }
    if (![NSString judgePassWordLegal:passField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入6~20位数字和字母的组合！"];
        return;
    }
    if (![nPassField.text isEqualToString:passField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码输入不一致！"];
        return;
    }
    
    [MobClick event:@"setting_modifyPass111"];
//    [SVProgressHUD showWithStatus:@"提交中..."];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_modPwd_url];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JPUserEntity sharedUserEntity].jp_user forKey:@"userName"];
    [params setObject:oldPassField.text forKey:@"oldPwd"];
    [params setObject:nPassField.text forKey:@"newPwd"];
    
    weakSelf_declare;
    [JPNetworking postUrl:urlString params:params progress:nil callback:^(id resp) {
        JPLog(@"%@", resp);
        if ([resp isKindOfClass:[NSDictionary class]]) {
            NSInteger returnCode = [resp[@"resultCode"] integerValue];
            switch (returnCode) {
                case 0:
                    [SVProgressHUD showInfoWithStatus:@"用户不存在！"];
                    break;
                case 1:
                    [SVProgressHUD showInfoWithStatus:@"原密码错误！"];
                    break;
                case 2:
                {
                    [SVProgressHUD showInfoWithStatus:@"修改失败！"];
                }
                    break;
                case 3:
                {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
                    //  退出登录
                    if ([JPUserEntity sharedUserEntity].isLogin) {
                        JPUserEntity *user = [JPUserEntity sharedUserEntity];
                        
                        user.jp_user = @"";
                        user.jp_pass = @"";
                        user.merchantNo = @"";
                        user.merchantId = @"";
                        user.applyType = 0;
                        user.isLogin = NO;
                        
//                        [JP_UserDefults removeObjectForKey:@"userLogin"];
                        [JP_UserDefults removeObjectForKey:@"passLogin"];
                        [JP_UserDefults synchronize];
                        
                        [weakSelf performSelector:@selector(handleAlertSuccess) withObject:nil afterDelay:1];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

- (void)handleAlertSuccess {
    JPLoginViewController *loginVC = [[JPLoginViewController alloc] init];
    JPNavigationController *loginNav = [[JPNavigationController alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginNav;
}

- (void)handleForgetPass {
    [MobClick event:@"login_forgetPsw"];
    //  忘记密码
    JPForgetPswViewController *forgetVC = [[JPForgetPswViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
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
