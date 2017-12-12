//
//  JPPersonViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPPersonViewController.h"
#import "JPCodeViewController.h"
#import "JPQuestionesViewController.h"
#import "JPAnnouncementViewController.h"
#import "JPSettingViewController.h"
#import "JPCodeModel.h"
#import "JPMerchantsViewController.h"

#define imageName @"imageName"
#define configName @"configName"
#define headerHeight JPRealValue(288) + 30

typedef NS_ENUM(NSUInteger, JPBusinessType) {
    JPBusinessK9 = 1,       //  K9（普通）商户
    JPBusinessCode = 2,     //  一码付商户
};

@protocol JPPersonHeaderDelegate <NSObject>
@required
- (void)gotoCodeVC:(UIButton *)sender;
@end

@interface JPPersonHeaderView : UITableViewHeaderFooterView
@property (nonatomic, retain) id<JPPersonHeaderDelegate> delegate;
//  商户类型
@property (nonatomic, assign) JPBusinessType type;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *cateLab;
/** K9商户*/
@property (nonatomic, strong) UIView *k9View;
@property (nonatomic, strong) UIImageView *k9HeadImage;
@property (nonatomic, strong) UILabel *k9NickName;

/** 一码付商户*/
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIImageView *codeHeadImage;
@property (nonatomic, strong) UILabel *codeNickName;
@property (nonatomic, strong) UIButton *goCodeButton;
@property (nonatomic, strong) UIImageView *indicatorView;

@end

@implementation JPPersonHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}

#pragma mark - Method
- (void)handleUserInterface {
    self.bgView = [UIImageView new];
    self.bgView.image = [UIImage imageNamed:@"jp_person_bg"];
    self.bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgView];
    
    self.cateLab = [UILabel new];
    self.cateLab.text = @"      全部分类";
    self.cateLab.font = [UIFont boldSystemFontOfSize:JPRealValue(28)];
    self.cateLab.textColor = JP_Content_Color;
    [self.contentView addSubview:self.cateLab];
    
    self.k9View = [UIView new];
    [self.bgView addSubview:self.k9View];
    
    self.k9HeadImage = [UIImageView new];
    self.k9HeadImage.image = [UIImage imageNamed:@"jp_person_user"];
    [self.k9View addSubview:self.k9HeadImage];
    
    self.k9NickName = [UILabel new];
    self.k9NickName.text = @"Candy006";
    self.k9NickName.textAlignment = NSTextAlignmentCenter;
    self.k9NickName.textColor = [UIColor whiteColor];
    self.k9NickName.font = [UIFont systemFontOfSize:JPRealValue(31)];
    [self.k9View addSubview:self.k9NickName];
    
    self.codeView = [UIView new];
    [self.bgView addSubview:self.codeView];
    
    self.codeHeadImage = [UIImageView new];
    self.codeHeadImage.image = [UIImage imageNamed:@"jp_person_user"];
    [self.codeView addSubview:self.codeHeadImage];
    
    self.codeNickName = [UILabel new];
    self.codeNickName.text = @"Candy006";
    self.codeNickName.textColor = [UIColor whiteColor];
    self.codeNickName.font = [UIFont systemFontOfSize:JPRealValue(31)];
    [self.codeView addSubview:self.codeNickName];
    
    self.indicatorView = [UIImageView new];
    self.indicatorView.image = [UIImage imageNamed:@"jp_person_indicator"];
    [self.codeView addSubview:self.indicatorView];
    
    self.goCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goCodeButton setImage:[UIImage imageNamed:@"jp_person_code"] forState:UIControlStateNormal];
    [self.goCodeButton addTarget:self action:@selector(goCodeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.codeView addSubview:self.goCodeButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.backgroundColor = JP_viewBackgroundColor;
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@(headerHeight - 30));
    }];
    
    [self.cateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_bottom);
        make.left.and.right.equalTo(weakSelf.bgView);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
    }];
    
    [self.k9View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.and.bottom.equalTo(weakSelf.bgView);
    }];
    
    [self.k9HeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
    
    [self.k9NickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.k9HeadImage.mas_centerX);
        make.top.equalTo(weakSelf.k9HeadImage.mas_bottom).offset(JPRealValue(20));
        make.size.mas_equalTo(CGSizeMake(180, JPRealValue(40)));
    }];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.and.right.equalTo(weakSelf.bgView);
    }];
    
    [self.codeHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.codeView.mas_left).offset(JPRealValue(30));
        make.centerY.equalTo(weakSelf.codeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(72), JPRealValue(72)));
    }];
    
    [self.codeNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.codeHeadImage.mas_centerY);
        make.left.equalTo(weakSelf.codeHeadImage.mas_right).offset(JPRealValue(26));
        make.size.mas_equalTo(CGSizeMake(180, JPRealValue(40)));
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.codeView.mas_right).offset(JPRealValue(-30));
        make.centerY.equalTo(weakSelf.codeNickName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(15), JPRealValue(22)));
    }];
    
    [self.goCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.indicatorView.mas_left);
        make.centerY.equalTo(weakSelf.indicatorView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(100), JPRealValue(100)));
    }];
}

- (void)setType:(JPBusinessType)type {
    switch (type) {
        case JPBusinessK9:
        {
            self.k9View.hidden = NO;
            self.codeView.hidden = YES;
        }
            break;
        case JPBusinessCode:
        {
            self.k9View.hidden = YES;
            self.codeView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)goCodeVC:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoCodeVC:)]) {
        [self.delegate gotoCodeVC:sender];
    }
}

@end

@interface JPPersonViewController () <UITableViewDataSource, UITableViewDelegate, JPPersonHeaderDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*configArray;
@property (nonatomic, strong) JPCodeModel *codeModel;
@end

