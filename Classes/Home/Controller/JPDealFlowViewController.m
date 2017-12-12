//
//  JPDealFlowViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealFlowViewController.h"
#import "JPDealMesRequest.h"
#import "JPDealFlowModel.h"

static NSString *const extentionCellReuseIdentifier = @"extentionCell";

@interface JPDealFlowHeadButton : UIButton
@property (nonatomic, assign) JPDealTextColorType colorType;
@property (nonatomic, strong) UILabel *lineLab;
/** 交易时间*/
@property (nonatomic, strong) UILabel *dealTime;
/** 商户名称*/
@property (nonatomic, strong) UILabel *businessName;
/** 交易金额*/
@property (nonatomic, strong) UILabel *dealMoney;
/** 指示符*/
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) JPDealFlowModel *dealFlowModel;
@property (nonatomic, strong) NSString *shortName;
/** Cell开关*/
@property (assign, nonatomic, getter = isOpen) BOOL open;
@end
@implementation JPDealFlowHeadButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _open = NO;
        //  处理UI
        [self handleUserInterface];
    }
    return self;
}

- (void)setOpen:(BOOL)open {
    _open = open;
    //设定点击旋转动画效果
    [UIView beginAnimations:nil context:nil];
    self.indicatorView.transform = CGAffineTransformMakeRotation(self.isOpen ? M_PI : 0);
    [UIView commitAnimations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.dealTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(@(kScreenWidth / 3.0));
    }];
    
    [self.businessName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.dealTime.mas_right);
        make.width.equalTo(@(kScreenWidth / 3.0));
    }];
    
    [self.dealMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.businessName.mas_right);
        make.width.equalTo(@(kScreenWidth / 3.0 - 35));
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.dealMoney.mas_right);
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.dealMoney.mas_centerY);
        make.height.equalTo(@15);
    }];
    
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(30));
        make.bottom.and.right.equalTo(weakSelf);
        make.height.equalTo(@0.5);
    }];
}
#pragma mark - Method
- (void)handleUserInterface {
    
    self.dealTime = [UILabel new];
    self.dealTime.text = @"04-17 14:00";
    self.dealTime.textAlignment = NSTextAlignmentCenter;
    
    self.dealTime.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.dealTime];
    
    self.businessName = [UILabel new];
    self.businessName.text = @"杰博实产品创新部";
    self.businessName.textAlignment = NSTextAlignmentCenter;
    self.businessName.textColor = JP_Content_Color;
    self.businessName.font = [UIFont systemFontOfSize:14];
    self.businessName.numberOfLines = 0;
    self.businessName.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.businessName];
    
    self.dealMoney = [UILabel new];
    self.dealMoney.text = @"666.00";
    self.dealMoney.textAlignment = NSTextAlignmentCenter;
    
    self.dealMoney.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.dealMoney];
    
    self.indicatorView = [UIImageView new];
    self.indicatorView.image = [UIImage imageNamed:@"jp_home_close"];
    [self addSubview:self.indicatorView];
    
    self.lineLab = [UILabel new];
    self.lineLab.backgroundColor = JP_LineColor;
    [self addSubview:self.lineLab];
}
- (void)setDealFlowModel:(JPDealFlowModel *)dealFlowModel {
    
    NSDate *dealDate = [NSDate dateFromString:dealFlowModel.recCrtTs withFormat:@"yyyyMMddHHmmss"];
    self.dealTime.text = [NSDate stringFromDate:dealDate withFormat:@"MM-dd HH:mm"];
    if (dealFlowModel.merchantShortName.length <= 0) {
        self.businessName.text = self.shortName;
    } else {
        self.businessName.text = dealFlowModel.merchantShortName;
    }
    
    self.dealMoney.text = [NSString stringWithFormat:@"%.2lf", [dealFlowModel.transAt doubleValue]];
    
    if (self.colorType == JPDealTextColorTypeFailed && [dealFlowModel.transName  isEqualToString:@"交易失败"]) {
        self.dealTime.textColor = [UIColor redColor];
        self.businessName.textColor = [UIColor redColor];
        self.dealMoney.textColor = [UIColor redColor];
    } else {
        self.dealTime.textColor = JP_Content_Color;
        self.businessName.textColor = JP_Content_Color;
        self.dealMoney.textColor = JP_Content_Color;
    }
}
@end

