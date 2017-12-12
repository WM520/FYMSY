//
//  JPNotiSettingViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNotiSettingViewController.h"

#define imageName       @"imageName"
#define configName      @"configName"
#define aSwitchValue    @"aSwitchValue"

@interface JPSettingCell : UITableViewCell
@property (nonatomic, strong) UISwitch *aSwitch;
@property (nonatomic, copy, nullable) void (^switchBlock)(UISwitch *aSwitch, NSInteger tag, BOOL isOn);
@end

@implementation JPSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}

- (void)handleUserInterface {
    //  处理UI
    self.aSwitch = [UISwitch new];
    //    self.aSwitch.on = YES;
    self.aSwitch.tintColor = JPBaseColor;
    self.aSwitch.onTintColor = JPBaseColor;
    [self.aSwitch addTarget:self action:@selector(aSwitchClick:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.aSwitch];
}

- (void)aSwitchClick:(UISwitch *)sender {
    self.switchBlock (sender, sender.tag, [sender isOn]);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    
    [self.aSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 28));
    }];
}

@end

@interface JPNotiSettingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray <NSArray *>*configArray;
@property (nonatomic, strong) UITableView *ctntView;
@end

@implementation JPNotiSettingViewController

- (NSArray<NSArray *> *)configArray {
    if (!_configArray) {
        //  这个值需要和JPServiceNotification共享
        NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.JieposExtention"];
        _configArray = [NSArray arrayWithObjects:
                        @[
                          @{
                              configName : @"接收消息通知",
                              imageName : @"jp_person_set_noti",
                              aSwitchValue : [NSNumber numberWithBool:[userDefault boolForKey:@"noti_value"]]
                              }
                          ],
                        @[
                          @{
                              configName : @"语音播报",
                              imageName : @"jp_person_set_voice",
                              aSwitchValue : [NSNumber numberWithBool:[userDefault boolForKey:@"voice_value"]]
                              }
                          ], nil];
    }
    return _configArray;
}

- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.scrollEnabled = NO;
        _ctntView.separatorColor = JP_LineColor;
    }
    return _ctntView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.ctntView];
}

