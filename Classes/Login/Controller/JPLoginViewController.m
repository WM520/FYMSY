//
//  JPLoginViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPLoginViewController.h"
#import "JPForgetPswViewController.h"
#import "QRCodeScanningVC.h"
#import "IBBaseInfoViewController.h"

@interface JPLoginViewController () <UITextFieldDelegate>
@property (nonatomic, assign) BOOL isRemember;
@end

@implementation JPLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  申请入驻失败后重新打开App清除缓存数据
    [JPUserInfoHelper clearData];
    
    self.navigationController.navigationBarHidden = YES;
    
    //  密码输入框
    UITextField *passField = [self.view viewWithTag:106];
    if (_isRemember) {
        //  记住密码：修改存在本地的密码
        passField.text = [JP_UserDefults objectForKey:@"passLogin"];
    } else {
        //  不记住密码：删除已存在本地的密码
        passField.text = @"";
    }
    
    //  记住密码时自动登录
    if (_isRemember && [JP_UserDefults objectForKey:@"userLogin"] && [JP_UserDefults objectForKey:@"passLogin"]) {
        [self handleLoginRequest:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    
    if (![JP_UserDefults boolForKey:@"defaultRemember"]) {
        _isRemember = [JP_UserDefults boolForKey:@"remember"];
        [JP_UserDefults setBool:YES forKey:@"remember"];
        [JP_UserDefults setBool:YES forKey:@"defaultRemember"];
    }
    _isRemember = [JP_UserDefults boolForKey:@"remember"];
    
    [self handleUserInterface];
}

- (void)handleUserInterface {
    weakSelf_declare;
    //  背景
    UIImageView *imageView = [self.view viewWithTag:101];
    if (!imageView) {
        imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"jp_login_back"];
        imageView.tag = 101;
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(weakSelf.view);
            make.height.equalTo(@(JPRealValue(460)));
        }];
    }
    //  飞燕logo
    UIImageView *feiyanView = [self.view viewWithTag:102];
    if (!feiyanView) {
        feiyanView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jp_login_feiyan"]];
        feiyanView.tag = 102;
        [self.view addSubview:feiyanView];
        
        [feiyanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(imageView);
        }];
    }
    //  用户名logo
    UIImageView *userView = [self.view viewWithTag:103];
    if (!userView) {
        userView = [UIImageView new];
        userView.image = [UIImage imageNamed:@"jp_login_user"];
        userView.tag = 103;
        [self.view addSubview:userView];
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(50));
            make.top.equalTo(imageView.mas_bottom).offset(JPRealValue(80));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(28), JPRealValue(34)));
        }];
    }
    //  密码logo
    UIImageView *passView = [self.view viewWithTag:104];
    if (!passView) {
        passView = [UIImageView new];
        passView.image = [UIImage imageNamed:@"jp_login_pass"];
        passView.tag = 104;
        [self.view addSubview:passView];
        
        [passView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userView.mas_left);
            make.top.equalTo(userView.mas_bottom).offset(JPRealValue(60));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(28), JPRealValue(34)));
        }];
    }
    //  用户名输入框
    UITextField *userField = [self.view viewWithTag:105];
    if (!userField) {
        userField = [UITextField new];
        userField.placeholder = @"账号";
        userField.clearButtonMode = UITextFieldViewModeWhileEditing;
        userField.tag = 105;
        //  测试 使用默认数据 线上环境注释掉
        userField.text = @"cxq123";
        userField.delegate = self;
        [self.view addSubview:userField];
        
        [userField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userView.mas_right).offset(JPRealValue(20));
            make.centerY.equalTo(userView.mas_centerY);
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-50));
            make.height.equalTo(@(JPRealValue(60)));
        }];
    }
    if ([JP_UserDefults objectForKey:@"userLogin"]) {
        userField.text = [JP_UserDefults objectForKey:@"userLogin"];
    } else {
        userField.text = @"";
    }
    
    //  密码输入框
    UITextField *passField = [self.view viewWithTag:106];
    if (!passField) {
        passField = [UITextField new];
        passField.placeholder = @"密码";
        passField.clearButtonMode = UITextFieldViewModeWhileEditing;
        passField.secureTextEntry = YES;
        //  测试 使用默认数据 线上环境注释掉
//        passField.text = @"123";
        passField.tag = 106;
        passField.delegate = self;
        [self.view addSubview:passField];
        
        [passField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.height.equalTo(userField);
            make.centerY.equalTo(passView.mas_centerY);
        }];
    }
    
    if (_isRemember && [JP_UserDefults objectForKey:@"passLogin"]) {
        passField.text = [JP_UserDefults objectForKey:@"passLogin"];
    } else {
        passField.text = @"";
    }
    
    //  用户名分割线
    UILabel *userLine = [self.view viewWithTag:107];
    if (!userLine) {
        userLine = [UILabel new];
        userLine.backgroundColor = JP_LineColor;
        userLine.tag = 107;
        [self.view addSubview:userLine];
        
        [userLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userView.mas_right);
            make.right.equalTo(userField.mas_right);
            make.top.equalTo(userField.mas_bottom).offset(2);
            make.height.equalTo(@0.5);
        }];
    }
    //  密码分割线
    UILabel *passLine = [self.view viewWithTag:108];
    if (!passLine) {
        passLine = [UILabel new];
        passLine.backgroundColor = JP_LineColor;
        passLine.tag = 108;
        [self.view addSubview:passLine];
        
        [passLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.height.equalTo(userLine);
            make.top.equalTo(passField.mas_bottom).offset(2);
        }];
    }
    //  登录按钮
    UIButton *loginButton = [self.view viewWithTag:109];
    if (!loginButton) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        loginButton.backgroundColor = JPBaseColor;
        loginButton.layer.cornerRadius = 3;
        loginButton.layer.masksToBounds = YES;
        [loginButton addTarget:self action:@selector(handleLoginRequest:) forControlEvents:UIControlEventTouchUpInside];
        loginButton.tag = 109;
        [self.view addSubview:loginButton];
        
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passLine.mas_bottom).offset(JPRealValue(80));
            make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(50));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-50));
            make.height.equalTo(@(JPRealValue(94)));
        }];
    }
    
    //  商户入驻按钮
    UIButton *registerButton = [self.view viewWithTag:113];
    if (!registerButton) {
        registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [registerButton setTitle:@"商户入驻" forState:UIControlStateNormal];
        [registerButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        registerButton.layer.borderColor = JPBaseColor.CGColor;
        registerButton.layer.borderWidth = 1.0;
        registerButton.layer.cornerRadius = 5;
        registerButton.layer.masksToBounds = YES;
        [registerButton addTarget:self action:@selector(handleRegisterRequest:) forControlEvents:UIControlEventTouchUpInside];
        registerButton.tag = 113;
        [self.view addSubview:registerButton];
        
        [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loginButton.mas_bottom).offset(JPRealValue(20));
            make.left.equalTo(loginButton.mas_left);
            make.right.equalTo(loginButton.mas_right);
            make.height.equalTo(@(JPRealValue(94)));
        }];
    }
    
    //  记住密码按钮
    UIButton *rememberButton = [self.view viewWithTag:110];
    if (!rememberButton) {
        rememberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rememberButton setTitle:@"记住密码" forState:UIControlStateNormal];
        [rememberButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [rememberButton setImage:[UIImage imageNamed:@"jp_login_remember"] forState:UIControlStateNormal];
        if (_isRemember) {
            [rememberButton setImage:[UIImage imageNamed:@"jp_login_remember_selected"] forState:UIControlStateNormal];
        } else {
            [rememberButton setImage:[UIImage imageNamed:@"jp_login_remember"] forState:UIControlStateNormal];
        }
        rememberButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(24)];
        [rememberButton addTarget:self action:@selector(handleRememberPass:) forControlEvents:UIControlEventTouchUpInside];
        rememberButton.tag = 110;
        [self.view addSubview:rememberButton];
        
        [rememberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(registerButton.mas_left);
            make.top.equalTo(registerButton.mas_bottom).offset(JPRealValue(30));
            make.height.equalTo(@(JPRealValue(30)));
        }];
    }
    //  忘记密码按钮
    UIButton *forgetButton = [self.view viewWithTag:111];
    if (!forgetButton) {
        forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [forgetButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(24)];
        forgetButton.tag = 111;
        [forgetButton addTarget:self action:@selector(handleForgetPass) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetButton];
        
        [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(registerButton.mas_right);
            make.top.equalTo(registerButton.mas_bottom).offset(JPRealValue(30));
            make.height.equalTo(@(JPRealValue(30)));
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - action
//  登录
- (void)handleLoginRequest:(UIButton *)sender {
    weakSelf_declare;
    //  监控网络状态变化
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2:
            {
                [weakSelf login];
            }
                break;
            default: {
                JPLog(@"没网");
            }
                break;
        }
    }];
}

