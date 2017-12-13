//
//  JPSettingViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPSettingViewController.h"
#import "JPAlertPswViewController.h"
#import "JPNotiSettingViewController.h"
#import "JPAboutUsViewController.h"
#import "IBDataBase.h"

#define configImage @"configImage"
#define configName  @"configName"
@interface JPSettingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSArray <NSArray *>* configArray;
@end

@implementation JPSettingViewController

- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.rowHeight = 60;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorColor = JP_LineColor;
    }
    return _ctntView;
}

- (NSArray<NSArray *> *)configArray {
    if (!_configArray) {
        _configArray = [NSArray arrayWithObjects:
                        @[@{
                              configImage : @"jp_person_set_psw",
                              configName : @"登录密码修改"
                              },
                          @{
                              configImage : @"jp_person_set_dealMes",
                              configName : @"交易消息通知设置"
                              }],
                        @[@{
                              configImage : @"jp_person_set_aboutUs",
                              configName : @"关于飞燕码上付"
                              }], nil];
    }
    return _configArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.ctntView];
}

#pragma mark - tableViewDataSource
static NSString *settingCellReuseIdentifier = @"settingCell";
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.configArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.configArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = JP_DefaultsFont;
    }
    NSDictionary *configDic = self.configArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:configDic[configImage]];
    cell.textLabel.text = configDic[configName];
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [MobClick event:@"setting_modifyPass"];
            //  登录密码修改
            JPAlertPswViewController *alertPswVC = [[JPAlertPswViewController alloc] init];
            alertPswVC.navigationItem.title = @"登录密码修改";
            [self.navigationController pushViewController:alertPswVC animated:YES];
        } else {
            [MobClick event:@"setting_notiSetting"];
            //  交易消息通知设置
            JPNotiSettingViewController *notiSettingVC = [[JPNotiSettingViewController alloc] init];
            notiSettingVC.navigationItem.title = @"交易消息通知设置";
            [self.navigationController pushViewController:notiSettingVC animated:YES];
        }
    } else {
        [MobClick event:@"setting_aboutUs"];
        //  关于我们
        JPAboutUsViewController *aboutUsVC = [[JPAboutUsViewController alloc] init];
        aboutUsVC.navigationItem.title = @"关于飞燕码上付";
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(28);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? 100 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = JP_viewBackgroundColor;
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.titleLabel.font = JP_DefaultsFont;
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
    logoutButton.layer.cornerRadius = 5;
    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.borderColor = JP_NoticeText_Color.CGColor;
    logoutButton.layer.borderWidth = 1;
    [logoutButton setBackgroundColor:JP_viewBackgroundColor];
    [logoutButton addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutButton];
    
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(JPRealValue(50));
        make.left.equalTo(footerView.mas_left).offset(JPRealValue(50));
        make.right.equalTo(footerView.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(100)));
    }];
    
    return section == 1 ? footerView : nil;
}

#pragma mark - action
- (void)logoutClick:(UIButton *)sender {
    weakSelf_declare;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"退出登录将删除本地推送消息记录，是否退出？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  确认退出
        JPLog(@"退出登录按钮点击了");
        
        [MobClick event:@"setting_logout"];
        
        JPUserEntity *user = [JPUserEntity sharedUserEntity];
        
        if (user.isLogin) {
            
            if ([JPUserEntity sharedUserEntity].merchantNo) {
                NSMutableDictionary *params = @{}.mutableCopy;
                
                [params setObject:[JPUserEntity sharedUserEntity].merchantNo forKey:@"alias"];
                [params setObject:JP_UMessageAliasType forKey:@"aliasType"];
                //  appType 1：安卓飞燕，2：安卓杰宝宝，3：iOS杰宝宝，4：iOS飞燕
                [params setObject:@"4" forKey:@"appType"];
                
//                NSString *UUID = [[IBUUIDManager getUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *UUID = @"";
                // 获取保存的uuid
                if ([JP_UserDefults objectForKey:@"deviceUUID"]) {
                    UUID = [JP_UserDefults objectForKey:@"deviceUUID"];
                }
                [params setObject:UUID forKey:@"deviceUUID"];
                
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                //  当前App版本号
                [params setObject:localVersion forKey:@"versionNo"];
                if ([JP_UserDefults objectForKey:@"deviceToken"]) {
                    [params setObject:[JP_UserDefults objectForKey:@"deviceToken"] forKey:@"deviceTokens"];
                }
                
                NSString *systemVersion = [NSString stringWithFormat:@"IOS_%@", [UIDevice currentDevice].systemVersion];
                //  系统版本号
                [params setObject:systemVersion forKey:@"IOSVersion"];
                // !!!: 退出系统绑定
                [JPNetworking postUrl:ib_JPushLogoutUrl params:params progress:nil callback:^(id resp) {
                    NSLog(@"init application \n resp - %@", resp);
                }];
            }
            //  清除本地推送消息
            [[IBDataBase sharedDataBase] deleteTable];
                        
            [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"删除alias - %ld - %@ - %ld", iResCode, iAlias, seq);
            } seq:0];
            
            user.jp_user = @"";
            user.jp_pass = @"";
            user.merchantNo = @"";
            user.merchantId = @"";
            user.applyType = 0;
            user.isLogin = NO;
            
//            [JP_UserDefults removeObjectForKey:@"userLogin"];
            [JP_UserDefults removeObjectForKey:@"passLogin"];
            [JP_UserDefults synchronize];
            
            JPNavigationController *loginNav = [[JPNavigationController alloc] initWithRootViewController:[JPLoginViewController new]];
            [weakSelf.view.window setRootViewController:loginNav];
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