#pragma mark - tableViewDataSource
static NSString *cellReuseIdentifier = @"cellReuseIdentifier";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.configArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.configArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPSettingCell *cell = (JPSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[JPSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = JP_DefaultsFont;
    }
    NSDictionary *configDic = self.configArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:configDic[imageName]];
    cell.textLabel.text = configDic[configName];
    cell.aSwitch.on = [configDic[aSwitchValue] boolValue];
    cell.aSwitch.tag = indexPath.section * 10 + indexPath.row + 1;
    
    weakSelf_declare;
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.JieposExtention"];
    cell.switchBlock = ^(UISwitch *aSwitch, NSInteger tag, BOOL isOn) {
        UISwitch *notiSwitch = (UISwitch *)[weakSelf.view viewWithTag:1];
        UISwitch *voiceSwitch = (UISwitch *)[weakSelf.view viewWithTag:11];
        if (tag == 1) {
            [MobClick event:@"setting_getNoti"];
            if (isOn) {
                JPLog(@"通知开启了");

                //  绑定推送alias
//                [JPUSHService setAlias:[JP_UserDefults objectForKey:@"merchantNo"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                    if (iResCode == 0) {
//                        JPLog(@"绑定成功！");
//                        notiSwitch.on = YES;
//                        [userDefault setBool:YES forKey:@"noti_value"];
//                    } else {
//                        JPLog(@"绑定失败!");
//                        notiSwitch.on = NO;
//                        [userDefault setBool:NO forKey:@"noti_value"];
//                        [SVProgressHUD showInfoWithStatus:@"打开消息通知失败，请检查网络"];
//                    }
//                } seq:0];
                
                NSString *UUID = [[IBUUIDManager getUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                UUID = [UUID substringToIndex:10];
                [JPUSHService setAlias:UUID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    if (iResCode == 0) {
                        JPLog(@"绑定成功！");
                        notiSwitch.on = YES;
                        [userDefault setBool:YES forKey:@"noti_value"];
                    } else {
                        JPLog(@"绑定失败!");
                        notiSwitch.on = NO;
                        [userDefault setBool:NO forKey:@"noti_value"];
                        [SVProgressHUD showInfoWithStatus:@"打开消息通知失败，请检查网络"];
                    }
                } seq:0];
            } else {
                JPLog(@"通知关闭了");
                
                //  解绑推送alias
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    if (iResCode == 0) {
                        JPLog(@"解绑成功！");
                        voiceSwitch.on = NO;
                        [userDefault setBool:NO forKey:@"voice_value"];
                        notiSwitch.on = NO;
                        [userDefault setBool:NO forKey:@"noti_value"];
                    } else {
                        JPLog(@"解绑失败！");
                        notiSwitch.on = YES;
                        [userDefault setBool:YES forKey:@"noti_value"];
                        [SVProgressHUD showInfoWithStatus:@"关闭消息通知失败，请检查网络"];
                    }
                } seq:0];
            }
        } else if (tag == 11) {
            [MobClick event:@"setting_getVoice"];
            if (isOn) {
                JPLog(@"语音播报开启了");
                if (notiSwitch.on == NO) {
                    //  绑定友盟推送alias
//                    [JPUSHService setAlias:[JP_UserDefults objectForKey:@"merchantNo"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                        if (iResCode == 0) {
//                            JPLog(@"绑定成功！");
//                            notiSwitch.on = YES;
//                            [userDefault setBool:YES forKey:@"noti_value"];
//                            voiceSwitch.on = YES;
//                            [userDefault setBool:YES forKey:@"voice_value"];
//                        } else {
//                            JPLog(@"绑定失败！");
//                            voiceSwitch.on = NO;
//                            [userDefault setBool:NO forKey:@"voice_value"];
//                            [SVProgressHUD showInfoWithStatus:@"打开消息通知失败，请检查网络"];
//                        }
//                    } seq:0];
                    
                    NSString *UUID = [[IBUUIDManager getUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                    UUID = [UUID substringToIndex:10];
                    [JPUSHService setAlias:UUID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        if (iResCode == 0) {
                            JPLog(@"绑定成功！");
                            notiSwitch.on = YES;
                            [userDefault setBool:YES forKey:@"noti_value"];
                            voiceSwitch.on = YES;
                            [userDefault setBool:YES forKey:@"voice_value"];
                        } else {
                            JPLog(@"绑定失败！");
                            voiceSwitch.on = NO;
                            [userDefault setBool:NO forKey:@"voice_value"];
                            [SVProgressHUD showInfoWithStatus:@"打开消息通知失败，请检查网络"];
                        }
                    } seq:0];
                    
                } else {
                    voiceSwitch.on = YES;
                    [userDefault setBool:YES forKey:@"voice_value"];
                }
            } else {
                JPLog(@"语音播报关闭了");
                voiceSwitch.on = NO;
                [userDefault setBool:NO forKey:@"voice_value"];
            }
        }
        [userDefault synchronize];
    };
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(28) : 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(48) : JPRealValue(80);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = JP_viewBackgroundColor;
    
    YYLabel *noticeLab = [YYLabel new];
    noticeLab.textColor = JP_NoticeText_Color;
    noticeLab.font = [UIFont systemFontOfSize:JPRealValue(22)];
    
    if (section == 0) {
        noticeLab.text = JPPushSwitch;
    } else {
        //        noticeLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
        noticeLab.text = JPPushVoice;
        noticeLab.numberOfLines = 2;
        noticeLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    [footerView addSubview:noticeLab];
    
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(JPRealValue(100));
        make.top.equalTo(footerView.mas_top);
        make.right.equalTo(footerView.mas_right).offset(JPRealValue(-40));
        make.bottom.equalTo(footerView.mas_bottom);
    }];
    
    return footerView;
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