//  商户入驻
- (void)handleRegisterRequest:(UIButton *)sender {
    
//#ifdef DEBUG
    //  直接跳到基本信息录入
//    IBBaseInfoViewController *baseVC = [IBBaseInfoViewController new];
//    baseVC.qrcodeid = @"725a17e47dde40fd912c4951b4d46bb4";
//    [self.navigationController pushViewController:baseVC animated:YES];
    
//    JPBaseInfoViewController *baseinfoVC = [JPBaseInfoViewController new];
//    baseinfoVC.qrcodeid = @"725a17e47dde40fd912c4951b4d46bb4";
//    [self.navigationController pushViewController:baseinfoVC animated:YES];
//#else
    //  跳到二维码扫描界面
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{

                        [MobClick event:@"login_register"];

                        QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });

                    SGQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    SGQRCodeLog(@"用户第一次同意了访问相机权限");

                } else {

                    // 用户第一次拒绝了访问相机权限
                    SGQRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            [MobClick event:@"login_register"];

            QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

            }];

            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];

        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

        }];

        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
//#endif
}

//  记住密码
- (void)handleRememberPass:(UIButton *)rememberBtn {
    
    [MobClick event:@"login_rememberPsw"];
    
    _isRemember = !_isRemember;
    if (_isRemember) {
        JPLog(@"记住密码");
        [rememberBtn setImage:[UIImage imageNamed:@"jp_login_remember_selected"] forState:UIControlStateNormal];
    } else {
        JPLog(@"不记住密码");
        [rememberBtn setImage:[UIImage imageNamed:@"jp_login_remember"] forState:UIControlStateNormal];
    }
    [JP_UserDefults setBool:_isRemember forKey:@"remember"];
    [JP_UserDefults synchronize];
}