@interface JPDealFlowHeaderView : UIView
/** 交易时间*/
@property (nonatomic, strong) UILabel *dealTime;
/** 商户名称*/
@property (nonatomic, strong) UILabel *businessName;
/** 交易金额*/
@property (nonatomic, strong) UILabel *dealMoney;
@property (nonatomic, strong) UILabel *lineLab;
@end

@implementation JPDealFlowHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //  处理UI
        [self handleUserInterface];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    weakSelf_declare;
    [self.dealTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(@(kScreenWidth / 3.0));
    }];
    
    [self.businessName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.dealTime.mas_right);
        make.width.equalTo(@(kScreenWidth / 3.0));
    }];
    
    [self.dealMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(@(kScreenWidth / 3.0));
    }];
    
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(weakSelf);
        make.height.equalTo(@0.5);
    }];
}
#pragma mark - Method
- (void)handleUserInterface {
    
    self.dealTime = [UILabel new];
    self.dealTime.text = @"交易时间";
    self.dealTime.textAlignment = NSTextAlignmentCenter;
    self.dealTime.textColor = JPBaseColor;
    self.dealTime.font = JP_DefaultsFont;
    [self addSubview:self.dealTime];
    
    self.businessName = [UILabel new];
    self.businessName.text = @"商户名称";
    self.businessName.textAlignment = NSTextAlignmentCenter;
    self.businessName.textColor = JPBaseColor;
    self.businessName.font = JP_DefaultsFont;
    [self addSubview:self.businessName];
    
    self.dealMoney = [UILabel new];
    self.dealMoney.text = @"交易金额";
    self.dealMoney.textAlignment = NSTextAlignmentCenter;
    self.dealMoney.textColor = JPBaseColor;
    self.dealMoney.font = JP_DefaultsFont;
    [self addSubview:self.dealMoney];
    
    self.lineLab = [UILabel new];
    self.lineLab.backgroundColor = JP_LineColor;
    [self addSubview:self.lineLab];
}
@end

@interface JPDealFlowViewController () <UITableViewDataSource, UITableViewDelegate>
/** 背景*/
@property (nonatomic, strong) UIView *bgView;
/** 总计标签*/
@property (nonatomic, strong) UILabel *totalLab;
/** 总计金额*/
@property (nonatomic, strong) UILabel *totalCount;
/** 总交易金额标签*/
@property (nonatomic, strong) UILabel *totalDealLab;
/** 总交易金额*/
@property (nonatomic, strong) UILabel *totalDealAmount;
/** 总入账金额标签*/
@property (nonatomic, strong) UILabel *totalBookedLab;
/** 总入账金额*/
@property (nonatomic, strong) UILabel *totalBookedAmount;
/** 总优惠金额标签*/
@property (nonatomic, strong) UILabel *totalReductionLab;
/** 总优惠金额*/
@property (nonatomic, strong) UILabel *totalReductionAmount;

@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) JPDealFlowHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastPageTime;
@property (nonatomic, strong) JPNoNewsView *resultView;
@end

@implementation JPDealFlowViewController {
    NSMutableDictionary *_headers;
}

