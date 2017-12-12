//
//  IBBaseInfoViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/9/4.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBBaseInfoViewController.h"
#import "JPRegisterProgressView.h"
#import "JPSearchIndustryViewController.h"
#import "JPBillingInfoViewController.h"

@interface IBBaseInfoViewController () <UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *navImageView;
@property (nonatomic, strong) JPRegisterProgressView *progressView;
/** 商户类别*/
@property (nonatomic, strong) IBCateSelectView *merchantCateView;
/** 营业执照*/
@property (nonatomic, strong) IBCateSelectView *licenceView;
/** 商户名称*/
@property (nonatomic, strong) IBInputView *merchantNameView;
/** 商户简称*/
@property (nonatomic, strong) IBInputView *merchantShortView;
/** 法人姓名*/
@property (nonatomic, strong) IBInputView *legalPersonView;
/** 用户名*/
@property (nonatomic, strong) IBInputView *userNameView;
/** 身份证号*/
@property (nonatomic, strong) IBInputView *idcardNumberView;
/** 注册省*/
@property (nonatomic, strong) IBOneSelectView *registerProvinceView;
/** 注册市县*/
@property (nonatomic, strong) IBOnlyTwoSelectView *registerAreaView;
/** 详细地址*/
@property (nonatomic, strong) IBOnlyInputView *addressView;
/** 行业类型*/
@property (nonatomic, strong) IBOneSelectView *indusView;
/** 行业编号*/
@property (nonatomic, strong) IBOnlyOneSelectView *indusNoView;
/** 备注*/
@property (nonatomic, strong) IBRemarkView *remarkView;
/** 按钮*/
@property (nonatomic, strong) IBBaseInfoView *footerView;

/** 是否是企业类*/
@property (nonatomic, assign) BOOL isEnterprise;
/** 是否有营业执照*/
@property (nonatomic, assign) BOOL hasLicence;

/** 省份*/
@property (nonatomic, strong) NSMutableArray *provinces;
/** 城市*/
@property (nonatomic, strong) NSMutableArray *cities;
/** 区县*/
@property (nonatomic, strong) NSMutableArray *counties;
/** 行业类型*/
@property (nonatomic, strong) NSMutableArray *indusList;
/** 行业编号*/
@property (nonatomic, strong) NSMutableArray *indusNoList;
@end

@implementation IBBaseInfoViewController

#pragma mark - request
- (void)createRequest {
    dispatch_group_t group = dispatch_group_create();
    weakSelf_declare;
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    // !!!: 注册省市区县
    dispatch_group_enter(group);
    [JPNetTools1_0_2 getRegisterAddressWithParent:@"1" level:@"1" qrcodeId:self.qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
        JPLog(@"注册省市区县 %@ - %@ - %@", code, msg, resp);
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
        }
        dispatch_group_leave(group);
    }];
    
    // !!!: 行业类型
    dispatch_group_enter(group);
    
    [JPNetTools1_0_2 getIndustryTypeWithName:@"" callback:^(NSString *code, NSString *msg, id resp) {
        JPLog(@"行业类型 %@ - %@ - %@", code, msg, resp);
        if ([code isEqualToString:@"00"]) {
            //  成功
            if ([resp isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in resp) {
                    JPIndustryModel *industryModel = [JPIndustryModel yy_modelWithDictionary:dic];
                    [weakSelf.indusList addObject:industryModel];
                }
            }
        } else {
            //  失败
            [SVProgressHUD showInfoWithStatus:msg];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //  请求完毕后的处理
        [weakSelf reloadData];
        [SVProgressHUD dismiss];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isEnterprise = true;
    self.hasLicence = true;
    [self.view addSubview:self.scrollView];
    [self layoutHomeView];
    //  Request
    [self createRequest];
    //  Subviews
    [self.scrollView addSubview:self.progressView];
    [self.scrollView addSubview:self.merchantCateView];
    [self.scrollView addSubview:self.licenceView];
    [self handleLicenceView];
    
    [self.scrollView addSubview:self.merchantNameView];
    [self.scrollView addSubview:self.merchantShortView];
    [self.scrollView addSubview:self.legalPersonView];
    [self.scrollView addSubview:self.userNameView];
    [self.scrollView addSubview:self.idcardNumberView];
    [self.scrollView addSubview:self.registerProvinceView];
    [self.scrollView addSubview:self.registerAreaView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.indusView];
    [self.scrollView addSubview:self.indusNoView];
    [self.scrollView addSubview:self.remarkView];
    [self.scrollView addSubview:self.footerView];
    
    //  根据lineView内容自适应高度
    CGSize actualSize = [self.footerView sizeThatFits:CGSizeZero];
    CGRect newFrame = self.footerView.frame;
    newFrame.size.height = actualSize.height;
    self.footerView.frame = newFrame;
    //  根据lineView高度计算scrollView的ContentSize
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, newFrame.origin.y + newFrame.size.height + 10)];
}

