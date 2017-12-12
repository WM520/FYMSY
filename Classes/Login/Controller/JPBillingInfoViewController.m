//
//  JPBillingInfoViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/23.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPBillingInfoViewController.h"
#import "JPRegisterProgressHeaderView.h"
#import "JPCertificateInfoViewController.h"

@interface JPBillingInfoViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, assign) BOOL        isPublic;
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) UIView *navImageView;

@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *banks;
@property (nonatomic, strong) NSMutableArray *branches;

@property (nonatomic, copy) NSString *accountCityCode;
@property (nonatomic, copy) NSString *alliedBankCode;
@property (nonatomic, copy) NSString *accountBankBranchName;

@property (nonatomic, assign) BOOL isSelect;
@end

@implementation JPBillingInfoViewController
/** 结算信息Header视图*/
static NSString *const businessInfoStepsReuseIdentifier = @"businessInfoSteps";

#pragma mark - request
- (void)createRequest {
    dispatch_group_t group = dispatch_group_create();
    [SVProgressHUD showWithStatus:@"加载中，请稍后..."];
    weakSelf_declare;
    // !!!: 开户省市
    dispatch_group_enter(group);
    
    [JPNetTools1_0_2 getOpenAccountCityWithParent:@"1" level:@"1" callback:^(NSString *code, NSString *msg, id resp) {
//        JPLog(@"开户省 %@ - %@ - %@", code, msg, resp);
        if ([code isEqualToString:@"00"]) {
            if ([resp isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)resp;
                for (NSDictionary *dic in arr) {
                    JPCityModel *model = [JPCityModel yy_modelWithDictionary:dic];
                    [weakSelf.provinces addObject:model];
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus: msg];
        }
        dispatch_group_leave(group);
    }];
    
    // !!!: 银行名称
    dispatch_group_enter(group);
    
    [JPNetTools1_0_2 getBankNameWithProvince:@"" city:@"" bankName:@"" callback:^(NSString *code, NSString *msg, id resp) {
//        JPLog(@"银行名称 %@ - %@ - %@", code, msg, resp);
        if ([code isEqualToString:@"00"]) {
            //  成功
            if ([resp isKindOfClass:[NSArray class]]) {
                NSArray *bankList = (NSArray *)resp;
                for (NSDictionary *dic in bankList) {
                    JPBankModel *model = [JPBankModel yy_modelWithDictionary:dic];
                    [weakSelf.banks addObject:model];
                }
            }
        } else {
            [SVProgressHUD showInfoWithStatus: msg];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //  请求完毕后的处理
        [weakSelf.ctntView reloadData];
        [SVProgressHUD dismiss];
    });
}

#pragma mark - lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        
        [_ctntView registerClass:[JPRegisterProgressHeaderView class] forHeaderFooterViewReuseIdentifier:businessInfoStepsReuseIdentifier];
    }
    return _ctntView;
}

- (NSMutableArray *)provinces {
    if (!_provinces) {
        _provinces = @[].mutableCopy;
    }
    return _provinces;
}
- (NSMutableArray *)cities {
    
    if (!_cities) {
        _cities = @[].mutableCopy;
    }
    return _cities;
}
- (NSMutableArray *)banks {
    
    if (!_banks) {
        _banks = @[].mutableCopy;
    }
    return _banks;
}
- (NSMutableArray *)branches {
    
    if (!_branches) {
        _branches = @[].mutableCopy;
    }
    return _branches;
}

- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    //    _navImageView.alpha = 0;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"结算信息";
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [_navImageView addSubview:titleLab];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
    [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:leftButton];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *data = [JPUserInfoHelper dataSource];
    NSArray *keys = data.allKeys;
    if ([keys containsObject:@"isPublic"]) {
        if ([[JPUserInfoHelper objectForKey:@"isPublic"] boolValue] == self.isEnterprise) {
            self.isPublic = [[JPUserInfoHelper objectForKey:@"isPublic"] boolValue];
        } else {
            self.isPublic = self.isEnterprise;
        }
    } else {
        self.isPublic = self.isEnterprise;
    }
    
    self.provinces = [JPUserInfoHelper objectForKey:@"provinces"];
    self.banks = [JPUserInfoHelper objectForKey:@"banks"];
    
    [self.view addSubview:self.ctntView];
    [self createRequest];
    [self layoutHomeView];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            // !!!: 账户类型
            JPCateSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell00"];
            if (!cell) {
                cell = [[JPCateSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell00"];
            }
            cell.title = @"账户类型";
            [cell setLeftTitle:@"对公" rightTitle:@"对私"];
            JPSelectButton *leftButton = [cell.contentView viewWithTag:666];
            JPSelectButton *rightButton = [cell.contentView viewWithTag:888];
            leftButton.selected = self.isPublic;
            rightButton.selected = !self.isPublic;
            weakSelf_declare;
            @weakify(leftButton)
            @weakify(rightButton)
            cell.jp_cateSelectBlock = ^(NSInteger tag) {
                
                [weakSelf.view endEditing:YES];
                
                @strongify(leftButton)
                @strongify(rightButton)
                leftButton.selected = tag == 666;
                rightButton.selected = tag == 888;
                
                weakSelf.isPublic = tag == 666;
                
                JPInputCell *accountUserNameCellC = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
                accountUserNameCellC.inputField.text = self.isPublic ? self.merchantName : [JPUserInfoHelper objectForKey:@"accountUserName"];
            };
            return cell;
            
        } else if (indexPath.row == 1) {
            
            // !!!: 开户地（省）
            JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell01"];
            if (!cell) {
                cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell01"];
                
                NSString *openProvince = [JPUserInfoHelper objectForKey:@"province"];
                if (!openProvince) {
                    openProvince = @"--请选择省/直辖市/自治区--";
                }
                cell.textLab.text = openProvince;
            }
            cell.title = @"开户地";
            return cell;
            
        } else {
            
            // !!!: 开户地（市）
            JPOnlyOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell02"];
            if (!cell) {
                cell = [[JPOnlyOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell02"];
                
                NSString *openCity = [JPUserInfoHelper objectForKey:@"city"];
                if (!openCity) {
                    openCity = @"--请选择开户城市（市）--";
                }
                cell.textLab.text = openCity;
            }
            return cell;
            
        }
    } else {
        if (indexPath.row == 0) {
            
            // !!!: 银行名称
            JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell20"];
            if (!cell) {
                cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell20"];
                
                NSString *bank = [JPUserInfoHelper objectForKey:@"bankName"];
                if (!bank) {
                    bank = @"--请选择开户行--";
                }
                cell.textLab.text = bank;
            }
            cell.title = @"银行名称";
            return cell;
            
        } else if (indexPath.row == 1) {
            
            // !!!: 支行名称
            JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell21"];
            if (!cell) {
                cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell21"];
                NSString *branch = [JPUserInfoHelper objectForKey:@"branchBankName"];
                if (!branch) {
                    branch = @"支行名称";
                }
                cell.textLab.text = branch;
            }
            cell.title = @"请选择支行名称";
            return cell;
            
        } else if (indexPath.row == 2) {
            
            // !!!: 开户银行账号
            JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell22"];
            if (!cell) {
                cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell22"];
            }
            cell.title = @"开户银行账号";
            cell.inputField.placeholder = @"请输入开户银行账号";
            cell.inputField.text = [JPUserInfoHelper objectForKey:@"account"];
            cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputField.tag = 444444;
            cell.inputField.delegate = self;
            return cell;
            
        } else if (indexPath.row == 3) {
            
            // !!!: 开户账号名称
            JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell23"];
            if (!cell) {
                cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell23"];
            }
            cell.title = @"开户账号名称";
            cell.inputField.placeholder = @"请输入开户账号姓名";
            cell.inputField.text = self.isPublic ? self.merchantName : [JPUserInfoHelper objectForKey:@"accountUserName"];
            return cell;
            
        } else {
            
            // !!!: 预留手机号
            JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell24"];
            if (!cell) {
                cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell24"];
            }
            cell.title = @"预留手机号";
            cell.inputField.placeholder = @"请输入预留手机号";
            cell.inputField.text = [JPUserInfoHelper objectForKey:@"phone"];
            cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputField.tag = 333333;
            cell.inputField.delegate = self;
            return cell;
            
        }
    }
}

#pragma mark - tableViewDelegate
- (void)repeatDelay {
    self.isSelect = false;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //防止重复点击
    if (self.isSelect == false) {
        
        self.isSelect = true;
        
        //在延时方法中将isSelect更改为false
        [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:0.5f];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                
                [self.view endEditing:YES];
                //  开户省
                JPOneSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                if (self.provinces.count > 0) {
                    
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    
                    NSMutableArray *data = @[].mutableCopy;
                    for (JPCityModel *model in self.provinces) {
                        [data addObject:model.name];
                    }
                    weakSelf_declare;
                    __block JPOnlyOneSelectCell *cityCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    // !!!: 支行名称
                    __block JPOneSelectCell *branchBankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    if (data.count > 0) {
                        
                        cell.isEditing = YES;
                        
                        [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                            NSInteger index = [[selectArray lastObject] integerValue];
                            NSString *selectStr = [data objectAtIndex:index];
                            //            JPLog(@"arr -- %@", selectStr);
                            cell.textLab.text = selectStr;
                            cell.textLab.textColor = JP_Content_Color;
                            cell.isEditing = NO;
                            
                            if (![cityCell.textLab.text isEqualToString:@"--请选择开户城市（市）--"]) {
                                cityCell.textLab.text = @"--请选择开户城市（市）--";
                                cityCell.textLab.textColor = JP_NoticeText_Color;
                                
                                [weakSelf.cities removeAllObjects];
                            }
                            if (![branchBankNameCell.textLab.text isEqualToString:@"支行名称"]) {
                                branchBankNameCell.textLab.text = @"支行名称";
                                branchBankNameCell.textLab.textColor = JP_NoticeText_Color;
                                
                                [weakSelf.branches removeAllObjects];
                            }
                            
                            //                        JPCityModel *model = weakSelf.provinces[index];
                            //                        [JPNetTools1_0_2 getOpenAccountCityWithParent:model.code level:@"2" callback:^(NSString *code, NSString *msg, id resp) {
                            //                            if ([code isEqualToString:@"00"]) {
                            //                                if ([resp isKindOfClass:[NSArray class]]) {
                            //                                    NSArray *arr = (NSArray *)resp;
                            //                                    [weakSelf.cities removeAllObjects];
                            //
                            //                                    for (NSDictionary *dic in arr) {
                            //                                        JPCityModel *cityModel = [JPCityModel yy_modelWithDictionary:dic];
                            //                                        [weakSelf.cities addObject:cityModel];
                            //                                    }
                            //                                }
                            //                            } else {
                            //                                [SVProgressHUD showInfoWithStatus: msg];
                            //                            }
                            //                        }];
                        }];
                    }
                } else {
                    [SVProgressHUD showInfoWithStatus:JPServerNoFinish];
                }
            } else if (indexPath.row == 2) {
                [self.view endEditing:YES];
                
                // !!!: 开户地（市）
                //            JPOnlyOneSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                JPOneSelectCell *provinceCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                //            NSLog(@"%@", provinceCell.textLab.text);
                
                if (![provinceCell.textLab.text isEqualToString:@"--请选择省/直辖市/自治区--"]) {
                    
                    NSString *provinceCode = nil;
                    for (JPCityModel *model in self.provinces) {
                        if ([provinceCell.textLab.text isEqualToString:model.name]) {
                            provinceCode = model.code;
                        }
                    }
                    weakSelf_declare;
                    [JPNetTools1_0_2 getOpenAccountCityWithParent:provinceCode level:@"2" callback:^(NSString *code, NSString *msg, id resp) {
                        if ([code isEqualToString:@"00"]) {
                            if ([resp isKindOfClass:[NSArray class]]) {
                                NSArray *arr = (NSArray *)resp;
                                [weakSelf.cities removeAllObjects];
                                
                                for (NSDictionary *dic in arr) {
                                    JPCityModel *cityModel = [JPCityModel yy_modelWithDictionary:dic];
                                    [weakSelf.cities addObject:cityModel];
                                }
                                [JPUserInfoHelper addObject:self.cities forKey:@"cities"];
                                
                                if (weakSelf.cities.count <= 0) {
                                    [SVProgressHUD showInfoWithStatus:@"暂无开户地区信息，请联系客户经理或者更换银行卡！"];
                                    return;
                                }
                                
                                JPOnlyOneSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                
                                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                
                                NSMutableArray *data = @[].mutableCopy;
                                for (JPCityModel *model in self.cities) {
                                    [data addObject:model.name];
                                }
                                
                                // !!!: 支行名称
                                __block JPOneSelectCell *branchBankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                                if (data.count > 0) {
                                    
                                    cell.isEditing = YES;
                                    
                                    [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                                        NSInteger index = [[selectArray lastObject] integerValue];
                                        NSString *selectStr = [data objectAtIndex:index];
                                        cell.textLab.text = selectStr;
                                        cell.textLab.textColor = JP_Content_Color;
                                        cell.isEditing = NO;
                                        
                                        for (JPCityModel *model in weakSelf.cities) {
                                            if ([model.name isEqualToString:selectStr]) {
                                                weakSelf.accountCityCode = model.code;
                                                [JPUserInfoHelper addObject:weakSelf.accountCityCode forKey:@"accountCityCode"];
                                            }
                                        }
                                        
                                        if (![branchBankNameCell.textLab.text isEqualToString:@"支行名称"]) {
                                            branchBankNameCell.textLab.text = @"支行名称";
                                            branchBankNameCell.textLab.textColor = JP_NoticeText_Color;
                                            
                                            [weakSelf.branches removeAllObjects];
                                        }
                                    }];
                                }
                                
                            }
                        } else {
                            [SVProgressHUD showInfoWithStatus:msg];
                        }
                    }];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"请先选择省/直辖市/自治区！"];
                }
            }
        } else {
            if (indexPath.row == 0) {
                //  银行名称选择
                [self.view endEditing:YES];
                
                JPOneSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (self.banks.count > 0) {
                    cell.isEditing = YES;
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    NSMutableArray *data = @[].mutableCopy;
                    for (JPBankModel *model in self.banks) {
                        [data addObject:model.bankName];
                    }
                    
                    // !!!: 支行名称
                    weakSelf_declare;
                    __block JPOneSelectCell *branchBankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    if (data.count > 0) {
                        
                        [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                            NSInteger index = [[selectArray lastObject] integerValue];
                            NSString *selectStr = [data objectAtIndex:index];
                            cell.textLab.text = selectStr;
                            cell.textLab.textColor = JP_Content_Color;
                            cell.isEditing = NO;
                            
                            if (![branchBankNameCell.textLab.text isEqualToString:@"支行名称"]) {
                                branchBankNameCell.textLab.text = @"支行名称";
                                branchBankNameCell.textLab.textColor = JP_NoticeText_Color;
                                
                                [weakSelf.branches removeAllObjects];
                            }
                        }];
                    }
                }
            } else if (indexPath.row == 1) {
                //  支行名称选择 需要根据开户地省市以及银行名称来动态选择
                // !!!: 开户地（省）
                JPOneSelectCell *provinceCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                // !!!: 开户地（市）
                JPOnlyOneSelectCell *cityCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                // !!!: 银行名称
                JPOneSelectCell *bankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                // !!!: 支行名称
                JPOneSelectCell *cell= [self.ctntView cellForRowAtIndexPath:indexPath];
                
                
                if ([provinceCell.textLab.text isEqualToString:@"--请选择省/直辖市/自治区--"] || self.provinces.count <= 0) {
                    [SVProgressHUD showInfoWithStatus:@"请选择省/直辖市/自治区！"];
                    return;
                }
                if ([cityCell.textLab.text isEqualToString:@"--请选择开户城市（市）--"] || self.cities.count <= 0) {
                    [SVProgressHUD showInfoWithStatus:@"请选择开户城市（市）！"];
                    return;
                }
                if ([bankNameCell.textLab.text isEqualToString:@"--请选择开户行--"] || self.banks.count <= 0) {
                    [SVProgressHUD showInfoWithStatus:@"请选择开户行！"];
                    return;
                }
                
                NSString *provinceCode = nil;
                for (JPCityModel *model in self.provinces) {
                    if ([model.name isEqualToString:provinceCell.textLab.text]) {
                        provinceCode = model.code;
                    }
                }
                
                NSString *cityCode = nil;
                for (JPCityModel *model in self.cities) {
                    if ([model.name isEqualToString:cityCell.textLab.text]) {
                        cityCode = model.code;
                    }
                }
                
                weakSelf_declare;
                [JPNetTools1_0_2 getBankNameWithProvince:provinceCode city:cityCode bankName:bankNameCell.textLab.text callback:^(NSString *code, NSString *msg, id resp) {
                    //                JPLog(@"支行名称 %@ - %@ - %@", code, msg, resp);
                    if ([code isEqualToString:@"00"]) {
                        //  成功
                        if ([resp isKindOfClass:[NSArray class]]) {
                            NSArray *bankList = (NSArray *)resp;
                            
                            if (bankList.count <= 0) {
                                [SVProgressHUD showInfoWithStatus:JPBranchBank];
                                return;
                            }
                            [weakSelf.branches removeAllObjects];
                            for (NSDictionary *dic in bankList) {
                                JPBankModel *model = [JPBankModel yy_modelWithDictionary:dic];
                                [weakSelf.branches addObject:model];
                            }
                            
                            NSMutableArray *data = @[].mutableCopy;
                            for (JPBankModel *model in self.branches) {
                                [data addObject:model.bankName];
                            }
                            if (data.count > 0) {
                                cell.isEditing = YES;
                                [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                                    NSInteger index = [[selectArray lastObject] integerValue];
                                    NSString *selectStr = [data objectAtIndex:index];
                                    cell.textLab.text = selectStr;
                                    cell.textLab.textColor = JP_Content_Color;
                                    cell.isEditing = NO;
                                    
                                    for (JPBankModel *model in weakSelf.branches) {
                                        if ([model.bankName isEqualToString:selectStr]) {
                                            weakSelf.alliedBankCode = model.bankCode;
                                            weakSelf.accountBankBranchName = model.bankName;
                                            
                                            [JPUserInfoHelper addObject:weakSelf.alliedBankCode forKey:@"alliedBankCode"];
                                            [JPUserInfoHelper addObject:weakSelf.accountBankBranchName forKey:@"accountBankBranchName"];
                                        }
                                    }
                                }];
                            }
                        }
                    } else {
                        [SVProgressHUD showInfoWithStatus: msg];
                    }
                }];
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPRegisterProgressHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:businessInfoStepsReuseIdentifier];
    headerView.steps = JPStepsBillingInfo;
    return section == 0 ? headerView : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(JPRealValue(64), JPRealValue(40), kScreenWidth - JPRealValue(128), JPRealValue(90));
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font = JP_DefaultsFont;
    nextButton.backgroundColor = JPBaseColor;
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(handleNextEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(JPRealValue(64), JPRealValue(170), kScreenWidth - JPRealValue(128), JPRealValue(90));
    [previousButton setTitle:@"返回上一步" forState:UIControlStateNormal];
    [previousButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
    previousButton.titleLabel.font = JP_DefaultsFont;
    [previousButton addTarget:self action:@selector(handlePreviousEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:previousButton];
    
    return section == 1 ? footerView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JPRealValue(100);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(340) : JPRealValue(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? JPRealValue(300) : 0.01;
}

#pragma mark - action
- (void)handleNextEvent:(UIButton *)sender {
    
    //  监控网络状态变化
    weakSelf_declare;
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2:
            {
                [weakSelf varifyAndNext];
            }
                break;
            default:
            {
                [SVProgressHUD showInfoWithStatus:JPServerNoNet];
            }
                break;
        }
    }];
}