#pragma mark - requestDealMessageList
- (void)requestDealMesListWithCurrentPageTime:(NSString *)currentPageTime startRow:(NSInteger)startRow {
    
    weakSelf_declare;
    //  监控网络状态变化
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2: {
                [JPDealMesRequest getDealMesListWithMsgFlag:weakSelf.msgFlag mercFlag:weakSelf.mercFlag merchantNo:weakSelf.merchantNo merchantId:weakSelf.merchantId userName:weakSelf.userName startTime:weakSelf.startTime endTime:weakSelf.endTime currentPageTime:currentPageTime type:weakSelf.type payChannel:weakSelf.payChannel startRow:startRow callback:^(id resp) {
//                    NSLog(@"%@", resp);
                    if (![resp isKindOfClass:[NSDictionary class]]) {
                        return;
                    }
                    NSDictionary *respDic = (NSDictionary *)resp;
                    if (startRow == 0) {
                        
                        [weakSelf.dataSource removeAllObjects];
                        [weakSelf layoutTotalAmountWithTotal:respDic[@"total"] totalDealAmount:respDic[@"totalMoney"] totalBookedAmount:respDic[@"allMoney"] totalReductionAmount:respDic[@"totalAmount"]];
                    }
                    if (![respDic.allKeys containsObject:@"list"]) {
                        return;
                    }
                    if ([respDic[@"list"] isKindOfClass:[NSArray class]]) {
                        NSArray *list = respDic[@"list"];
                        for (NSDictionary *dic in list) {
                            JPDealFlowModel *model = [JPDealFlowModel yy_modelWithDictionary:dic];
                            [weakSelf.dataSource addObject:model];
                        }
                        _headers = [[NSMutableDictionary alloc] initWithCapacity:weakSelf.dataSource.count];
                        if (weakSelf.dataSource.count > 0) {
                            weakSelf.headerView.hidden = NO;
                            weakSelf.bgView.hidden = NO;
                            weakSelf.resultView.hidden = YES;
                        } else {
                            weakSelf.headerView.hidden = YES;
                            weakSelf.bgView.hidden = YES;
                            weakSelf.resultView.hidden = NO;
                        }
                        JPDealFlowModel *dealModel = [weakSelf.dataSource firstObject];
                        weakSelf.lastPageTime = dealModel.recCrtTs;
                        
                        weakSelf.ctntView.mj_footer.hidden = list.count != 10;
                        if (list.count == 10) {
                            [weakSelf.ctntView.mj_footer resetNoMoreData];
                        } else {
                            [SVProgressHUD showSuccessWithStatus:@"数据已全部加载完成"];
                            [weakSelf.ctntView.mj_footer endRefreshingWithNoMoreData];
                        }
                    }
                    [weakSelf.ctntView reloadData];
                    [weakSelf.ctntView.mj_header endRefreshing];
                    [weakSelf.ctntView.mj_footer endRefreshing];
                }];
            }
                break;
            default: {
                NSLog(@"没网");
                weakSelf.resultView.hidden = NO;
                weakSelf.resultView.result = JPResultNoNet;
                weakSelf.ctntView.hidden = YES;
            }
                break;
        }
    }];
}

#pragma mark - lazy
- (UITableView *)ctntView {
    if (_ctntView == nil) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44 - 90) style:UITableViewStyleGrouped];
        _ctntView.delegate = self;
        _ctntView.dataSource = self;
        _ctntView.tableFooterView = [UIView new];
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorColor = JP_LineColor;
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
    }
    return _ctntView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
- (JPDealFlowHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JPDealFlowHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    }
    return _headerView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44)];
        _bgView.backgroundColor = JP_viewBackgroundColor;
    }
    return _bgView;
}