#pragma mark - Methods
- (void)reloadData {
    weakSelf_declare;
    //  注册省份
    self.registerProvinceView.block = ^(IBOneSelectView *blockView) {
        
        NSMutableArray *data = @[].mutableCopy;
        for (JPCityModel *model in weakSelf.provinces) {
            [data addObject:model.name];
        }
        if (data.count > 0) {
            [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                NSInteger index = [[selectArray lastObject] integerValue];
                NSString *selectStr = [data objectAtIndex:index];
                blockView.textLab.text = selectStr;
                blockView.textLab.textColor = JP_Content_Color;
                blockView.isEditing = NO;
                
                //  重新选择省级，清空市县
                if (![weakSelf.registerAreaView.leftLab.text isEqualToString:@"选择市"] || ![weakSelf.registerAreaView.rightLab.text isEqualToString:@"选择区/县"]) {
                    weakSelf.registerAreaView.leftLab.text = @"选择市";
                    weakSelf.registerAreaView.rightLab.text = @"选择区/县";
                    weakSelf.registerAreaView.leftLab.textColor = JP_NoticeText_Color;
                    weakSelf.registerAreaView.rightLab.textColor = JP_NoticeText_Color;
                    
                    [weakSelf.cities removeAllObjects];
                    [weakSelf.counties removeAllObjects];
                }
            }];
        }
    };
    
    __block IBOneSelectView *provinceView = self.registerProvinceView;
    //  选择市
    self.registerAreaView.ib_leftBlock = ^(IBOnlyTwoSelectView *blockView, UIButton *leftButton, UILabel *leftLab) {
        if (![provinceView.textLab.text isEqualToString:@"选择省/直辖市/自治区"]) {
            //  已选择省/直辖市/自治区
            NSMutableArray *provinceData = @[].mutableCopy;
            for (JPCityModel *model in weakSelf.provinces) {
                [provinceData addObject:model.name];
            }
            NSInteger i = [provinceData indexOfObject:provinceView.textLab.text];
            JPCityModel *model = weakSelf.provinces[i];
            
            [JPNetTools1_0_2 getRegisterAddressWithParent:model.code level:@"2" qrcodeId:weakSelf.qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
                JPLog(@"市 === %@", resp);
                if ([code isEqualToString:@"00"]) {
                    if ([resp isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)resp;
                        //  获取到新数据 删除老数据
                        [weakSelf.cities removeAllObjects];
                        //  把新数据加入到数组
                        for (NSDictionary *dic in arr) {
                            JPCityModel *cityModel = [JPCityModel yy_modelWithDictionary:dic];
                            [weakSelf.cities addObject:cityModel];
                        }
                        NSMutableArray *data = @[].mutableCopy;
                        for (JPCityModel *model in weakSelf.cities) {
                            [data addObject:model.name];
                        }
                        if (data.count > 0) {
                            [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                                NSInteger index = [[selectArray lastObject] integerValue];
                                NSString *selectStr = [data objectAtIndex:index];
                                blockView.leftLab.text = selectStr;
                                blockView.leftLab.textColor = JP_Content_Color;
                                
                                //  重新选择省级，清空市县
                                if (![weakSelf.registerAreaView.rightLab.text isEqualToString:@"选择区/县"]) {
                                    weakSelf.registerAreaView.rightLab.text = @"选择区/县";
                                    weakSelf.registerAreaView.rightLab.textColor = JP_NoticeText_Color;
                                    
                                    [weakSelf.counties removeAllObjects];
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
    };
    
    __block IBOnlyTwoSelectView *citiView = self.registerAreaView;
    //  选择区县
    self.registerAreaView.ib_rightBlock = ^(IBOnlyTwoSelectView *blockView, UIButton *rightButton, UILabel *rightLab) {
        if (![provinceView.textLab.text isEqualToString:@"选择省/直辖市/自治区"]) {
            if (![citiView.leftLab.text isEqualToString:@"选择市"]) {
                
                //  已选择市
                NSMutableArray *cityData = @[].mutableCopy;
                for (JPCityModel *model in weakSelf.cities) {
                    [cityData addObject:model.name];
                }
                NSInteger i = [cityData indexOfObject:citiView.leftLab.text];
                JPCityModel *model = weakSelf.cities[i];
                
                [JPNetTools1_0_2 getRegisterAddressWithParent:model.code level:@"3" qrcodeId:weakSelf.qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
                    JPLog(@"区/县 === %@", resp);
                    if ([code isEqualToString:@"00"]) {
                        if ([resp isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)resp;
                            [weakSelf.counties removeAllObjects];
                            for (NSDictionary *dic in arr) {
                                JPCityModel *countyModel = [JPCityModel yy_modelWithDictionary:dic];
                                [weakSelf.counties addObject:countyModel];
                            }
                            
                            NSMutableArray *data = @[].mutableCopy;
                            for (JPCityModel *model in weakSelf.counties) {
                                [data addObject:model.name];
                            }
                            if (data.count > 0) {
                                [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                                    NSInteger index = [[selectArray lastObject] integerValue];
                                    NSString *selectStr = [data objectAtIndex:index];
                                    blockView.rightLab.text = selectStr;
                                    blockView.rightLab.textColor = JP_Content_Color;
                                }];
                            }
                        }
                    } else {
                        [SVProgressHUD showInfoWithStatus:msg];
                    }
                }];
            } else {
                [SVProgressHUD showInfoWithStatus:@"请先选择市！"];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:@"请先选择省/直辖市/自治区！"];
        }
    };
    
    //  行业类型
    self.indusView.block = ^(IBOneSelectView *blockView) {
        NSMutableArray *data = @[].mutableCopy;
        for (JPIndustryModel *model in weakSelf.indusList) {
            [data addObject:model.name];
        }
        if (data.count > 0) {
            [KYSNormalPickerView KYSShowWithDataArray:@[data] completeBlock:^(NSArray *selectArray) {
                NSInteger index = [[selectArray lastObject] integerValue];
                NSString *selectStr = [data objectAtIndex:index];
                blockView.textLab.text = selectStr;
                blockView.textLab.textColor = JP_Content_Color;
                blockView.isEditing = NO;
                
                if (![weakSelf.indusNoView.textLab.text isEqualToString:@"选择行业编号"]) {
                    weakSelf.indusNoView.textLab.text = @"选择行业编号";
                    weakSelf.indusNoView.textLab.textColor = JP_NoticeText_Color;
                }
            }];
        }
    };
    
    //  行业编号
    __block IBOneSelectView *indusView = self.indusView;
    self.indusNoView.block = ^(IBOnlyOneSelectView *blockView) {
        JPLog(@"选择了行业编号");
        if (![indusView.textLab.text isEqualToString:@"选择行业类型"]) {
            //  已选择行业类型
            NSMutableArray *indusData = @[].mutableCopy;
            for (JPIndustryModel *model in weakSelf.indusList) {
                [indusData addObject:model.name];
            }
            NSInteger i = [indusData indexOfObject:weakSelf.indusView.textLab.text];
            JPIndustryModel *model = weakSelf.indusList[i];
            
            [JPNetTools1_0_2 getIndustryTypeWithName:model.name callback:^(NSString *code, NSString *msg, id resp) {
                
                JPLog(@"行业子类 - %@", resp);
                if ([code isEqualToString:@"00"]) {
                    //  成功
                    if ([resp isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)resp;
                        [weakSelf.indusNoList removeAllObjects];
                        for (NSDictionary *dic in arr) {
                            JPIndustryModel *industryModel = [JPIndustryModel yy_modelWithDictionary:dic];
                            [weakSelf.indusNoList addObject:industryModel];
                        }
                    }
                    NSMutableArray *data = @[].mutableCopy;
                    for (JPIndustryModel *model in weakSelf.indusNoList) {
                        [data addObject:model.name];
                    }
                    JPLog(@"行业编号 - %@", data);
                    if (data.count > 0) {
                        JPSearchIndustryViewController *searchVC = [JPSearchIndustryViewController new];
                        searchVC.dataSource = data;
                        searchVC.jp_returnSearchValue = ^(NSString *name) {
                            //  回调
                            if (name.length > 0) {
                                weakSelf.indusNoView.textLab.text = name;
                                weakSelf.indusNoView.textLab.textColor = JP_Content_Color;
                            }
                        };
                        [weakSelf presentViewController:[[JPNavigationController alloc] initWithRootViewController:searchVC] animated:YES completion:nil];
                    }
                } else {
                    //  失败
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            }];
        } else {
            [SVProgressHUD showInfoWithStatus:@"请先选择行业类型！"];
        }
    };
}

- (void)handleLicenceView {
    if (self.isEnterprise) {
        self.licenceView.frame = (CGRect){0, JPRealValue(430), kScreenWidth, 0};
        self.licenceView.hidden = YES;
    } else {
        self.licenceView.frame = (CGRect){0, JPRealValue(430), kScreenWidth, JPRealValue(70)};
        self.licenceView.hidden = NO;
        
        JPSelectButton *leftButton = [_licenceView viewWithTag:666];
        JPSelectButton *rightButton = [_licenceView viewWithTag:888];
        leftButton.selected = self.hasLicence;
        rightButton.selected = !self.hasLicence;
        weakSelf_declare;
        @weakify(leftButton)
        @weakify(rightButton)
        _licenceView.ib_cateSelectBlock = ^(NSInteger tag) {
            
            @strongify(leftButton)
            @strongify(rightButton)
            leftButton.selected = tag == 666;
            rightButton.selected = tag == 888;
            weakSelf.hasLicence = tag == 666;
            //  刷新营业执照那一行，若选择企业类，营业执照不显示；若选择个体户，营业执照显示并需要选择
            weakSelf.merchantNameView.inputField.placeholder = (!self.isEnterprise && !self.hasLicence) ? @"请输入商户名称" : @"营业执照上的名称";
        };
    }
}
- (void)reloadScrollSubviews {
    [self handleLicenceView];
    self.merchantNameView.inputField.placeholder = (!self.isEnterprise && !self.hasLicence) ? @"请输入商户名称" : @"营业执照上的名称";
    
    self.merchantNameView.frame = self.isEnterprise ? (CGRect){0, JPRealValue(430), kScreenWidth, JPRealValue(70)} : (CGRect){0, JPRealValue(530), kScreenWidth, JPRealValue(70)};
    self.merchantShortView.frame = (CGRect){0, self.merchantNameView.frame.origin.y + self.merchantNameView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.legalPersonView.frame = (CGRect){0, self.merchantShortView.frame.origin.y + self.merchantShortView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.userNameView.frame = (CGRect){0, self.legalPersonView.frame.origin.y + self.legalPersonView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.idcardNumberView.frame = (CGRect){0, self.userNameView.frame.origin.y + self.userNameView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.registerProvinceView.frame = (CGRect){0, self.idcardNumberView.frame.origin.y + self.idcardNumberView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.registerAreaView.frame = (CGRect){0, self.registerProvinceView.frame.origin.y + self.registerProvinceView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.addressView.frame = (CGRect){0, self.registerAreaView.frame.origin.y + self.registerAreaView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.indusView.frame = (CGRect){0, self.addressView.frame.origin.y + self.addressView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.indusNoView.frame = (CGRect){0, self.indusView.frame.origin.y + self.indusView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
    self.remarkView.frame = (CGRect){0, self.indusNoView.frame.origin.y + self.indusNoView.frame.size.height + JPRealValue(20), kScreenWidth, JPRealValue(240)};
    self.footerView.frame = (CGRect){0, self.remarkView.frame.origin.y + self.remarkView.frame.size.height + JPRealValue(20), kScreenWidth, JPRealValue(300)};
    
    //  根据lineView内容自适应高度
    CGSize actualSize = [self.footerView sizeThatFits:CGSizeZero];
    CGRect newFrame = self.footerView.frame;
    newFrame.size.height = actualSize.height;
    self.footerView.frame = newFrame;
    //  根据lineView高度计算scrollView的ContentSize
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, newFrame.origin.y + newFrame.size.height + 10)];
}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

#pragma mark - Getter
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

- (NSMutableArray *)counties {
    if (!_counties) {
        _counties = @[].mutableCopy;
    }
    return _counties;
}

- (NSMutableArray *)indusList {
    if (!_indusList) {
        _indusList = @[].mutableCopy;
    }
    return _indusList;
}

- (NSMutableArray *)indusNoList {
    if (!_indusNoList) {
        _indusNoList = @[].mutableCopy;
    }
    return _indusNoList;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
        CGFloat height = isPhoneX ? 44 : 20;
        _scrollView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0);
        _scrollView.backgroundColor = JP_viewBackgroundColor;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
         _scrollView.delegate = self;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_scrollView sizeToFit];
    }
    return _scrollView;
}

- (JPRegisterProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[JPRegisterProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, JPRealValue(340))];
        _progressView.steps = JPStepsBaseInfo;
    }
    return _progressView;
}

- (IBCateSelectView *)merchantCateView {
    if (!_merchantCateView) {
        _merchantCateView = [IBCateSelectView new];
        _merchantCateView.frame = (CGRect){0, JPRealValue(340), kScreenWidth, JPRealValue(70)};
        _merchantCateView.title = @"商户类别";
        [_merchantCateView setLeftTitle:@"企业类" rightTitle:@"个体户"];
        
        JPSelectButton *leftButton = [_merchantCateView viewWithTag:666];
        JPSelectButton *rightButton = [_merchantCateView viewWithTag:888];
        leftButton.selected = self.isEnterprise;
        rightButton.selected = !self.isEnterprise;
        weakSelf_declare;
        @weakify(leftButton)
        @weakify(rightButton)
        _merchantCateView.ib_cateSelectBlock = ^(NSInteger tag) {
            
            [weakSelf.view endEditing:YES];
            
            @strongify(leftButton)
            @strongify(rightButton)
            leftButton.selected = tag == 666;
            rightButton.selected = tag == 888;
            weakSelf.isEnterprise = tag == 666;
            //  刷新营业执照那一行，若选择企业类，营业执照不显示；若选择个体户，营业执照显示并需要选择
            [weakSelf reloadScrollSubviews];
        };
    }
    return _merchantCateView;
}

- (IBCateSelectView *)licenceView {
    if (!_licenceView) {
        _licenceView = [IBCateSelectView new];
        _licenceView.frame = (CGRect){0, JPRealValue(410), kScreenWidth, JPRealValue(70)};
        _licenceView.title = @"营业执照";
        [_licenceView setLeftTitle:@"有" rightTitle:@"无"];
    }
    return _licenceView;
}

- (IBInputView *)merchantNameView {
    if (!_merchantNameView) {
        _merchantNameView = [IBInputView new];
        _merchantNameView.frame = self.isEnterprise ? (CGRect){0, JPRealValue(430), kScreenWidth, JPRealValue(70)} : (CGRect){0, JPRealValue(530), kScreenWidth, JPRealValue(70)};
        _merchantNameView.title = @"商户名称";
        _merchantNameView.inputField.placeholder = (!self.isEnterprise && !self.hasLicence) ? @"请输入商户名称" : @"营业执照上的名称";
        _merchantNameView.inputField.delegate = self;
    }
    return _merchantNameView;
}

- (IBInputView *)merchantShortView {
    if (!_merchantShortView) {
        _merchantShortView = [IBInputView new];
        _merchantShortView.frame = (CGRect){0, self.merchantNameView.frame.origin.y + self.merchantNameView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _merchantShortView.title = @"商户简称";
        _merchantShortView.inputField.placeholder = @"不超过15个汉字";
        _merchantShortView.inputField.delegate = self;
    }
    return _merchantShortView;
}

- (IBInputView *)legalPersonView {
    if (!_legalPersonView) {
        _legalPersonView = [IBInputView new];
        _legalPersonView.frame = (CGRect){0, self.merchantShortView.frame.origin.y + self.merchantShortView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _legalPersonView.title = @"法人姓名";
        _legalPersonView.inputField.placeholder = @"2-10个汉字";
        _legalPersonView.inputField.delegate = self;
    }
    return _legalPersonView;
}

- (IBInputView *)userNameView {
    if (!_userNameView) {
        _userNameView = [IBInputView new];
        _userNameView.frame = (CGRect){0, self.legalPersonView.frame.origin.y + self.legalPersonView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _userNameView.title = @"用户名";
        _userNameView.inputField.placeholder = @"不少于6位英文字母或数字";
        _userNameView.inputField.delegate = self;
    }
    return _userNameView;
}

- (IBInputView *)idcardNumberView {
    if (!_idcardNumberView) {
        _idcardNumberView = [IBInputView new];
        _idcardNumberView.frame = (CGRect){0, self.userNameView.frame.origin.y + self.userNameView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _idcardNumberView.title = @"身份证号";
        _idcardNumberView.inputField.placeholder = @"请输入身份证号";
        _idcardNumberView.inputField.delegate = self;
    }
    return _idcardNumberView;
}

- (IBOneSelectView *)registerProvinceView {
    if (!_registerProvinceView) {
        _registerProvinceView = [IBOneSelectView new];
        _registerProvinceView.frame = (CGRect){0, self.idcardNumberView.frame.origin.y + self.idcardNumberView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _registerProvinceView.title = @"注册地址";
        _registerProvinceView.textLab.text = @"选择省/直辖市/自治区";
    }
    return _registerProvinceView;
}

- (IBOnlyTwoSelectView *)registerAreaView {
    if (!_registerAreaView) {
        _registerAreaView = [IBOnlyTwoSelectView new];
        _registerAreaView.frame = (CGRect){0, self.registerProvinceView.frame.origin.y + self.registerProvinceView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _registerAreaView.leftLab.text = @"选择市";
        _registerAreaView.rightLab.text = @"选择区/县";
    }
    return _registerAreaView;
}

- (IBOnlyInputView *)addressView {
    if (!_addressView) {
        _addressView = [IBOnlyInputView new];
        _addressView.frame = (CGRect){0, self.registerAreaView.frame.origin.y + self.registerAreaView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _addressView.inputField.placeholder = @"选择地址，中英文下划线";
        _addressView.inputField.delegate = self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailAddressValueChanged:) name:UITextFieldTextDidChangeNotification object:_addressView.inputField];
    }
    return _addressView;
}

- (IBOneSelectView *)indusView {
    if (!_indusView) {
        _indusView = [IBOneSelectView new];
        _indusView.frame = (CGRect){0, self.addressView.frame.origin.y + self.addressView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _indusView.title = @"行业类型";
        _indusView.textLab.text = @"选择行业类型";
    }
    return _indusView;
}

- (IBOnlyOneSelectView *)indusNoView {
    if (!_indusNoView) {
        _indusNoView = [IBOnlyOneSelectView new];
        _indusNoView.frame = (CGRect){0, self.indusView.frame.origin.y + self.indusView.frame.size.height + JPRealValue(30), kScreenWidth, JPRealValue(70)};
        _indusNoView.textLab.text = @"选择行业编号";
    }
    return _indusNoView;
}

- (IBRemarkView *)remarkView {
    if (!_remarkView) {
        _remarkView = [IBRemarkView new];
        _remarkView.frame = (CGRect){0, self.indusNoView.frame.origin.y + self.indusNoView.frame.size.height + JPRealValue(20), kScreenWidth, JPRealValue(240)};
//        _remarkView.remarkString = @"台签1个，台贴0个";
        _remarkView.txtView.ib_text = @"台签1个，台贴0个";
    }
    return _remarkView;
}

- (IBBaseInfoView *)footerView {
    if (!_footerView) {
        _footerView = [IBBaseInfoView new];
        _footerView.frame = (CGRect){0, self.remarkView.frame.origin.y + self.remarkView.frame.size.height + JPRealValue(20), kScreenWidth, JPRealValue(300)};
        weakSelf_declare;
        _footerView.nextBlock = ^{
            // !!!: 下一步
            JPLog(@"商户类别 - %d， 营业执照 - %d， 商户名称 - %@， 商户简称 - %@， 法人姓名 - %@， 用户名 - %@， 省份证号 - %@， 注册地址 - %@， 注册市 - %@， 注册县区 - %@， 详细地址 - %@， 行业类型 - %@， 行业编号 - %@， 备注 - %@", weakSelf.isEnterprise, weakSelf.hasLicence, weakSelf.merchantNameView.inputField.text, weakSelf.merchantShortView.inputField.text, weakSelf.legalPersonView.inputField.text, weakSelf.userNameView.inputField.text, weakSelf.idcardNumberView.inputField.text, weakSelf.registerProvinceView.textLab.text, weakSelf.registerAreaView.leftLab.text, weakSelf.registerAreaView.rightLab.text, weakSelf.addressView.inputField.text, weakSelf.indusView.textLab.text, weakSelf.indusNoView.textLab.text, weakSelf.remarkView.remarkString);
            
            /** 商户名称*/
            NSString *businessName = weakSelf.merchantNameView.inputField.text;
            /** 商户简称*/
            NSString *businessShortName = weakSelf.merchantShortView.inputField.text;
            /** 法人姓名*/
            NSString *legalPerson = weakSelf.legalPersonView.inputField.text;
            /** 用户名*/
            NSString *userName = weakSelf.userNameView.inputField.text;
            /** 身份证号*/
            NSString *idcardNumber = weakSelf.idcardNumberView.inputField.text;
            /** 注册省*/
            NSString *registerProvidence = weakSelf.registerProvinceView.textLab.text;
            /** 注册市*/
            NSString *registerCity = weakSelf.registerAreaView.leftLab.text;
            /** 注册区县*/
            NSString *registerCounty = weakSelf.registerAreaView.rightLab.text;
            /** 详细地址*/
            NSString *detailAddress = weakSelf.addressView.inputField.text;
            /** 行业类型*/
            NSString *indus = weakSelf.indusView.textLab.text;
            /** 行业编号*/
            NSString *indusNo = weakSelf.indusNoView.textLab.text;
            /** 备注*/
            NSString *remark = weakSelf.remarkView.txtView.ib_text;
            
            // TODO: 判空验证
            if (businessName.length <= 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入商户名称！"];
                return;
            }
            if (![businessName isChinese]) {
                [SVProgressHUD showInfoWithStatus:@"商户名称不超过32个汉字！"];
                return;
            }
            if (businessName.length > 32) {
                [SVProgressHUD showInfoWithStatus:@"商户名称不超过32个汉字！"];
                return;
            }
            if (businessShortName.length <= 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入商户简称！"];
                return;
            }
            if (businessShortName.length > 15) {
                [SVProgressHUD showInfoWithStatus:@"商户简称不超过15个汉字！"];
                return;
            }
            if (![businessShortName isChinese]) {
                [SVProgressHUD showInfoWithStatus:@"商户简称不超过15个汉字！"];
                return;
            }
            if (legalPerson.length <= 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入法人姓名！"];
                return;
            }
            if (legalPerson.length < 2) {
                [SVProgressHUD showInfoWithStatus:@"法人姓名为2-10个汉字！"];
                return;
            }
            if (legalPerson.length > 10) {
                [SVProgressHUD showInfoWithStatus:@"法人姓名为2-10个汉字！"];
                return;
            }
            if (![legalPerson isChinese]) {
                [SVProgressHUD showInfoWithStatus:@"法人姓名为2-10个汉字！"];
                return;
            }
            if (userName.length <= 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入用户名！"];
                return;
            }
            if (userName.length < 6) {
                [SVProgressHUD showInfoWithStatus:@"用户名不少于6位英文或数字！"];
                return;
            }
            if (idcardNumber.length <= 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入身份证号码！"];
                return;
            }
            if (![NSString accurateVerifyIDCardNumber:idcardNumber]) {
                [SVProgressHUD showInfoWithStatus:@"身份证号填写有误！"];
                return;
            }
            if ([registerProvidence isEqualToString:@"选择省/直辖市/自治区"]) {
                [SVProgressHUD showInfoWithStatus:@"请选择注册省/直辖市/自治区！"];
                return;
            }
            if ([registerCity isEqualToString:@"选择市"]) {
                [SVProgressHUD showInfoWithStatus:@"请选择注册市！"];
                return;
            }
            if ([registerCounty isEqualToString:@"选择区/县"]) {
                [SVProgressHUD showInfoWithStatus:@"请选择注册区/县！"];
                return;
            }
            if (detailAddress.length <= 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
                return;
            }
            if ([indus isEqualToString:@"选择行业类型"]) {
                [SVProgressHUD showInfoWithStatus:@"请选择行业类型！"];
                return;
            }
            if ([indusNo isEqualToString:@"选择行业编号"]) {
                [SVProgressHUD showInfoWithStatus:@"请选择行业编号！"];
                return;
            }
            [MobClick event:@"baseInfoNext"];
            
            dispatch_group_t group = dispatch_group_create();
            // !!!: 查询商户名称是否存在
            dispatch_group_enter(group);
            [SVProgressHUD showWithStatus:@"验证商户名称，请稍后..."];
            
            [JPNetTools1_0_2 vaildBusinessInfoWithCheckCode:@"01" qrCodeId:weakSelf.qrcodeid content:businessName callback:^(NSString *code, NSString *msg, id resp) {
                JPLog(@"查询商户名称是否存在 %@ - %@ - %@", code, msg, resp);
                
                if ([code isEqualToString:@"00"]) {
                    if ([resp isKindOfClass:[NSDictionary class]]) {
                        BOOL isExist = [resp[@"isExist"] boolValue];
                        if (isExist) {
                            [SVProgressHUD showInfoWithStatus:@"商户名已存在！"];
//                            sender.userInteractionEnabled = YES;
//                            sender.backgroundColor = JPBaseColor;
                            return;
                        }
                    }
                } else {
                    [SVProgressHUD showInfoWithStatus:msg];
//                    sender.userInteractionEnabled = YES;
//                    sender.backgroundColor = JPBaseColor;
                    return;
                }
                [SVProgressHUD dismiss];
                dispatch_group_leave(group);
            }];
//            [IBPersonRequest checkUserInfoAccount:[JPUserEntity sharedUserEntity].account merchantId:0 isUserName:false content:businessName qrCodeId:weakSelf.qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
//                if (code.integerValue == 0) {
//                    [SVProgressHUD dismiss];
//                    if ([resp isKindOfClass:[NSDictionary class]]) {
//                        BOOL isExist = [resp[@"isExist"] boolValue];
//                        if (isExist) {
//                            [SVProgressHUD showInfoWithStatus:@"商户名已存在！"];
//                            return;
//                        } else {
//                            dispatch_group_leave(group);
//                        }
//                    }
//                } else {
//                    [SVProgressHUD showInfoWithStatus:msg];
//                    return;
//                }
//            }];
            
            // !!!: 查询用户名是否存在
            dispatch_group_enter(group);
            [SVProgressHUD showWithStatus:@"验证用户名，请稍后..."];
            [JPNetTools1_0_2 vaildBusinessInfoWithCheckCode:@"02" qrCodeId:weakSelf.qrcodeid content:userName callback:^(NSString *code, NSString *msg, id resp) {
                JPLog(@"查询用户名是否存在 %@ - %@ - %@", code, msg, resp);
                
                if ([code isEqualToString:@"00"]) {
                    if ([resp isKindOfClass:[NSDictionary class]]) {
                        BOOL isExist = [resp[@"isExist"] boolValue];
                        if (isExist) {
                            [SVProgressHUD showInfoWithStatus:@"用户名已存在！"];
//                            sender.userInteractionEnabled = YES;
//                            sender.backgroundColor = JPBaseColor;
                            return;
                        }
                    }
                } else {
                    [SVProgressHUD showInfoWithStatus:msg];
//                    sender.userInteractionEnabled = YES;
//                    sender.backgroundColor = JPBaseColor;
                    return;
                }
                [SVProgressHUD dismiss];
                dispatch_group_leave(group);
            }];
//            [IBPersonRequest checkUserInfoAccount:[JPUserEntity sharedUserEntity].account merchantId:0 isUserName:true content:userName qrCodeId:weakSelf.qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
//                if (code.integerValue == 0) {
//                    [SVProgressHUD dismiss];
//                    if ([resp isKindOfClass:[NSDictionary class]]) {
//                        BOOL isExist = [resp[@"isExist"] boolValue];
//                        if (isExist) {
//                            [SVProgressHUD showInfoWithStatus:@"用户名已存在！"];
//                            return;
//                        } else {
//                            dispatch_group_leave(group);
//                        }
//                    }
//                } else {
//                    [SVProgressHUD showInfoWithStatus:msg];
//                    return;
//                }
//            }];
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                //  请求完毕后的处理
                //  下一步
                JPBillingInfoViewController *billInfoVC = [JPBillingInfoViewController new];
                billInfoVC.qrcodeid = weakSelf.qrcodeid;
                billInfoVC.isEnterprise = weakSelf.isEnterprise;
                billInfoVC.hasLicence = weakSelf.hasLicence;
                billInfoVC.merchantName = businessName;
                billInfoVC.merchantShortName = businessShortName;
                billInfoVC.legalName = legalPerson;
                billInfoVC.userName = userName;
                billInfoVC.IDCardNumber = idcardNumber;
                billInfoVC.remark = remark;
                for (JPCityModel *model in weakSelf.provinces) {
                    if ([model.name isEqualToString:registerProvidence]) {
                        billInfoVC.registerProvince = model.code;
                    }
                }
                for (JPCityModel *model in weakSelf.cities) {
                    if ([model.name isEqualToString:registerCity]) {
                        billInfoVC.registerCity = model.code;
                    }
                }
                for (JPCityModel *model in weakSelf.counties) {
                    if ([model.name isEqualToString:registerCounty]) {
                        billInfoVC.registerCounty = model.code;
                    }
                }
                billInfoVC.detailAddress = detailAddress;
                billInfoVC.mainIndustry = indus;
                for (JPIndustryModel *model in weakSelf.indusNoList) {
                    if ([model.name isEqualToString:indusNo]) {
                        billInfoVC.secondaryIndustry = model.name;
                        billInfoVC.mcc = model.mcc;
                    }
                }
                [weakSelf.navigationController pushViewController:billInfoVC animated:YES];
            });
        };
        _footerView.previousBlock = ^{
            //  上一步
            [weakSelf backButtonClicked:nil];
        };
    }
    return _footerView;
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    
    if (textField == self.userNameView.inputField) {
        //  不少于6位英文或数字
        //lengthOfString的值始终为1
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            unichar character = [string characterAtIndex:loopIndex];
            
            // 48-57;{0,9};    65-90;{A..Z};   97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
            
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        return proposedNewLength <= 16;
    }
    
    if (textField == self.idcardNumberView.inputField) {
        
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            unichar character = [string characterAtIndex:loopIndex];
            // 48-57;{0,9};    88;X
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 88) return NO; //
            if (character > 88) return NO;
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        return proposedNewLength < 19;
    }
//    if (textField == self.merchantNameView.inputField) {
//        return self.merchantNameView.inputField.text.length < 32;
//    }
//    if (textField == self.merchantShortView.inputField) {
//        return self.merchantShortView.inputField.text.length < 15;
//    }
//    if (textField == self.legalPersonView.inputField) {
//        return self.legalPersonView.inputField.text.length < 10;
//    }
//    if (textField == self.addressView.inputField) {
//        return self.addressView.inputField.text.length < 30;
//    }
    
    return YES;
}

#pragma mark - textFieldNotification

- (void)detailAddressValueChanged:(NSNotification *)noti {
    
    UITextField *inputField = (UITextField *)noti.object;
    UITextRange *selectedRange = inputField.markedTextRange;
    UITextPosition *position = [inputField positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { //// 没有高亮选择的字
        //过滤非汉字字符
        inputField.text = [self filterCharactor:inputField.text withRegex:@"[^\u4e00-\u9fa5_a-zA-Z0-9\\-() （）]"];
    }
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

#pragma mark - Action
//  返回
- (void)backButtonClicked:(UIButton *)sender {
    JPLog(@"点击了上一步");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:JPBackNoti preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JPUserInfoHelper clearData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - LayoutHeader
- (void)layoutHomeView {
    if (!_navImageView) {
        _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navImageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_navImageView];
    }    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"基本信息";
    titleLab.font = [UIFont systemFontOfSize:JPRealValue(34)];
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

@end