- (void)handlePreviousEvent:(UIButton *)sender {
    
    [JPUserInfoHelper addObject:@(self.isPublic) forKey:@"isPublic"];
    
    // !!!: 开户地（省）
    JPOneSelectCell *provinceCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (![provinceCell.textLab.text isEqualToString:@"--请选择省/直辖市/自治区--"]) {
        [JPUserInfoHelper addObject:provinceCell.textLab.text forKey:@"province"];
    }
    
    // !!!: 开户地（市）
    JPOnlyOneSelectCell *cityCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (![cityCell.textLab.text isEqualToString:@"--请选择开户城市（市）--"]) {
        [JPUserInfoHelper addObject:cityCell.textLab.text forKey:@"city"];
    }
    
    // !!!: 银行名称
    JPOneSelectCell *bankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (![bankNameCell.textLab.text isEqualToString:@"--请选择开户行--"]) {
        [JPUserInfoHelper addObject:bankNameCell.textLab.text forKey:@"bankName"];
    }
    
    // !!!: 支行名称
    JPOneSelectCell *branchBankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (![branchBankNameCell.textLab.text isEqualToString:@"请选择支行名称"]) {
        [JPUserInfoHelper addObject:branchBankNameCell.textLab.text forKey:@"branchBankName"];
    }
    
    // !!!: 开户银行账号
    JPInputCell *accountCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    if (accountCell.inputField.text.length > 0) {
        [JPUserInfoHelper addObject:accountCell.inputField.text forKey:@"account"];
    }
    
    // !!!: 开户账号名称
    JPInputCell *accountUserNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    if (accountUserNameCell.inputField.text.length > 0) {
        [JPUserInfoHelper addObject:accountUserNameCell.inputField.text forKey:@"accountUserName"];
    }
    // !!!: 预留手机号
    JPInputCell *phoneCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    if (phoneCell.inputField.text.length > 0) {
        [JPUserInfoHelper addObject:phoneCell.inputField.text forKey:@"phone"];
    }
    
    [JPUserInfoHelper addObject:self.provinces forKey:@"provinces"];
    
    [JPUserInfoHelper addObject:self.banks forKey:@"banks"];
    
    
    //  上一步
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)varifyAndNext {
    //  下一步
    // !!!: 开户地（省）
    JPOneSelectCell *provinceCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    // !!!: 开户地（市）
    JPOnlyOneSelectCell *cityCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    // !!!: 银行名称
    JPOneSelectCell *bankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    // !!!: 支行名称
    JPOneSelectCell *branchBankNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    // !!!: 开户银行账号
    JPInputCell *accountCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    // !!!: 开户账号名称
    JPInputCell *accountUserNameCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    // !!!: 预留手机号
    JPInputCell *phoneCell = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    
    // TODO: 判空验证
    if ([provinceCell.textLab.text isEqualToString:@"--请选择省/直辖市/自治区--"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择开户省！"];
        return;
    }
    if ([cityCell.textLab.text isEqualToString:@"--请选择开户城市（市）--"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择开户市！"];
        return;
    }
    if ([bankNameCell.textLab.text isEqualToString:@"--请选择开户行--"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择开户行名称！"];
        return;
    }
    if ([branchBankNameCell.textLab.text isEqualToString:@"请选择支行名称"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择支行名称！"];
        return;
    }
    if (accountCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入开户银行账号！"];
        return;
    }
    if (accountUserNameCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入开户银行名称！"];
        return;
    }
    if (accountUserNameCell.inputField.text.length > 32) {
        [SVProgressHUD showInfoWithStatus:@"开户账号名称不超过32个汉字！"];
        return;
    }
    if (![accountUserNameCell.inputField.text isChinese]) {
        [SVProgressHUD showInfoWithStatus:@"开户账号名称不超过32个汉字！"];
        return;
    }
    if (self.isPublic) {
        if (![accountUserNameCell.inputField.text isEqualToString:self.merchantName]) {
            [SVProgressHUD showInfoWithStatus:@"开户账号名称和商户名称须一致！"];
            return;
        }
    }
    if (phoneCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入预留手机号！"];
        return;
    }
    
    //  格式化后有空格 转成正常的字符串
    NSString *account = [UITextField numberToNormalNumTextField:accountCell.inputField];
    NSString *phoneNumber = [UITextField numberToNormalNumTextField:phoneCell.inputField];
    
    if (![phoneNumber isPhone]) {
        [SVProgressHUD showInfoWithStatus:@"手机号输入有误！"];
        return;
    }
    
    [MobClick event:@"billingInfoNext"];
    
    JPCertificateInfoViewController *certificateInfoVC = [JPCertificateInfoViewController new];
    certificateInfoVC.qrcodeid = self.qrcodeid;
    certificateInfoVC.isEnterprise = self.isEnterprise;
    certificateInfoVC.hasLicence = self.hasLicence;
    certificateInfoVC.merchantName = self.merchantName;
    certificateInfoVC.merchantShortName = self.merchantShortName;
    certificateInfoVC.legalName = self.legalName;
    certificateInfoVC.userName = self.userName;
    certificateInfoVC.IDCardNumber = self.IDCardNumber;
    certificateInfoVC.registerProvince = self.registerProvince;
    certificateInfoVC.registerCity = self.registerCity;
    certificateInfoVC.registerCounty = self.registerCounty;
    certificateInfoVC.detailAddress = self.detailAddress;
    certificateInfoVC.mainIndustry = self.mainIndustry;
    certificateInfoVC.secondaryIndustry = self.secondaryIndustry;
    certificateInfoVC.mcc = self.mcc;
    certificateInfoVC.remark = self.remark;
    
    certificateInfoVC.isPublic = self.isPublic;
    for (JPCityModel *model in self.provinces) {
        if ([model.name isEqualToString:provinceCell.textLab.text]) {
            certificateInfoVC.accountProvinceName = model.code;
        }
    }
    //    certificateInfoVC.accountProvinceName = provinceCell.textLab.text;
    
    NSString *accountCityCode = self.accountCityCode;
    if (accountCityCode.length <= 0) {
        accountCityCode = [JPUserInfoHelper objectForKey:@"accountCityCode"];
    }
    certificateInfoVC.accountCityName = [JPUserInfoHelper objectForKey:@"accountCityCode"];
    
    
    //    certificateInfoVC.accountCityName = cityCell.textLab.text;
    //    for (JPBankModel *model in self.banks) {
    //        if ([model.bankName isEqualToString:bankNameCell.textLab.text]) {
    //            certificateInfoVC.bankName = model.bankCode;
    //        }
    //    }
    certificateInfoVC.bankName = bankNameCell.textLab.text;
    
    NSString *alliedBankCode = self.alliedBankCode;
    NSString *accountBankBranchName = self.accountBankBranchName;
    if (alliedBankCode.length <= 0) {
        alliedBankCode = [JPUserInfoHelper objectForKey:@"alliedBankCode"];
    }
    certificateInfoVC.alliedBankCode = alliedBankCode;
    if (accountBankBranchName.length <= 0) {
        accountBankBranchName = [JPUserInfoHelper objectForKey:@"accountBankBranchName"];
    }
    certificateInfoVC.accountBankBranchName = accountBankBranchName;
    
    //    certificateInfoVC.accountBankBranchName = branchBankNameCell.textLab.text;
    certificateInfoVC.account = account;
    certificateInfoVC.accountUserName = accountUserNameCell.inputField.text;
    certificateInfoVC.contactMobilePhone = phoneNumber;
    
    [self.navigationController pushViewController:certificateInfoVC animated:YES];
    //    [self button:sender userInteractionEnabled:YES];
    
    JPLog(@"%d - %d - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %d - %@ - %@ - %@ - %@ - %@ - %@ - %@", self.isEnterprise, self.hasLicence, self.merchantName, self.merchantShortName, self.legalName, self.userName, self.IDCardNumber, self.registerProvince, self.registerCity, self.registerCounty, self.detailAddress, self.mainIndustry, self.secondaryIndustry, self.mcc, certificateInfoVC.isPublic, certificateInfoVC.accountProvinceName, certificateInfoVC.accountCityName, certificateInfoVC.bankName, certificateInfoVC.accountBankBranchName, certificateInfoVC.account, certificateInfoVC.accountUserName, certificateInfoVC.contactMobilePhone);
}

//  返回
- (void)backButtonClicked:(UIButton *)sender {
    [self handlePreviousEvent:nil];
}

#pragma mark - 导航栏渐变效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat borderLine = 64;
    if (scrollView.contentOffset.y < borderLine && scrollView.contentOffset.y > 0) {
        _navImageView.alpha = scrollView.contentOffset.y / borderLine;
    } else if (scrollView.contentOffset.y >= borderLine) {
        _navImageView.alpha = 0;
    } else if (scrollView.contentOffset.y <= 0) {
        _navImageView.alpha = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    UITextField *phoneField = [self.view viewWithTag:333333];
    UITextField *accountField = [self.view viewWithTag:444444];
    // !!!: 手机号码格式化
    if (phoneField == textField) {
        return [UITextField phoneNumberFormatTextField:phoneField shouldChangeCharactersInRange:range replacementString:string];
    }
    // !!!: 银行卡账号格式化
    if (accountField == textField) {
        return [UITextField bankNumberFormatTextField:accountField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

#pragma mark - textFieldNotification

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
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