//  忘记密码
- (void)handleForgetPass {
    
    [MobClick event:@"login_forgetPsw"];
    
    JPForgetPswViewController *forgetVC = [[JPForgetPswViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login {
    //  用户名输入框
    UITextField *userField = [self.view viewWithTag:105];
    //  密码输入框
    UITextField *passField = [self.view viewWithTag:106];
    if (userField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入账号！"];
        return;
    }
    if (passField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码！"];
        return;
    }
    
    [MobClick event:@"login_click"];
    
    [JP_UserDefults setObject:userField.text forKey:@"userLogin"];
    [SVProgressHUD showWithStatus:@"登录中，请稍后..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userField.text forKey:@"userName"];
    [params setObject:passField.text forKey:@"userPwd"];
    [params setObject:@"fym" forKey:@"appCode"];
    
    JPLog(@"params - %@", params);
    
    NSString *url = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_login_url];
    JPUserEntity *user = [JPUserEntity sharedUserEntity];
    weakSelf_declare;
    [JPNetworking postUrl:url params:params progress:nil callback:^(id resp) {
        JPLog(@"登录 - %@", resp);
        if ([resp isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)resp;
            NSArray *keys = dic.allKeys;
            
            int resultCode = [dic[@"resultCode"] intValue];
            if (resultCode == 0) {
                [SVProgressHUD showInfoWithStatus:@"该用户不存在！"];
                user.isLogin = NO;
            } else if (resultCode == 1) {
                [SVProgressHUD showInfoWithStatus:@"密码错误！"];
                user.isLogin = NO;
            } else if (resultCode == 2) {
                [SVProgressHUD dismiss];
                
                //  登录成功 先把用户名存到本地
                [JP_UserDefults setObject:userField.text forKey:@"userLogin"];
                if ([keys containsObject:@"merchantNo"]) {
                    NSString *merchantNo = dic[@"merchantNo"];
                    if (![merchantNo isEqual:[NSNull null]]) {
                        [JP_UserDefults setObject:merchantNo forKey:@"merchantNo"];
                        user.merchantNo = merchantNo;
                        
//                        [JPUSHService setAlias:merchantNo completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                            NSLog(@"%@ - %ld", iAlias, seq);
//                        } seq:0];
                        
                        NSString *UUID = [[IBUUIDManager getUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                        UUID = [UUID substringToIndex:10];
                        [JPUSHService setAlias:UUID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                            NSLog(@"%@ - %ld", iAlias, seq);
                        } seq:0];
                        
                        if ([JP_UserDefults objectForKey:@"deviceToken"]) {
                            //  友盟Alias上传服务器
                            NSMutableDictionary *parameters = @{}.mutableCopy;
                            [parameters setObject:merchantNo forKey:@"alias"];
                            [parameters setObject:JP_UMessageAliasType forKey:@"aliasType"];
                            //  appType 1：安卓飞燕，2：安卓杰宝宝，3：iOS杰宝宝，4：iOS飞燕
                            [parameters setObject:@"4" forKey:@"appType"];
                            
                            NSString *UUID = [[IBUUIDManager getUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                            UUID = [UUID substringToIndex:10];
                            [parameters setObject:UUID forKey:@"deviceUUID"];
                            
                            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                            NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                            //  当前App版本号
                            [parameters setObject:localVersion forKey:@"versionNo"];
                            [parameters setObject:[JP_UserDefults objectForKey:@"deviceToken"] forKey:@"deviceTokens"];
                            
                            NSString *systemVersion = [NSString stringWithFormat:@"IOS_%@", [UIDevice currentDevice].systemVersion];
                            //  系统版本号
                            [parameters setObject:systemVersion forKey:@"IOSVersion"];
                            
                            JPLog(@"parameters - %@", parameters);
                            [JPNetworking postUrl:ib_JPushAliasUrl params:parameters progress:nil callback:^(id resp) {
                                JPLog(@"------%@", resp);
//                                if ([resp isKindOfClass:[NSDictionary class]]) {
//                                    BOOL suc = [resp[@"responseCode"] isEqualToString:@"0"];
//                                }
                            }];
                        }
                    }
                }
                if ([keys containsObject:@"merchantName"]) {
                    //  获取共享域的偏好设置
                    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.JieposExtention"];
                    [userDefault setObject:dic[@"merchantName"] forKey:@"merchantName"];
                    [userDefault synchronize];
                    
                    user.merchantName = dic[@"merchantName"];
                }
                if ([keys containsObject:@"merchantId"]) {
                    user.merchantId = dic[@"merchantId"];
                }
                if ([keys containsObject:@"applyType"]) {
                    user.applyType = [dic[@"applyType"] integerValue];
                }
                user.jp_user = userField.text;
                user.jp_pass = passField.text;
                user.isLogin = YES;
                if (_isRemember) {
                    [JP_UserDefults setObject:passField.text forKey:@"passLogin"];
                    [JP_UserDefults synchronize];
                }
                //  跳转tabBarController首页
                JPTabBarController *tabBarController = [[JPTabBarController alloc] init];
                [weakSelf.view.window setRootViewController:tabBarController];
            } else {
                [SVProgressHUD showInfoWithStatus:@"登录失败！"];
                user.isLogin = NO;
            }
        } else {
            [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
        }
    }];
}
#pragma mark - textField只允许输入字母和数字
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //  用户名输入框
    UITextField *userField = [self.view viewWithTag:105];
    //  密码输入框
    UITextField *passField = [self.view viewWithTag:106];
    if(textField == userField) {
        [MobClick event:@"login_user"];
    } else if (textField == passField) {
        [MobClick event:@"login_pass"];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField) {
        //  lengthOfString的值始终为1
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            //  将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            unichar character = [string characterAtIndex:loopIndex];
            //  48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO;
            if (character > 57 && character < 65) return NO;
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        //  Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 20) {
            //  限制长度
            return NO;
        }
        return YES;
    }
    return YES;
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
