//
//  JPMerchantsSHViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPMerchantsSHViewController.h"
#import "JPPhotoView.h"
#import "JPTransferMJ.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JPMenuView.h"
#import "JPCredentialsHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JPMerchantsSHViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) JPMenuView *menuView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *baseCtntView;
@property (nonatomic, strong) UITableView *billingCtntView;
@property (nonatomic, strong) UICollectionView *credentialsColView;
@property (nonatomic, strong) JPSelfHelpModel *credentModel;
@property (nonatomic, strong) JPDocumentsModel *docModel;

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL imageHasChange;

/** 是否是企业类*/
@property (nonatomic, assign) BOOL        isEnterprise;
/** 是否有营业执照*/
@property (nonatomic, assign) BOOL        hasLicence;

/** 是否是对公账号*/
@property (nonatomic, assign) BOOL        isPublic;
@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *banks;
@property (nonatomic, strong) NSMutableArray *branches;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) JPPhotoView      *photoView;
@property (nonatomic, strong) NSIndexPath      *selectIndexPath;
@end

@implementation JPMerchantsSHViewController
static NSString *const collectCellReuseIdentifier = @"collectCellReuseIdentifier";

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFCredentialsNotification object:nil];
}

#pragma mark - request
//  证件资料列表信息获取
- (void)createRequestWithType:(NSString *)type {
    [SVProgressHUD showWithStatus:@"信息同步中，请稍后！"];
    weakSelf_declare;
    [JPNetTools1_0_2 getInfoListWithType:type callback:^(NSString *code, NSString *msg, id resp) {
        NSLog(@"证件资料列表信息获取 %@ - %@ - %@", code, msg, resp);
        if ([code isEqualToString:@"00"]) {
            //  成功
            if ([resp isKindOfClass:[NSDictionary class]]) {
                [SVProgressHUD dismiss];
                
                weakSelf.docModel = [JPDocumentsModel yy_modelWithJSON:resp];
                [weakSelf.dataSource removeAllObjects];
                for (JPCertificateData *certificateData in weakSelf.docModel.data) {
                    for (JPImageModel *imgModel in certificateData.imgList) {
                        [weakSelf.dataSource addObject:imgModel];
                    }
                }
            }
        } else {
            //  失败
            [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
        }
        [weakSelf.credentialsColView reloadData];
    }];
}

- (void)createRequest {
    dispatch_group_t group = dispatch_group_create();
    
    [SVProgressHUD showWithStatus:@"信息同步中，请稍后..."];
    [self canDoSthInView:NO];
    weakSelf_declare;
    // !!!: 商户自助商户信息
    dispatch_group_enter(group);
    
    [JPNetTools1_0_2 getBusinessSelfHelpBusinessInfoWithUserName:[JPUserEntity sharedUserEntity].jp_user callback:^(NSString *code, NSString *msg, id resp) {
        JPLog(@"商户自助商户信息获取 - %@ - %@ - %@", code, msg, resp);
        if ([code isEqualToString:@"00"]) {
            weakSelf.credentModel = [JPSelfHelpModel yy_modelWithJSON:resp];
            weakSelf.isEnterprise = weakSelf.credentModel.data.merchantCategory == 1;
            if (weakSelf.credentModel.data.merchantCategory == 2) {
                weakSelf.hasLicence = weakSelf.credentModel.data.certificateImgType == 1;
            }
            weakSelf.isPublic = weakSelf.credentModel.data.accountType == 1;
        } else {
            [SVProgressHUD showInfoWithStatus:msg];
            [weakSelf canDoSthInView:YES];
        }
        dispatch_group_leave(group);
    }];
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
            [SVProgressHUD showInfoWithStatus:msg];
            [weakSelf canDoSthInView:YES];
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
            [SVProgressHUD showInfoWithStatus:msg];
            [weakSelf canDoSthInView:YES];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //  请求完毕后的处理
        [weakSelf.baseCtntView reloadData];
        [weakSelf.billingCtntView reloadData];
        [weakSelf.credentialsColView reloadData];
        [weakSelf canDoSthInView:YES];
        [SVProgressHUD dismiss];
    });
}

#pragma mark - View
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFCredentialsNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商户自助";
    
    weakSelf_declare;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCredentialsInfoNotification:) name:kCFCredentialsNotification object:nil];
    
    if (self.applyProgress == JPApplyProgressNotThrough) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
    
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.scrollView];
    
    //  获取数据
    [self createRequest];
    
    self.menuView.jpMenuBlock = ^(NSInteger tag) {
        [UIView animateWithDuration:0.25 animations:^{
            
            //  点击之后选择
            if (![weakSelf.tags containsObject:@(tag)]) {
                [weakSelf.tags addObject:@(tag)];
            }
            weakSelf.scrollView.contentOffset = CGPointMake(kScreenWidth * (tag - 100), 0);
            [[NSNotificationCenter defaultCenter] postNotificationName:kCFCredentialsNotification object:nil];
        }];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.imageHasChange = NO;
}
#pragma mark - lazy
- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = @[@"100"].mutableCopy;
    }
    return _tags;
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
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (JPPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [[JPPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _photoView;
}

- (JPMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[JPMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) dataSource:@[@"基本信息", @"结算信息", @"证件资料"]];
        _menuView.selectedIndex = 0;
    }
    return _menuView;
}

- (UITableView *)baseCtntView {
    if (!_baseCtntView) {
        _baseCtntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 108) style:UITableViewStyleGrouped];
        _baseCtntView.dataSource = self;
        _baseCtntView.delegate = self;
        _baseCtntView.backgroundColor = JP_viewBackgroundColor;
        _baseCtntView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _baseCtntView;
}

- (UITableView *)billingCtntView {
    if (!_billingCtntView) {
        _billingCtntView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 108) style:UITableViewStyleGrouped];
        _billingCtntView.dataSource = self;
        _billingCtntView.delegate = self;
        _billingCtntView.backgroundColor = JP_viewBackgroundColor;
        _billingCtntView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _billingCtntView;
}