- (JPNoNewsView *)resultView {
    if (!_resultView) {
        _resultView = [[JPNoNewsView alloc] initWithFrame:self.view.frame];
        _resultView.result = JPResultNoData;
    }
    return _resultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.ctntView];
    [self.view addSubview:self.resultView];
    
    self.resultView.hidden = YES;
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            weakSelf.pageNo = 0;
            [weakSelf requestDealMesListWithCurrentPageTime:@"" startRow:0];
        });
    }];
    //    self.ctntView.mj_header.hidden = NO;
    
    self.ctntView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            weakSelf.pageNo ++;
            [weakSelf requestDealMesListWithCurrentPageTime:weakSelf.lastPageTime startRow:weakSelf.pageNo * 10];
        });
    }];
    self.ctntView.mj_footer.hidden = YES;
    
    [self.ctntView.mj_header beginRefreshing];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JPDealFlowHeadButton *header = _headers[@(section)];
    NSInteger count = header.isOpen ? 1 : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([JPUserEntity sharedUserEntity].applyType == 1) {
        JPDealFlowExtentionCell *cell = [tableView dequeueReusableCellWithIdentifier:extentionCellReuseIdentifier];
        if (!cell) {
            cell = [[JPDealFlowExtentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:extentionCellReuseIdentifier];
        }
        cell.colorType = self.isRed;
        cell.dealModel = self.dataSource[indexPath.section];
        return cell;
    } else if ([JPUserEntity sharedUserEntity].applyType == 2) {
        JPDealFlowExtentCell *cell = [tableView dequeueReusableCellWithIdentifier:extentionCellReuseIdentifier];
        if (!cell) {
            cell = [[JPDealFlowExtentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:extentionCellReuseIdentifier];
        }
        cell.colorType = self.isRed;
        cell.dealModel = self.dataSource[indexPath.section];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JPUserEntity sharedUserEntity].applyType == 1 ? JPRealValue(234) : JPRealValue(263);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPDealFlowHeadButton *header = _headers[@(section)];
    if (!header)
    {
        header = [JPDealFlowHeadButton buttonWithType:UIButtonTypeCustom];
        header.backgroundColor = [UIColor whiteColor];
        header.bounds = CGRectMake(0, 0, kScreenWidth, 60);
        header.colorType = self.isRed;
        header.shortName = self.businessShortName;
        header.dealFlowModel = self.dataSource[section];
        [header addTarget:self action:@selector(expandFriends:) forControlEvents:UIControlEventTouchUpInside];
        [_headers setObject:header forKey:@(section)];
    }
    return header;
}

#pragma mark - Define
- (void)expandFriends:(JPDealFlowHeadButton *)header {
    header.open = !header.isOpen;
    [self.ctntView reloadData];
}

#pragma mark - Layout
- (void)layoutTotalAmountWithTotal:(NSString *)total totalDealAmount:(NSString *)totalDealAmount totalBookedAmount:(NSString *)totalBookedAmount totalReductionAmount:(NSString *)totalReductionAmount {
    weakSelf_declare;
    if (!self.totalLab) {
        self.totalLab = [UILabel new];
        self.totalLab.text = @"总           计：";
        self.totalLab.font = [UIFont systemFontOfSize:JPRealValue(28)];
        self.totalLab.textColor = JP_NoticeText_Color;
        [self.bgView addSubview:self.totalLab];
    }
    if (!self.totalCount) {
        self.totalCount = [UILabel new];
        self.totalCount.textAlignment = NSTextAlignmentRight;
        self.totalCount.font = [UIFont systemFontOfSize:JPRealValue(28)];
        self.totalCount.textColor = JP_NoticeText_Color;
        [self.bgView addSubview:self.totalCount];
    }
    self.totalCount.text = [NSString stringWithFormat:@"%@ 笔", total];
    
    if (!self.totalDealLab) {
        self.totalDealLab = [UILabel new];
        self.totalDealLab.text = @"总交易金额：";
        self.totalDealLab.font = [UIFont systemFontOfSize:JPRealValue(28)];
        self.totalDealLab.textColor = JP_NoticeText_Color;
        [self.bgView addSubview:self.totalDealLab];
    }
    if (!self.totalDealAmount) {
        self.totalDealAmount = [UILabel new];
        self.totalDealAmount.textAlignment = NSTextAlignmentRight;
        self.totalDealAmount.font = [UIFont systemFontOfSize:JPRealValue(28)];
        self.totalDealAmount.textColor = JP_NoticeText_Color;
        [self.bgView addSubview:self.totalDealAmount];
    }
    self.totalDealAmount.text = [NSString stringWithFormat:@"%@ 元", totalDealAmount];
    
    if (!self.totalBookedLab) {
        self.totalBookedLab = [UILabel new];
        self.totalBookedLab.text = @"总入账金额：";
        self.totalBookedLab.font = [UIFont systemFontOfSize:JPRealValue(28)];
        self.totalBookedLab.textColor = JP_NoticeText_Color;
        [self.bgView addSubview:self.totalBookedLab];
    }
    if (!self.totalBookedAmount) {
        self.totalBookedAmount = [UILabel new];
        self.totalBookedAmount.textAlignment = NSTextAlignmentRight;
        self.totalBookedAmount.font = [UIFont systemFontOfSize:JPRealValue(28)];
        self.totalBookedAmount.textColor = JP_NoticeText_Color;
        [self.bgView addSubview:self.totalBookedAmount];
    }
    self.totalBookedAmount.text = [NSString stringWithFormat:@"%@ 元", totalBookedAmount];
    
    if ([JPUserEntity sharedUserEntity].applyType == 1) {
        // K9
        [self.totalBookedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(30));
            make.bottom.equalTo(weakSelf.bgView.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(60)) / 2.0, 20));
        }];
        [self.totalBookedAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.totalBookedLab.mas_right);
            make.right.equalTo(weakSelf.bgView.mas_right).offset(-20);
            make.top.and.bottom.equalTo(weakSelf.totalBookedLab);
        }];
    } else {
        //  一码付
        if (!self.totalReductionLab) {
            self.totalReductionLab = [UILabel new];
            self.totalReductionLab.text = @"总优惠金额：";
            self.totalReductionLab.font = [UIFont systemFontOfSize:JPRealValue(28)];
            self.totalReductionLab.textColor = JP_NoticeText_Color;
            [self.bgView addSubview:self.totalReductionLab];
        }
        if (!self.totalReductionAmount) {
            self.totalReductionAmount = [UILabel new];
            self.totalReductionAmount.textAlignment = NSTextAlignmentRight;
            self.totalReductionAmount.font = [UIFont systemFontOfSize:JPRealValue(28)];
            self.totalReductionAmount.textColor = JP_NoticeText_Color;
            [self.bgView addSubview:self.totalReductionAmount];
        }
        self.totalReductionAmount.text = [NSString stringWithFormat:@"%@ 元", totalReductionAmount];
        
        [self.totalReductionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(30));
            make.bottom.equalTo(weakSelf.bgView.mas_bottom).offset(-5);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(60)) / 2.0, 20));
        }];
        [self.totalReductionAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.totalReductionLab.mas_right);
            make.right.equalTo(weakSelf.bgView.mas_right).offset(-20);
            make.top.and.bottom.equalTo(weakSelf.totalReductionLab);
        }];
        
        [self.totalBookedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.totalReductionLab.mas_left);
            make.bottom.equalTo(weakSelf.totalReductionLab.mas_top);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(60)) / 2.0, 20));
        }];
        [self.totalBookedAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.totalBookedLab.mas_right);
            make.right.equalTo(weakSelf.bgView.mas_right).offset(-20);
            make.top.and.bottom.equalTo(weakSelf.totalBookedLab);
        }];
    }
    [self.totalDealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalBookedLab.mas_left);
        make.bottom.equalTo(weakSelf.totalBookedLab.mas_top);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(60)) / 2.0, 20));
    }];
    [self.totalDealAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.totalDealLab);
        make.left.and.right.equalTo(weakSelf.totalBookedAmount);
    }];
    
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalBookedLab.mas_left);
        make.bottom.equalTo(weakSelf.totalDealLab.mas_top);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(60)) / 2.0, 20));
    }];
    [self.totalCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.totalLab);
        make.left.and.right.equalTo(weakSelf.totalDealAmount);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