@implementation JPPersonViewController

- (void)requestCodeStr {
    NSString *url = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_qrcodeAp_url];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JPUserEntity sharedUserEntity].merchantId forKey:@"merchantId"];
    weakSelf_declare;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [JPNetworking postUrl:url params:params progress:nil callback:^(id resp) {
        JPLog(@"%@", resp);
        if ([resp isKindOfClass:[NSString class]]) {
            [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
        } else if ([resp isKindOfClass:[NSDictionary class]]) {
            if ([resp[@"status"] isEqualToString:@"500"]) {
                [SVProgressHUD showInfoWithStatus:resp[@"msg"]];
            } else {
                [SVProgressHUD dismiss];
                [JP_UserDefults setObject:resp[@"merchantName"] forKey:@"merchantName"];
                weakSelf.codeModel = [JPCodeModel yy_modelWithDictionary:resp];
                [weakSelf.ctntView reloadData];
            }
        }
        [weakSelf.ctntView.mj_header endRefreshing];
    }];
}

#pragma mark - lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        CGFloat headHeight = isPhoneX ? 0.f : -20.f;
        _ctntView.contentInset = UIEdgeInsetsMake(headHeight, 0, 0, 0);
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.rowHeight = 60;
        _ctntView.separatorColor = JP_LineColor;
    }
    return _ctntView;
}
- (NSMutableArray<NSDictionary *> *)configArray {
    if (!_configArray) {
        _configArray = @[].mutableCopy;
    }
    return _configArray;
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if ([JPUserEntity sharedUserEntity].applyType == 2) {
//        //  一码付商户
//        [self.configArray addObject:@{ imageName : @"jp_person_register", configName : @"商户自助" }];
//    }
//    [self.configArray addObject:@{ imageName : @"jp_person_notice", configName : @"公告" }];
    [self.configArray addObject:@{ imageName : @"jp_person_question", configName : @"常见问题" }];
    [self.configArray addObject:@{ imageName : @"jp_person_setting", configName : @"设置" }];
    [self.view addSubview:self.ctntView];
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestCodeStr];
    }];
    [self.ctntView.mj_header beginRefreshing];
}

#pragma mark - tableViewDataSource
static NSString *const cellReuseIdentifier = @"cell";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = JP_DefaultsFont;
    }
    NSDictionary *configDic = self.configArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:configDic[imageName]];
    cell.textLabel.text = configDic[configName];
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"商户自助"]) {
        //  商户自助
        JPMerchantsViewController *merchantVC = [[JPMerchantsViewController alloc] init];
        merchantVC.navigationItem.title = @"商户自助";
        merchantVC.hidesBottomBarWhenPushed = YES;
        
        [SVProgressHUD showWithStatus:@"加载中，请稍后..."];
        weakSelf_declare;
        [JPNetTools1_0_2 getBusinessSelfHelpStateWithUserName:[JPUserEntity sharedUserEntity].jp_user callback:^(NSString *code, NSString *msg, id resp) {
            JPLog(@"商户自助进件状态查询 --- %@ - %@ - %@", code, msg, resp);
            if ([code isEqualToString:@"00"]) {
                //  成功
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    [SVProgressHUD dismiss];
                    
                    [MobClick event:@"person_selfHelp"];
                    
                    JPStateQueryModel *queryModel = [JPStateQueryModel yy_modelWithDictionary:resp];
                    NSString *statusCode = queryModel.statusCode;
                    if ([statusCode isEqualToString:@"1"]) {
                        //  审核通过
                        merchantVC.applyProgress = JPApplyProgressThrough;
                    } else if ([statusCode isEqualToString:@"5"]) {
                        //  审核不通过
                        merchantVC.applyProgress = JPApplyProgressNotThrough;
                    } else {
                        //  审核中
                        merchantVC.applyProgress = JPApplyProgressApplying;
                    }
                    merchantVC.merchantsModel = queryModel;
                    [weakSelf.navigationController pushViewController:merchantVC animated:YES];
                } else {
                    [SVProgressHUD showInfoWithStatus: msg];
                }
            } else {
                [SVProgressHUD showInfoWithStatus: msg];
            }
        }];
    } else if ([cell.textLabel.text isEqualToString:@"常见问题"]) {
        [MobClick event:@"person_questions"];
        //  常见问题
        JPQuestionesViewController *questionVC = [[JPQuestionesViewController alloc] init];
        questionVC.navigationItem.title = @"常见问题";
        questionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:questionVC animated:YES];
    } else if ([cell.textLabel.text isEqualToString:@"设置"]) {
        [MobClick event:@"person_setting"];
        //  设置
        JPSettingViewController *settingVC = [[JPSettingViewController alloc] init];
        settingVC.navigationItem.title = @"设置";
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPPersonHeaderView *headerView = [JPPersonHeaderView new];
    headerView.delegate = self;
    headerView.type = [JPUserEntity sharedUserEntity].applyType;
    headerView.k9NickName.text = [JPUserEntity sharedUserEntity].jp_user;
    headerView.codeNickName.text = [JPUserEntity sharedUserEntity].jp_user;
    return headerView;
}

#pragma mark - JPPersonHeaderDelegate
- (void)gotoCodeVC:(UIButton *)sender {
    
    [MobClick event:@"person_qrcode"];
    //  二维码界面
    JPCodeViewController *codeVC = [[JPCodeViewController alloc] init];
    codeVC.navigationItem.title = @"我的收款码";
    codeVC.hidesBottomBarWhenPushed = YES;
    codeVC.codeModel = self.codeModel;
    [self.navigationController pushViewController:codeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