- (UICollectionView *)credentialsColView {
    if (!_credentialsColView) {
        float margin = JPRealValue(30);
        //  layout布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = (CGSize){(kScreenWidth - margin * 3) /2.0, JPRealValue(220)};
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = margin;
        flowLayout.sectionInset = (UIEdgeInsets){0, JPRealValue(45), 0, JPRealValue(15)};
        
        //  CollectionView
        _credentialsColView = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 108) collectionViewLayout:flowLayout];
        _credentialsColView.dataSource = self;
        _credentialsColView.delegate = self;
        _credentialsColView.backgroundColor = JP_viewBackgroundColor;
        _credentialsColView.showsVerticalScrollIndicator = NO;
        _credentialsColView.showsHorizontalScrollIndicator = NO;
        [_credentialsColView registerClass:[JPCredentialsCell class] forCellWithReuseIdentifier:collectCellReuseIdentifier];
    }
    return _credentialsColView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 108)];
        //必须要设置内容滚动区域范围(要比scrollView 范围大)
        //内容图片有多大那么滚动区域就设置多大
        _scrollView.contentSize = CGSizeMake(3 * _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        //设置是否可以回弹(上下左右)(默认yes)
        _scrollView.bounces = YES;
        //设置滚动条的风格
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        //打开翻页效果
        _scrollView.pagingEnabled = YES;
        //设置代理
        _scrollView.delegate = self;
        
        [_scrollView addSubview:self.baseCtntView];
        [_scrollView addSubview:self.billingCtntView];
        [_scrollView addSubview:self.credentialsColView];
    }
    return _scrollView;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.baseCtntView) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.baseCtntView) {
        if (section == 0) {
            return 6;
        } else if (section == 1) {
            return 2;
        } else {
            return 3;
        }
    } else {
        return section == 0 ? 3 : 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.baseCtntView) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                // !!!: 商户类别
                JPCateSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell00"];
                if (!cell) {
                    cell = [[JPCateSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell00"];
                }
                
                cell.title = @"商户类别";
                [cell setLeftTitle:@"企业类" rightTitle:@"个体户"];
                JPSelectButton *leftButton = [cell.contentView viewWithTag:666];
                JPSelectButton *rightButton = [cell.contentView viewWithTag:888];
                leftButton.selected = self.isEnterprise;
                rightButton.selected = !self.isEnterprise;
                
                weakSelf_declare;
                @weakify(leftButton)
                @weakify(rightButton)
                cell.jp_cateSelectBlock = ^(NSInteger tag) {
                    
                    if (weakSelf.applyProgress == JPApplyProgressThrough || weakSelf.applyProgress == JPApplyProgressApplying) {
                        [SVProgressHUD showInfoWithStatus:weakSelf.reviewStatus];
                    } else {
                        [weakSelf.view endEditing:YES];
                        
                        @strongify(leftButton)
                        @strongify(rightButton)
                        leftButton.selected = tag == 666;
                        rightButton.selected = tag == 888;
                        weakSelf.isEnterprise = tag == 666;
                        
                        //  点击之后选择
                        NSInteger type = weakSelf.isEnterprise ? 0 : weakSelf.hasLicence ? 1 : 2;
                        [weakSelf createRequestWithType:[NSString stringWithFormat:@"%ld", (long)type]];
                        
                        //  刷新营业执照那一行，若选择企业类，营业执照不显示；若选择个体户，营业执照显示并需要选择
                        [weakSelf.baseCtntView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                };
                return cell;
                
            } else if (indexPath.row == 1) {
                
                // !!!: 营业执照
                JPCateSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell01"];
                if (!cell) {
                    cell = [[JPCateSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell01"];
                }
                if (!self.isEnterprise) {
                    cell.bgView.hidden = NO;
                    
                    cell.title = @"营业执照";
                    [cell setLeftTitle:@"有" rightTitle:@"无"];
                    
                    JPSelectButton *leftButton = [cell.contentView viewWithTag:666];
                    JPSelectButton *rightButton = [cell.contentView viewWithTag:888];
                    leftButton.selected = self.hasLicence;
                    rightButton.selected = !self.hasLicence;
                    
                    weakSelf_declare;
                    @weakify(leftButton)
                    @weakify(rightButton)
                    cell.jp_cateSelectBlock = ^(NSInteger tag) {
                        
                        if (weakSelf.applyProgress == JPApplyProgressThrough || weakSelf.applyProgress == JPApplyProgressApplying) {
                            [SVProgressHUD showInfoWithStatus:weakSelf.reviewStatus];
                        } else {
                            [weakSelf.view endEditing:YES];
                            
                            @strongify(leftButton)
                            @strongify(rightButton)
                            leftButton.selected = tag == 666;
                            rightButton.selected = tag == 888;
                            weakSelf.hasLicence = tag == 666;
                            
                            //  点击之后选择
                            NSInteger type = weakSelf.isEnterprise ? 0 : weakSelf.hasLicence ? 1 : 2;
                            [weakSelf createRequestWithType:[NSString stringWithFormat:@"%ld", (long)type]];
                        }
                    };
                } else {
                    cell.bgView.hidden = YES;
                }
                return cell;
                
            } else if (indexPath.row == 2) {
                
                // !!!: 商户名称
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell02"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell02"];
                }
                cell.title = @"商户名称";
                cell.inputField.placeholder = @"营业执照上的名称";
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.text = self.credentModel.data.merchantName;
                return cell;
                
            } else if (indexPath.row == 3) {
                
                // !!!: 商户简称
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell03"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell03"];
                }
                cell.title = @"商户简称";
                cell.inputField.placeholder = @"6-15个汉字";
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.text = self.credentModel.data.merchantShortName;
                return cell;
                
            } else if (indexPath.row == 4) {
                
                // !!!: 注册地址
                JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell04"];
                if (!cell) {
                    cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell04"];
                    cell.textLab.text = @"选择省/直辖市/自治区";
                }
                cell.title = @"注册地址";
                cell.textLab.text = [NSString stringWithFormat:@"%@%@%@", self.credentModel.data.registerProvinceName, self.credentModel.data.registerCityName, self.credentModel.data.registerDistrictName];
                cell.textLab.textColor = JP_Content_Color;
                return cell;
                
            } else {
                
                // !!!: 详细地址
                JPOnlyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell05"];
                if (!cell) {
                    cell = [[JPOnlyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell06"];
                }
                cell.inputField.text = self.credentModel.data.registerAddress;
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.placeholder = @"详细地址，中英文数字括号横线";
                cell.inputField.tag = 201707050937;
                cell.inputField.delegate = self;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailAddressTextChanged:) name:UITextFieldTextDidChangeNotification object:cell.inputField];
                return cell;
                
            }
        } else if (indexPath.section == 1) {
            
            // !!!: 行业类型
            if (indexPath.row == 0) {
                
                JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell10"];
                if (!cell) {
                    cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell10"];
                    cell.textLab.text = @"选择行业类型";
                }
                cell.title = @"行业类型";
                cell.textLab.text = self.credentModel.data.industryType;
                cell.textLab.textColor = JP_Content_Color;
                return cell;
                
            } else {
                
                JPOnlyOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell11"];
                if (!cell) {
                    cell = [[JPOnlyOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell11"];
                    cell.textLab.text = @"选择行业编号";
                }
                cell.textLab.text = self.credentModel.data.industryNo;
                cell.textLab.textColor = JP_Content_Color;
                return cell;
                
            }
            
        } else {
            
            if (indexPath.row == 0) {
                
                // !!!: 法人姓名
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell20"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell20"];
                }
                cell.title = @"法人姓名";
                cell.inputField.placeholder = @"2-10个汉字";
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.text = self.credentModel.data.legalPersonName;
                return cell;
                
            } else if (indexPath.row == 1) {
                
                // !!!: 用户名
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell21"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell21"];
                }
                cell.title = @"用户名";
                cell.inputField.text = self.credentModel.data.userName;
                cell.inputField.enabled = NO;
                return cell;
                
            } else {
                
                // !!!: 身份证号
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1cell22"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1cell22"];
                }
                cell.title = @"身份证号";
                cell.inputField.placeholder = @"请输入身份证号";
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.text = self.credentModel.data.accountIdcard;
                cell.inputField.tag = 201706221507;
                cell.inputField.delegate = self;
                return cell;
                
            }
        }
    } else if (tableView == self.billingCtntView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                // !!!: 账户类型
                JPCateSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2cell00"];
                if (!cell) {
                    cell = [[JPCateSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2cell00"];
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
                    
                    if (weakSelf.applyProgress == JPApplyProgressThrough || weakSelf.applyProgress == JPApplyProgressApplying) {
                        [SVProgressHUD showInfoWithStatus:weakSelf.reviewStatus];
                    } else {
                        [weakSelf.view endEditing:YES];
                        
                        @strongify(leftButton)
                        @strongify(rightButton)
                        leftButton.selected = tag == 666;
                        rightButton.selected = tag == 888;
                        
                        weakSelf.isPublic = tag == 666;
                    }
                };
                return cell;
                
            } else if (indexPath.row == 1) {
                
                // !!!: 开户地（省）
                JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2cell01"];
                if (!cell) {
                    cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2cell01"];
                    cell.textLab.text = @"--请选择省/直辖市/自治区！--";
                }
                cell.title = @"开户地";
                cell.textLab.text = self.credentModel.data.accountProvinceName;
                cell.textLab.textColor = JP_Content_Color;
                return cell;
                
            } else {
                
                // !!!: 开户地（市）
                JPOnlyOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2cell02"];
                if (!cell) {
                    cell = [[JPOnlyOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2cell02"];
                    cell.textLab.text = @"--请选择开户城市（市）--";
                }
                cell.textLab.text = self.credentModel.data.accountCityName;
                cell.textLab.textColor = JP_Content_Color;
                return cell;
                
            }
        } else {
            if (indexPath.row == 0) {
                
                // !!!: 银行名称
                JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2cell20"];
                if (!cell) {
                    cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2cell20"];
                    cell.textLab.text = @"--请选择开户行--";
                }
                cell.title = @"银行名称";
                cell.textLab.text = self.credentModel.data.accountBankName;
                cell.textLab.textColor = JP_Content_Color;
                return cell;
                
            } else if (indexPath.row == 1) {
                
                // !!!: 支行名称
                JPOneSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell21"];
                if (!cell) {
                    cell = [[JPOneSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell21"];
                    cell.textLab.text = @"请选择支行名称";
                }
                cell.title = @"支行名称";
                cell.textLab.text = self.credentModel.data.accountBankBranchName;
                cell.textLab.textColor = JP_Content_Color;
                return cell;
                
            } else if (indexPath.row == 2) {
                
                // !!!: 开户银行账号
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2cell22"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2cell22"];
                }
                cell.title = @"开户银行账号";
                cell.inputField.placeholder = @"请输入开户银行账号";
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.text = self.credentModel.data.account;
                cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                cell.inputField.tag = 444444;
                cell.inputField.delegate = self;
                return cell;
                
            } else if (indexPath.row == 3) {
                
                // !!!: 开户账号名称
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2cell23"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2cell23"];
                }
                cell.title = @"开户账号名称";
                cell.inputField.placeholder = @"请输入开户账号姓名";
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.text = self.credentModel.data.accountName;
                return cell;
                
            } else {
                
                // !!!: 预留手机号
                JPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2cell24"];
                if (!cell) {
                    cell = [[JPInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2cell24"];
                }
                cell.title = @"预留手机号";
                cell.inputField.placeholder = @"请输入预留手机号";
                cell.inputField.enabled = self.applyProgress == JPApplyProgressNotThrough;
                cell.inputField.text = self.credentModel.data.contactMobilePhone;
                cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                cell.inputField.tag = 333333;
                cell.inputField.delegate = self;
                return cell;
                
            }
        }
    } else {
        return nil;
    }
}

#pragma mark - tableViewDelegate
- (void)repeatDelay {
    self.isSelect = false;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.applyProgress == JPApplyProgressThrough) {
//        [SVProgressHUD showInfoWithStatus:@"审核已通过，无法修改！"];
        [SVProgressHUD showInfoWithStatus:self.reviewStatus];
    } else if (self.applyProgress == JPApplyProgressApplying) {
//        [SVProgressHUD showInfoWithStatus:@"审核中，请耐心等待！"];
        [SVProgressHUD showInfoWithStatus:self.reviewStatus];
    } else {
        //  只有审核未通过才可修改
        if (tableView == self.baseCtntView) {
            if (indexPath.section == 0) {
                if (indexPath.row == 4) {
                    [SVProgressHUD showInfoWithStatus:@"注册地址无法修改！"];
                }
            } else if (indexPath.section == 1) {
                [SVProgressHUD showInfoWithStatus:@"行业类型无法修改！"];
            } else if (indexPath.section == 2) {
                if (indexPath.row == 1) {
                    [SVProgressHUD showInfoWithStatus:@"用户名不可修改！"];
                }
            }
        } else if (tableView == self.billingCtntView) {
            
            //防止重复点击
            if (self.isSelect == false) {
                
                self.isSelect = true;
                
                //在延时方法中将isSelect更改为false
                [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:0.5f];
                
                if (indexPath.section == 0) {
                    if (indexPath.row == 1) {
                        //  选择开户省
                        [self.view endEditing:YES];
                        
                        JPOneSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        if (self.provinces.count > 0) {
                            
                            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                            
                            NSMutableArray *data = @[].mutableCopy;
                            for (JPCityModel *model in self.provinces) {
                                [data addObject:model.name];
                            }
                            __block JPOnlyOneSelectCell *cityCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                            // !!!: 支行名称
                            __block JPOneSelectCell *branchCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                            
                            if (data.count > 0) {
                                cell.isEditing = YES;
                                weakSelf_declare;
                                [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                                    NSInteger index = [[selectArray lastObject] integerValue];
                                    NSString *selectStr = [data objectAtIndex:index];
                                    //            JPLog(@"arr -- %@", selectStr);
                                    cell.textLab.text = selectStr;
                                    cell.textLab.textColor = JP_Content_Color;
                                    cell.isEditing = NO;
                                    
                                    if (![cityCell.textLab.text isEqualToString:@"--请选择开户城市（市）--"]) {
                                        [weakSelf.cities removeAllObjects];
                                        cityCell.textLab.text = @"--请选择开户城市（市）--";
                                        cityCell.textLab.textColor = JP_NoticeText_Color;
                                    }
                                    if (![branchCell.textLab.text isEqualToString:@"请选择支行名称"]) {
                                        [weakSelf.branches removeAllObjects];
                                        
                                        branchCell.textLab.text = @"请选择支行名称";
                                        branchCell.textLab.textColor = JP_NoticeText_Color;
                                    }
                                }];
                            } else {
                                [SVProgressHUD showInfoWithStatus:JPServerNot00];
                            }
                        } else {
                            [SVProgressHUD showInfoWithStatus:JPServerNoFinish];
                        }
                    } else if (indexPath.row == 2) {
                        //  选择开户市
                        
                        [self.view endEditing:YES];
                        
                        // !!!: 开户地（省）
                        JPOneSelectCell *provinceCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        NSString *parent = nil;
                        for (JPCityModel *model in self.provinces) {
                            if ([model.name isEqualToString:provinceCell.textLab.text]) {
                                parent = model.code;
                            }
                        }
                        if (parent == nil) {
                            [SVProgressHUD showInfoWithStatus:@"请选择省/直辖市/自治区！"];
                            return;
                        }
                        weakSelf_declare;
                        [SVProgressHUD showWithStatus:@"信息获取中，请稍后..."];
                        [self canDoSthInView:NO];
                        [JPNetTools1_0_2 getOpenAccountCityWithParent:parent level:@"2" callback:^(NSString *code, NSString *msg, id resp) {
                            if ([code isEqualToString:@"00"]) {
                                [SVProgressHUD dismiss];
                                
                                if ([resp isKindOfClass:[NSArray class]]) {
                                    NSArray *arr = (NSArray *)resp;
                                    [weakSelf.cities removeAllObjects];
                                    
                                    for (NSDictionary *dic in arr) {
                                        JPCityModel *cityModel = [JPCityModel yy_modelWithDictionary:dic];
                                        [weakSelf.cities addObject:cityModel];
                                    }
                                    
                                    JPOnlyOneSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                    cell.isEditing = YES;
                                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                    
                                    NSMutableArray *data = @[].mutableCopy;
                                    for (JPCityModel *model in self.cities) {
                                        [data addObject:model.name];
                                    }
                                    if (data.count > 0) {
                                        
                                        // !!!: 支行名称
                                        __block JPOneSelectCell *branchCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                                        [weakSelf canDoSthInView:YES];
                                        
                                        [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                                            NSInteger index = [[selectArray lastObject] integerValue];
                                            NSString *selectStr = [data objectAtIndex:index];
                                            cell.textLab.text = selectStr;
                                            cell.textLab.textColor = JP_Content_Color;
                                            cell.isEditing = NO;
                                            
                                            if (![branchCell.textLab.text isEqualToString:@"请选择支行名称"]) {
                                                [weakSelf.branches removeAllObjects];
                                                
                                                branchCell.textLab.text = @"请选择支行名称";
                                                branchCell.textLab.textColor = JP_NoticeText_Color;
                                            }
                                        }];
                                    } else {
                                        [SVProgressHUD showInfoWithStatus:JPBranchBank];
                                        [self canDoSthInView:YES];
                                    }
                                }
                            } else {
                                [SVProgressHUD showInfoWithStatus: msg];
                            }
                        }];
                    }
                } else {
                    if (indexPath.row == 0) {
                        //  银行名称选择
                        [self.view endEditing:YES];
                        
                        JPOneSelectCell *cell = [self.billingCtntView cellForRowAtIndexPath:indexPath];
                        // !!!: 支行名称
                        JPOneSelectCell *branchCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                        
                        if (self.banks.count > 0) {
                            
                            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                            NSMutableArray *data = @[].mutableCopy;
                            for (JPBankModel *model in self.banks) {
                                [data addObject:model.bankName];
                            }
                            weakSelf_declare;
                            if (data.count > 0) {
                                cell.isEditing = YES;
                                [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                                    NSInteger index = [[selectArray lastObject] integerValue];
                                    NSString *selectStr = [data objectAtIndex:index];
                                    cell.textLab.text = selectStr;
                                    cell.textLab.textColor = JP_Content_Color;
                                    cell.isEditing = NO;
                                    
                                    if (![branchCell.textLab.text isEqualToString:@"请选择支行名称"]) {
                                        [weakSelf.branches removeAllObjects];
                                        
                                        branchCell.textLab.text = @"请选择支行名称";
                                        branchCell.textLab.textColor = JP_NoticeText_Color;
                                    }
                                }];
                            } else {
                                [SVProgressHUD showInfoWithStatus:JPServerNot00];
                            }
                        }
                    } else if (indexPath.row == 1) {
                        //  支行名称选择 需要根据开户地省市以及银行名称来动态选择
                        // !!!: 开户地（省）
                        JPOneSelectCell *provinceCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        // !!!: 开户地（市）
                        JPOnlyOneSelectCell *cityCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        // !!!: 银行名称
                        JPOneSelectCell *bankNameCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                        // !!!: 支行名称
                        JPOneSelectCell *cell= [self.billingCtntView cellForRowAtIndexPath:indexPath];
                        
                        
                        if ([provinceCell.textLab.text isEqualToString:@"--请选择省/直辖市/自治区--"] || provinceCell.textLab.text.length <= 0) {
                            [SVProgressHUD showInfoWithStatus:@"请选择省/直辖市/自治区！"];
                            return;
                        }
                        if ([cityCell.textLab.text isEqualToString:@"--请选择开户城市（市）--"] || cityCell.textLab.text.length <= 0) {
                            [SVProgressHUD showInfoWithStatus:@"请选择开户城市（市）！"];
                            return;
                        }
                        if ([bankNameCell.textLab.text isEqualToString:@"--请选择开户行--"] || bankNameCell.textLab.text.length <= 0) {
                            [SVProgressHUD showInfoWithStatus:@"请选择开户行！"];
                            return;
                        }
                        
                        NSString *provinceCode = nil;
                        for (JPCityModel *model in self.provinces) {
                            if ([model.name isEqualToString:provinceCell.textLab.text]) {
                                provinceCode = model.code;
                            }
                        }
                        if (provinceCode == nil) {
                            provinceCode = self.credentModel.data.accountProvinceCode;
                        }
                        
                        NSString *cityCode = nil;
                        for (JPCityModel *model in self.cities) {
                            if ([model.name isEqualToString:cityCell.textLab.text]) {
                                cityCode = model.code;
                            }
                        }
                        if (cityCode == nil) {
                            cityCode = self.credentModel.data.accountCityCode;
                        }
                        weakSelf_declare;
                        [SVProgressHUD showWithStatus:@"信息获取中，请稍后..."];
                        [self canDoSthInView:NO];
                        
                        [JPNetTools1_0_2 getBankNameWithProvince:provinceCode city:cityCode bankName:bankNameCell.textLab.text callback:^(NSString *code, NSString *msg, id resp) {
                            JPLog(@"支行名称 %@ - %@ - %@", code, msg, resp);
                            if ([code isEqualToString:@"00"]) {
                                //  成功
                                [SVProgressHUD dismiss];
                                if ([resp isKindOfClass:[NSArray class]]) {
                                    NSArray *bankList = (NSArray *)resp;
                                    
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
                                        }];
                                    } else {
                                        [SVProgressHUD showInfoWithStatus:JPBranchBank];
                                    }
                                }
                            } else {
                                [SVProgressHUD showInfoWithStatus: msg];
                            }
                            [weakSelf canDoSthInView:YES];
                        }];
                    }
                }
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.baseCtntView) {
        //  营业执照栏可显示/隐藏
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        if (myIndexPath == indexPath) {
            return self.isEnterprise ? 0 : JPRealValue(100);
        } else {
            return JPRealValue(100);
        }
    } else if (tableView == self.billingCtntView) {
        return JPRealValue(100);
    } else {
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JPCredentialsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectCellReuseIdentifier forIndexPath:indexPath];
    cell.canEditing = self.applyProgress == JPApplyProgressNotThrough;
    
    JPImageModel *imgModel = self.dataSource[indexPath.row];
    
    cell.imgCode = imgModel.imgDesc;
    cell.isNeed = imgModel.isNeed;
    cell.placeholderName = imgModel.imgDesc;
    
    //  Cell默认无图片，有图片时再加载
    cell.imgUrl = @"";
    
    weakSelf_declare;
    cell.credentialsDeleteImageBlock = ^(JPCredentialsCell *item) {
        NSLog(@"delete");
        weakSelf.imageHasChange = YES;
    };
    
    //  遍历商户自助信息
    for (JPCertificateData *certificateData in self.credentModel.data.imgs) {
        for (JPImageModel *imageModel in certificateData.imgList) {
            if ([cell.imgCode isEqualToString:imageModel.imgDesc]) {
                if (imageModel.url.length <= 0) {
                    if (self.applyProgress == JPApplyProgressNotThrough) {
                        cell.image = nil;
                    } else {
                        cell.bgView.image = [UIImage imageNamed:@"jp_merchants_noImg"];
                        cell.addView.hidden = YES;
                        cell.imgNameLab.hidden = YES;
                    }
                } else {
                    cell.imgUrl = imageModel.url;
                }
            }
        }
    }
    UIImage *image = [UIImage imageWithData:[JPModifyInfoHelper objectForKey:imgModel.imgDesc]];
    if (image) {
        cell.image = image;
    }
    return cell;
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JPCredentialsCell *cell = (JPCredentialsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.applyProgress == JPApplyProgressThrough) {
        
        if (cell.hasImage) {
            [XWScanImage scanBigImageWithImageView:cell.bgView];
        } else {
            [SVProgressHUD showInfoWithStatus:@"暂无图片"];
        }
    } else if (self.applyProgress == JPApplyProgressApplying) {
        
        if (cell.hasImage) {
            [XWScanImage scanBigImageWithImageView:cell.bgView];
        } else {
            [SVProgressHUD showInfoWithStatus:@"暂无图片"];
        }
    } else {
        
        if (!cell.hasImage) {
            
            [self.view.window addSubview:self.photoView];
            self.selectIndexPath = indexPath;
            
            weakSelf_declare;
            self.photoView.jp_takePhotoBlock = ^{
                // !!!: 调用相机
                UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
                pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerC.showsCameraControls = YES;
                pickerC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                pickerC.delegate = weakSelf;
                [weakSelf presentViewController:pickerC animated:YES completion:^{
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                    weakSelf.imageHasChange = YES;
                }];
            };
            self.photoView.jp_accessAlbumBlock = ^{
                // !!!: 调用相册
                UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
                pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerC.delegate = weakSelf;
                [weakSelf presentViewController:pickerC animated:YES completion:^{
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                    weakSelf.imageHasChange = YES;
                }];
            };
        } else {
            
            if (cell.hasImage) {
                [XWScanImage scanBigImageWithImageView:cell.bgView];
            }
        }
    }
}

#pragma mark - scrollViewDelegate
//减速到停止的时候（静止）的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.menuView.selectedIndex = scrollView.contentOffset.x / kScreenWidth;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCFCredentialsNotification object:nil];
    }
}

#pragma mark - Action
- (void)onBackItemClicked:(id)sender {
    [JPModifyInfoHelper clearData];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClicked:(UIBarButtonItem *)sender {
    //  提交修改
    BOOL enterprise = self.credentModel.data.certificateImgType == 0;
    BOOL haveLicence = self.credentModel.data.certificateImgType == 1;
    BOOL public = self.credentModel.data.accountType == 1;
    
    // !!!: 商户名称
    JPInputCell *merchantNameCell = [self.baseCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    // !!!: 商户简称
    JPInputCell *merchantShortNameCell = [self.baseCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    // !!!: 详细地址
    JPOnlyInputCell *detailAddressCell = [self.baseCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    // !!!: 法人姓名
    JPInputCell *legalPersonCell = [self.baseCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    // !!!: 身份证号
    JPInputCell *IDCardNumberCell = [self.baseCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
    
    // !!!: 开户地（省）
    JPOneSelectCell *accountProvinceCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    // !!!: 开户地（市）
    JPOnlyOneSelectCell *accountCityCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    // !!!: 银行名称
    JPOneSelectCell *bankNameCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    // !!!: 支行名称
    JPOneSelectCell *branchBankNameCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    // !!!: 开户银行账号
    JPInputCell *accountCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    // !!!: 开户账号名称
    JPInputCell *accountNameCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    // !!!: 预留手机号
    JPInputCell *mobileCell = [self.billingCtntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    
    if (merchantNameCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"商户名称为空！"];
        return;
    }
    if (merchantNameCell.inputField.text.length > 32) {
        [SVProgressHUD showInfoWithStatus:@"商户名称不超过32个汉字！"];
        return;
    }
    if (![merchantNameCell.inputField.text isChinese]) {
        [SVProgressHUD showInfoWithStatus:@"商户名称不超过32个汉字！"];
        return;
    }
    
    if (merchantShortNameCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"商户简称为空！"];
        return;
    }
    if (merchantShortNameCell.inputField.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"商户简称为6-15个汉字！"];
        return;
    }
    if (merchantShortNameCell.inputField.text.length > 15) {
        [SVProgressHUD showInfoWithStatus:@"商户简称为6-15个汉字！"];
        return;
    }
    if (![merchantShortNameCell.inputField.text isChinese]) {
        [SVProgressHUD showInfoWithStatus:@"商户简称为6-15个汉字！"];
        return;
    }
    if (detailAddressCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"详细地址为空！"];
        return;
    }
    
    if (legalPersonCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"法人姓名为空！"];
        return;
    }
    if (legalPersonCell.inputField.text.length < 2) {
        [SVProgressHUD showInfoWithStatus:@"法人姓名为2-10个汉字！"];
        return;
    }
    if (legalPersonCell.inputField.text.length > 10) {
        [SVProgressHUD showInfoWithStatus:@"法人姓名为2-10个汉字！"];
        return;
    }
    if (![legalPersonCell.inputField.text isChinese]) {
        [SVProgressHUD showInfoWithStatus:@"法人姓名为2-10个汉字！"];
        return;
    }
    
    if (IDCardNumberCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"身份证号为空！"];
        return;
    }
    if (![NSString accurateVerifyIDCardNumber:IDCardNumberCell.inputField.text]) {
        [SVProgressHUD showInfoWithStatus:@"身份证号输入有误！"];
        return;
    }
    
    if ([accountProvinceCell.textLab.text isEqualToString:@"--请选择省/直辖市/自治区！--"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择开户地（省）！"];
        return;
    }
    
    if ([accountCityCell.textLab.text isEqualToString:@"--请选择开户城市（市）--"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择开户地（市）！"];
        return;
    }
    
    if ([bankNameCell.textLab.text isEqualToString:@"--请选择开户行--"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择银行名称！"];
        return;
    }
    
    if ([branchBankNameCell.textLab.text isEqualToString:@"请选择支行名称"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择支行名称！"];
        return;
    }
    
    if (accountCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"开户银行账号为空！"];
        return;
    }
    if (accountNameCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"开户账号名称为空！"];
        return;
    }
    if (accountNameCell.inputField.text.length > 32) {
        [SVProgressHUD showInfoWithStatus:@"开户账号名称不超过32个汉字！"];
        return;
    }
    if (![accountNameCell.inputField.text isChinese]) {
        [SVProgressHUD showInfoWithStatus:@"开户账号名称不超过32个汉字！"];
        return;
    }
    
    if (mobileCell.inputField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"预留手机号为空！"];
        return;
    }
    //  格式化后有空格 转成正常的字符串
    //  开户账号
    NSString *account = [UITextField numberToNormalNumTextField:accountCell.inputField];
    if (!account || account.length <= 0) {
        account = self.credentModel.data.account;
    }
    
    
    //  预留手机号
    NSString *mobile = [UITextField numberToNormalNumTextField:mobileCell.inputField];
    if (![mobile isPhone]) {
        [SVProgressHUD showInfoWithStatus:@"手机号输入有误！"];
        return;
    }
    
    if (!mobile || mobile.length <= 0) {
        mobile = self.credentModel.data.contactMobilePhone;
    }
    
    NSString *merchantCategory = self.isEnterprise ? @"1" : @"2";
    NSString *certificateImgType = self.isEnterprise ? @"0" : self.hasLicence ? @"1" : @"2";
    NSString *accountType = self.isPublic ? @"1" : @"2";
    
    if (self.isPublic) {
        if (![accountNameCell.inputField.text isEqualToString:merchantNameCell.inputField.text]) {
            [SVProgressHUD showInfoWithStatus:@"开户账号名称和商户名称须一致！"];
            return;
        }
    }
    
    ////        NSLog(@"%d - %d - %d - %@ - %@ - %@", weakSelf.isEnterprise, weakSelf.hasLicence, weakSelf.isPublic, merchantCategory, certificateImgType, accountType);
    //
    //
    
    //  详细地址
    NSString *detailAddress = detailAddressCell.inputField.text;
    if (!detailAddress || detailAddress.length <= 0) {
        detailAddress = self.credentModel.data.registerAddress;
    }
    
    //  法人
    NSString *legalPerson = legalPersonCell.inputField.text;
    if (!legalPerson || legalPerson.length <= 0) {
        legalPerson = self.credentModel.data.legalPersonName;
    }
    //  身份证号码
    NSString *IDCardNumber = IDCardNumberCell.inputField.text;
    if (!IDCardNumber || IDCardNumber.length <= 0) {
        IDCardNumber = self.credentModel.data.accountIdcard;
    }
    
    //  开户省编码
    NSString *accountProvinceCode = nil;
    for (JPCityModel *model in self.provinces) {
        if ([model.name isEqualToString:accountProvinceCell.textLab.text]) {
            accountProvinceCode = model.code;
        }
    }
    if (accountProvinceCode == nil) {
        accountProvinceCode = self.credentModel.data.accountProvinceCode;
    }
    
    //  开户市编码
    NSString *accountCityCode = nil;
    for (JPCityModel *model in self.cities) {
        if ([model.name isEqualToString:accountCityCell.textLab.text]) {
            accountCityCode = model.code;
        }
    }
    if (accountCityCode == nil) {
        accountCityCode = self.credentModel.data.accountCityCode;
    }
    
    //  开户行名称
    NSString *accountBankNameId = nil;
    for (JPBankModel *model in self.banks) {
        if ([model.bankName isEqualToString:bankNameCell.textLab.text]) {
            accountBankNameId = model.bankName;
        }
    }
    if (accountBankNameId == nil) {
        accountBankNameId = self.credentModel.data.accountBankName;
    }
    
    //  开户支行名称/支行编码
    NSString *alliedBankCode = nil;
    NSString *accountBankBranchName = nil;
    for (JPBankModel *model in self.branches) {
        if ([model.bankName isEqualToString:branchBankNameCell.textLab.text]) {
            alliedBankCode = model.bankCode;
            accountBankBranchName = model.bankName;
        }
    }
    if (alliedBankCode == nil) {
        alliedBankCode = self.credentModel.data.accountBankBranchCode;
        accountBankBranchName =  self.credentModel.data.accountBankBranchName;
    }
    
    //  开户银行名称
    NSString *accountName = accountNameCell.inputField.text;
    if (!accountName || accountName.length <= 0) {
        accountName = self.credentModel.data.accountName;
    }
    
//    JPLog(@"商户自助 - %d - %d - %@ - %@ - %@ - %@ - %@\n%d - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@", self.isEnterprise, self.hasLicence, merchantNameCell.inputField.text, merchantShortNameCell.inputField.text, self.selfHelpModel.data.registerAddress, self.selfHelpModel.data.industryType, self.selfHelpModel.data.industryNo, self.isPublic, legalPersonCell.inputField.text, userNameCell.inputField.text, IDCardNumberCell.inputField.text, accountProvinceCell.textLab.text, accountCityCell.textLab.text, bankNameCell.textLab.text, branchBankNameCell.textLab.text, accountCell.inputField.text, accountNameCell.inputField.text, mobileCell.inputField.text);
    
    for (NSInteger j = 0; j < self.dataSource.count; j ++) {
        JPCredentialsCell *cell = (JPCredentialsCell *)[self.credentialsColView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
        if (!self.imageHasChange) {
            self.imageHasChange = cell.valueHasChange;
        }
        if (!cell.hasImage && cell.isNeed) {
            [SVProgressHUD showInfoWithStatus:@"证件资料缺失，请补齐资料后重新提交！"];
            return;
        }
    }
    
    //  数据是否发生过变化
    BOOL valueChanged = (enterprise != self.isEnterprise) || (haveLicence != self.hasLicence) || (public != self.isPublic) || (![merchantNameCell.inputField.text isEqualToString:self.credentModel.data.merchantName]) || (![merchantShortNameCell.inputField.text isEqualToString:self.credentModel.data.merchantShortName]) || (![detailAddressCell.inputField.text isEqualToString:self.credentModel.data.registerAddress]) || (![legalPersonCell.inputField.text isEqualToString:self.credentModel.data.legalPersonName]) || (![NSString accurateVerifyIDCardNumber:IDCardNumberCell.inputField.text]) || (![IDCardNumberCell.inputField.text isEqualToString:self.credentModel.data.accountIdcard]) || (![accountProvinceCell.textLab.text isEqualToString:self.credentModel.data.accountProvinceName]) || (![accountCityCell.textLab.text isEqualToString:self.credentModel.data.accountCityName]) || (![bankNameCell.textLab.text isEqualToString:self.credentModel.data.accountBankName]) || (![branchBankNameCell.textLab.text isEqualToString:self.credentModel.data.accountBankBranchName]) || (![accountNameCell.inputField.text isEqualToString:self.credentModel.data.accountName]) || (![account isEqualToString:self.credentModel.data.account]) || (![mobile isEqualToString:self.credentModel.data.contactMobilePhone]) || (![merchantCategory isEqualToString:[NSString stringWithFormat:@"%ld", (long)self.credentModel.data.merchantCategory]]) || (![certificateImgType isEqualToString:[NSString stringWithFormat:@"%ld", (long)self.credentModel.data.certificateImgType]]) || (![accountType isEqualToString:[NSString stringWithFormat:@"%ld", (long)self.credentModel.data.accountType]]) || (![legalPerson isEqualToString:self.credentModel.data.legalPersonName]) || (![IDCardNumber isEqualToString:self.credentModel.data.accountIdcard]) || (![accountProvinceCell.textLab.text isEqualToString:self.credentModel.data.accountProvinceName]) || (![accountCityCell.textLab.text isEqualToString:self.credentModel.data.accountCityName]) || (![bankNameCell.textLab.text isEqualToString:self.credentModel.data.accountBankName]) || (![branchBankNameCell.textLab.text isEqualToString:self.credentModel.data.accountBankBranchName]) || (![accountName isEqualToString:self.credentModel.data.accountName]) || self.imageHasChange;
    
    if (!valueChanged) {
        [SVProgressHUD showInfoWithStatus:@"您还没有作任何修改！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"进件资料提交中，请稍后..."];
    [self canDoSthInView:NO];
    
    weakSelf_declare;
    
    //  等图片都上传完成后再进行下一步操作
    dispatch_group_t group = dispatch_group_create();
    
    if (![merchantNameCell.inputField.text isEqualToString:self.credentModel.data.merchantName]) {
        dispatch_group_enter(group);
        
        [MobClick event:@"merchant_save"];
        
        [JPNetTools1_0_2 vaildBusinessInfoWithCheckCode:@"01" qrCodeId:nil content:merchantNameCell.inputField.text callback:^(NSString *code, NSString *msg, id resp) {
            JPLog(@"查询商户名称是否存在 %@ - %@ - %@", code, msg, resp);
            
            if ([code isEqualToString:@"00"]) {
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    BOOL isExist = [resp[@"isExist"] boolValue];
                    if (isExist) {
                        [SVProgressHUD showInfoWithStatus:@"商户名已存在！"];
                        [weakSelf canDoSthInView:YES];
                        return;
                    }
                }
            } else {
                [SVProgressHUD showInfoWithStatus:msg];
                [weakSelf canDoSthInView:YES];
                return;
            }
            [SVProgressHUD dismiss];
            dispatch_group_leave(group);
        }];
    }
    
    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        JPCredentialsCell *cell = (JPCredentialsCell *)[self.credentialsColView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        CGFloat contentOffset_x = ([[self.tags valueForKeyPath:@"@max.floatValue"] floatValue] - 100) * kScreenWidth;
        //  collectView未展示时，即图片未修改，不需要上传图片
        if (contentOffset_x >= kScreenWidth * 2) {
            
            NSLog(@"Cell%ld  -  %d", (long)i, cell.valueHasChange);
            if (cell.valueHasChange && cell.hasImage) {
                
                dispatch_group_enter(group);
                
                [JPNetTools1_0_2 uploadImage:cell.bgView.image isUpdate:true checkContent:[JPUserEntity sharedUserEntity].jp_user tagStr:cell.imgCode progress:nil callback:^(NSString *code, NSString *msg, id resp) {
                    JPLog(@"图片上传 %@ - %@ - %@", code, msg, resp);
                    if ([code isEqualToString:@"00"]) {
                        
                        for (JPCertificateData *cerData in self.docModel.data) {
                            for (JPImageModel *imgModel in cerData.imgList) {
                                if ([cell.imgCode isEqualToString:imgModel.imgDesc]) {
                                    [imgModel setUrl:resp];
                                }
                            }
                        }
                    } else {
                        [SVProgressHUD showInfoWithStatus:@"网络异常，请重新提交！"];
                        [weakSelf canDoSthInView:YES];
                        return;
                    }
                    dispatch_group_leave(group);
                }];
            } else {
                //  按遍历结果填值
                if (!cell.hasImage) {
                    for (JPCertificateData *docData in weakSelf.docModel.data) {
                        for (JPImageModel *imageModel in docData.imgList) {
                            if ([imageModel.imgDesc isEqualToString:cell.imgCode]){
                                [imageModel setUrl:@""];
                            }
                        }
                    }
                } else {
                    for (JPCertificateData *docData in weakSelf.docModel.data) {
                        for (JPImageModel *imageModel in docData.imgList) {
                            if ([imageModel.imgDesc isEqualToString:cell.imgCode]) {
                                NSInteger dataIndex = [weakSelf.docModel.data indexOfObject:docData];
                                JPCertificateData *defDataModel = weakSelf.credentModel.data.imgs[dataIndex];
                                
                                NSInteger imgIndex = [docData.imgList indexOfObject:imageModel];
                                JPImageModel *defImgModel = defDataModel.imgList[imgIndex];
                                
                                [imageModel setUrl:defImgModel.url];
                            }
                        }
                    }
                }
            }
        } else {
            
//            [weakSelf.docModel setData:weakSelf.credentModel.data.imgs];
            for (JPCertificateData *docData in weakSelf.docModel.data) {
                for (JPImageModel *imageModel in docData.imgList) {
                    if ([imageModel.imgDesc isEqualToString:cell.imgCode]) {
                        NSInteger dataIndex = [weakSelf.docModel.data indexOfObject:docData];
                        JPCertificateData *defDataModel = weakSelf.credentModel.data.imgs[dataIndex];
                        
                        NSInteger imgIndex = [docData.imgList indexOfObject:imageModel];
                        JPImageModel *defImgModel = defDataModel.imgList[imgIndex];
                        
                        [imageModel setUrl:defImgModel.url];
                    }
                }
            }
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //  请求完毕后的处理
        
        NSDictionary *dic = [JPTransferMJ getObjectData:weakSelf.docModel];
        NSArray *dataArray = dic[@"data"];
        
        if (dic.count <= 0) {
            NSDictionary *Dic = [JPTransferMJ getObjectData:weakSelf.credentModel];
            dataArray = Dic[@"data"][@"imgs"];
        }
//        NSLog(@"dataArray - %@", dataArray);
        
        [JPNetTools1_0_2 commitWithMerchantCategory:merchantCategory
                                 certificateImgType:certificateImgType
                                       merchantName:merchantNameCell.inputField.text
                                  merchantShortName:merchantShortNameCell.inputField.text
                               registerProvinceCode:weakSelf.credentModel.data.registerProvinceCode
                                   registerCityCode:weakSelf.credentModel.data.registerCityCode
                               registerDistrictCode:weakSelf.credentModel.data.registerDistrictCode
                                    registerAddress:detailAddress
                                       industryType:weakSelf.credentModel.data.industryType
                                                mcc:weakSelf.credentModel.data.mcc
                                         industryNo:weakSelf.credentModel.data.industryNo
                                    legalPersonName:legalPerson
                                           username:weakSelf.credentModel.data.userName
                                      accountIdcard:IDCardNumber
                                        accountType:accountType
                                accountProvinceCode:accountProvinceCode
                                    accountCityCode:accountCityCode
                                  accountBankNameId:accountBankNameId
                                     alliedBankCode:alliedBankCode
                              accountBankBranchName:accountBankBranchName
                                            account:account
                                        accountName:accountName
                                 contactMobilePhone:mobile
                                           qrcodeId:@""
                                         merchantId:[NSString stringWithFormat:@"%ld", (long)weakSelf.credentModel.data.merchantId] remark:nil
                                               imgs:dataArray
                                           callback:^(NSString *code, NSString *msg, id resp) {
                                               
            JPLog(@"商户进件信息提交 - %@ - %@ - %@", code, msg, resp);
            if ([code isEqualToString:@"00"]) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [JPModifyInfoHelper clearData];
                [[SDImageCache sharedImageCache] clearDisk];
            } else {
                [SVProgressHUD showInfoWithStatus:@"网络异常，请重新提交！"];
            }
            [weakSelf canDoSthInView:YES];
        }];
    });
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    weakSelf_declare;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        UIImage *compressedImage = [UIImage imageWithData:imageData];
        
        UIImage *scaleImage = [compressedImage jp_scaleToTargetWidth:kScreenWidth];
        
        JPCredentialsCell *cell = (JPCredentialsCell *)[weakSelf.credentialsColView cellForItemAtIndexPath:weakSelf.selectIndexPath];
        cell.image = scaleImage;
        [JPModifyInfoHelper addObject:UIImageJPEGRepresentation(scaleImage, 1) forKey:cell.imgCode];
    }];
}

#pragma mark - NSNotification
- (void)handleCredentialsInfoNotification:(NSNotification *)noti {
    NSInteger type = self.isEnterprise ? 0 : self.hasLicence ? 1 : 2;
    [self createRequestWithType:[NSString stringWithFormat:@"%ld", (long)type]];
}

- (void)detailAddressTextChanged:(NSNotification *)noti {
    
    UITextField *inputField = [self.view viewWithTag:201707050937];
    UITextRange *selectedRange = inputField.markedTextRange;
    UITextPosition *position = [inputField positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { //// 没有高亮选择的字
        //过滤非汉字字符
        inputField.text = [self filterCharactor:inputField.text withRegex:@"[^\u4e00-\u9fa5_a-zA-Z0-9\\-() （）]"];
    }
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    
    UITextField *phoneField = [self.view viewWithTag:333333];
    UITextField *accountField = [self.view viewWithTag:444444];
    //  手机号输入文字格式化
    if (phoneField == textField) {
        return [UITextField phoneNumberFormatTextField:phoneField shouldChangeCharactersInRange:range replacementString:string];
    }
    //  银行卡输入文字格式化
    if (accountField == textField) {
        return [UITextField bankNumberFormatTextField:accountField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    UITextField *idcardField = [self.view viewWithTag:201706221507];
    if (textField == idcardField) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9}; 88;X
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 88) return NO; //
            if (character > 88) return NO;
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 18) {
            return NO;//限制长度
        }
        return YES;
    }
    
    UITextField *detailAddress = [self.view viewWithTag:201707050937];
    if (textField == detailAddress) {
        //        if (detailAddress.text.length >= 30) {
        //            [SVProgressHUD showInfoWithStatus:@"最多30个字符！"];
        //            return NO;
        //        }
        return detailAddress.text.length < 30;
    }
    return YES;
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

#pragma mark - 是否可操作，用于提交信息时，保证提交的同时不能作修改
- (void)canDoSthInView:(BOOL)canDo {
    self.navigationController.navigationBar.userInteractionEnabled = canDo;
    self.menuView.userInteractionEnabled = canDo;
    self.scrollView.userInteractionEnabled = canDo;
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
