//
//  JPNewHomeViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/2.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPHomeViewController.h"
#import "JP_HomeCell.h"

#import "JPQueryViewController.h"
#import "JPEncourageViewController.h"

#import "SJAxisView.h"
#import "SJChartLineView.h"
#import "SJLineChart.h"
#import "JPHomeModel.h"

#import "NSObject+JPExtention.h"
#import "JP_EncourageModel.h"

@interface JPHomeCell : UITableViewCell
@property (nonatomic, strong) UILabel *pointLab;
@property (nonatomic, strong) UILabel *trendLab;
/** 折线图*/
@property (nonatomic, strong) SJLineChart *lineChart;
/** 提示暂无数据*/
@property (nonatomic, strong) UIImageView *dataView;
@property (nonatomic, strong) NSArray <NSDictionary *>*pointDataSource;
@end

@implementation JPHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}

- (void)handleUserInterface {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.pointLab];
    [self addSubview:self.trendLab];
    [self addSubview:self.lineChart];
    [self addSubview:self.dataView];
    //  暂无数据提示默认隐藏
    //    self.dataView.hidden = YES;
}
#pragma mark - 设置dataSource数据源，画折线图
- (void)setPointDataSource:(NSArray *)pointDataSource {
    // !!!: 判断数据源是否有数据
    if (pointDataSource.count > 0) {
        self.lineChart.hidden = NO;
        self.dataView.hidden = YES;
    } else {
        self.lineChart.hidden = YES;
        self.dataView.hidden = NO;
        return;
    }
    // !!!: 设置纵坐标及其最大值
    NSMutableArray *amountArr = @[].mutableCopy;
    for (JPHomeChartModel *model in pointDataSource) {
        double amount = [model.sumDayTransAt doubleValue];
        [amountArr addObject:[NSNumber numberWithDouble:amount]];
    }
    CGFloat maxValue = [[amountArr valueForKeyPath:@"@max.floatValue"] floatValue];
    
    int value = (int)ceilf(maxValue);
    
    // 最大值
    //  设置纵坐标
    NSMutableArray *values = @[].mutableCopy;
    if (value >= 1000) {
        
        self.lineChart.maxValue = value;
        
        [values addObject:@"0"];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0 * 2)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0 * 3)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0 * 4)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value)]];
    } else {
        
        self.lineChart.maxValue = maxValue;
        
        [values addObject:@"0"];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 2]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 3]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 4]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 5]];
    }
    
    self.lineChart.yMarkTitles = values;
    
    // !!!: 设置横坐标
    //  获取最近30天的日期数组
    NSArray *lastDays = [NSDate getLastDaysWithFormat:@"M月dd日"];
    self.lineChart.xMarkTitles = lastDays;
    
    NSMutableArray *defaultsArray = @[].mutableCopy;
    for (NSString *date in lastDays) {
        NSMutableDictionary *defaultsDic = @{}.mutableCopy;
        [defaultsDic setObject:date forKey:@"recCrtDt"];
        //  默认金额为0
        [defaultsDic setObject:@"0" forKey:@"sumDayTransAt"];
        [defaultsArray addObject:defaultsDic];
    }
    //  模型转化为json
    NSArray *arr = [JPHomeChartModel idFromObject:pointDataSource];
    //    NSLog(@"%@ - %@", defaultsArray, arr);
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *dic = arr[i];
        NSString *date = dic[@"recCrtDt"];
        /**数据源中数据在横轴的位置，即点的数组中的位置*/
        if ([lastDays containsObject:date]) {
            NSInteger index = [lastDays indexOfObject:date];
            [defaultsArray replaceObjectAtIndex:index withObject:dic];
        }
    }
    //  设置点的数据源
    [self.lineChart setXMarkTitlesAndValues:defaultsArray titleKey:@"recCrtDt" valueKey:@"sumDayTransAt"]; // X轴刻度标签及相应的值
    //  把点画到折线图上
    [self.lineChart mapping];
}

- (UILabel *)pointLab {
    if (!_pointLab) {
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12.5, 5, 5)];
        _pointLab.backgroundColor = JPBaseColor;
        _pointLab.layer.cornerRadius = 2.5;
        _pointLab.layer.masksToBounds = YES;
    }
    return _pointLab;
}

- (UILabel *)trendLab {
    if (!_trendLab) {
        _trendLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 200, 20)];
        _trendLab.text = @"累计交易金额趋势";
        _trendLab.textColor = [UIColor colorWithHexString:@"666666"];
        _trendLab.font = [UIFont systemFontOfSize:14];
    }
    return _trendLab;
}

- (SJLineChart *)lineChart {
    if (!_lineChart) {
        _lineChart = [[SJLineChart alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 260)];
    }
    return _lineChart;
}
- (UIImageView *)dataView {
    if (!_dataView) {
        _dataView = [UIImageView new];
        _dataView.center = CGPointMake(kScreenWidth / 2.0, 150);
        _dataView.bounds = CGRectMake(0, 0, JPRealValue(241), JPRealValue(228));
        _dataView.image = [UIImage imageNamed:@"jp_nHome_noData"];
    }
    return _dataView;
}
@end

@interface JPHomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) JPHomeModel *homeModel;
/** 折线图点的数值*/
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *totalWeek;

@property (nonatomic, copy) NSString *totalAll1;
@property (nonatomic, copy) NSString *totalWeek1;
@property (nonatomic, strong) NSMutableArray *encourageData;
@end

@implementation JPHomeViewController

#pragma mark - request
- (void)createRequest {
    
    if ([JPUserEntity sharedUserEntity].merchantNo) {
        
        weakSelf_declare;
        [SVProgressHUD showWithStatus:@"加载中..."];
        
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"merchantNo"] = [JPUserEntity sharedUserEntity].merchantNo;
        
        //  获取开始日期：30天之前的日期 yyyyMMdd
        NSDate *lastDate = [NSDate dateWithTimeIntervalSinceNow:-30 * 24 * 60 * 60];
        params[@"startDate"] = [NSDate stringFromDate:lastDate withFormat:@"yyyyMMdd"];
        
        //  获取折线图数据
        [JPNetworking postUrl:[NSString stringWithFormat:@"%@%@", JPServerUrl, jp_getSumDayTransAt_url]
                       params:params
                     progress:nil
                     callback:^(id resp) {
            //  处理数据的代码
            JPLog(@"%@", resp);
            if ([resp isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)resp;
                NSArray *keys = dic.allKeys;
                
                if ([keys containsObject:@"flowList"]) {
                    if ([dic[@"flowList"] isKindOfClass:[NSArray class]]) {
                        NSArray *arr = resp[@"flowList"];
                        if (arr.count > 0) {
                            [weakSelf.dataSource removeAllObjects];
                        }
                        for (NSDictionary *data in arr) {
                            JPHomeChartModel *model = [JPHomeChartModel yy_modelWithDictionary:data];
                            [weakSelf.dataSource addObject:model];
                        }
                    }
                }
                if ([keys containsObject:@"totalWeek"]) {
                    weakSelf.totalWeek = dic[@"totalWeek"];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:resp];
            }
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        //  获取统计数据
        NSMutableDictionary *params1 = @{}.mutableCopy;
        params1[@"merchantNo"] = [JPUserEntity sharedUserEntity].merchantNo;
        
        [JPNetworking postUrl:[NSString stringWithFormat:@"%@%@", JPServerUrl, jp_encourage_url]
                       params:params1
                     progress:nil
                     callback:^(id resp) {
            JPLog(@"%@", resp);
            if ([resp isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)resp;
                NSArray *keys = dic.allKeys;
                if ([keys containsObject:@"fees"]) {
                    
                    NSArray *fees = dic[@"fees"];
                    [weakSelf.encourageData removeAllObjects];
                    for (NSDictionary *data in fees) {
                        JP_EncourageModel *model = [JP_EncourageModel yy_modelWithDictionary:data];
                        [weakSelf.encourageData addObject:model];
                    }
                }
                if ([keys containsObject:@"totalAll"]) {
                    weakSelf.totalAll1 = dic[@"totalAll"];
                }
                if ([keys containsObject:@"totalWeek"]) {
                    weakSelf.totalWeek1 = dic[@"totalWeek"];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:resp];
            }
            dispatch_group_leave(group);
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf.ctntView reloadData];
            [weakSelf.ctntView.mj_header endRefreshing];
        });
    } else {
        //  新进件初审未通过的商户，没有merchantNo
        [self.ctntView reloadData];
        [self.ctntView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    }
}

#pragma mark - lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - 49} style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        CGFloat insetY = isPhoneX ? 0.f : -20.f;
        _ctntView.contentInset = UIEdgeInsetsMake(insetY, 0, 0, 0);
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.showsVerticalScrollIndicator = NO;
        
        [_ctntView registerClass:[JPHomeCell class] forCellReuseIdentifier:lineViewCell];
        [_ctntView registerClass:[JP_HomeCell class] forCellReuseIdentifier:normalCell];
    }
    return _ctntView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)encourageData {
    if (!_encourageData) {
        _encourageData = @[].mutableCopy;
    }
    return _encourageData;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.ctntView];
    [self createRequest];
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf createRequest];
    }];
    
//    [self.ctntView.mj_header beginRefreshing];
}

#pragma mark - tableViewDataSource

static NSString *lineViewCell = @"lineViewCell";
static NSString *normalCell = @"normalCell";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [JPUserEntity sharedUserEntity].applyType == 1 ? 3 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return section == 1 ? 2 : 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JPHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:lineViewCell forIndexPath:indexPath];
        cell.pointDataSource = self.dataSource;
        
        return cell;
    } else {
        
        JP_HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            cell.cellType = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *lastDealMoney = nil;
            for (JPHomeChartModel *model in self.dataSource) {
                NSString *lastDay = [NSDate stringFromDate:[NSDate getYesterday] withFormat:@"M月dd日"];
                if ([model.recCrtDt isEqualToString:lastDay]) {
                    lastDealMoney = [NSString stringWithFormat:@"%@", model.sumDayTransAt];
                }
            }
            if (!lastDealMoney) {
                lastDealMoney = @"0";
            }
            cell.sumLab.text = lastDealMoney;
        } else if (indexPath.section == 2) {
            
            if ([JPUserEntity sharedUserEntity].applyType == 1) {
                cell.cellType = 2;
            } else {
                cell.cellType = 1;
                if (!self.totalWeek) {
                    self.totalWeek = @"0";
                }
                cell.sumLab.text = [NSString stringWithFormat:@"%@", self.totalWeek];
            }
        } else {
            cell.cellType = 2;
        }
        return cell;
    }
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 300 : JPRealValue(170);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        
        if ([JPUserEntity sharedUserEntity].applyType == 1) {
            JPQueryViewController *queryVC = [[JPQueryViewController alloc] init];
            queryVC.hidesBottomBarWhenPushed = YES;
            queryVC.navigationItem.title = @"交易查询";
            weakSelf_declare;
            [JPNetworkUtils netWorkState:^(NSInteger netState) {
                switch (netState) {
                    case 1:
                    case 2: {
                        
                        [MobClick event:@"home_dealSearch"];
                        [weakSelf.navigationController pushViewController:queryVC animated:YES];
                    }
                        break;
                    default: {
                        [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
                    }
                        break;
                }
            }];
        } else {
            [MobClick event:@"home_encourage"];
            JPEncourageViewController *encourageVC = [JPEncourageViewController new];
            encourageVC.navigationItem.title = @"鼓励金数据统计";
            encourageVC.hidesBottomBarWhenPushed = YES;
            if ([JPUserEntity sharedUserEntity].merchantNo) {
                if (self.encourageData && self.totalWeek1 && self.totalAll1) {
                    encourageVC.dataSource = self.encourageData;
                    encourageVC.totalAll = self.totalAll1;
                    encourageVC.totalWeek = self.totalWeek1;
                    [self.navigationController pushViewController:encourageVC animated:YES];
                } else {
                    [SVProgressHUD showInfoWithStatus:JPServerNoNet];
                }
            } else {
                encourageVC.dataSource = @[].mutableCopy;
                encourageVC.totalAll = @"0";
                encourageVC.totalWeek = @"0";
                
                [self.navigationController pushViewController:encourageVC animated:YES];
//                [SVProgressHUD showInfoWithStatus:@"账户状态异常！"];
            }
        }
    } else if (indexPath.section == 3) {
        
        JPQueryViewController *queryVC = [[JPQueryViewController alloc] init];
        queryVC.hidesBottomBarWhenPushed = YES;
        queryVC.navigationItem.title = @"交易查询";
        weakSelf_declare;
        [JPNetworkUtils netWorkState:^(NSInteger netState) {
            switch (netState) {
                case 1:
                case 2:
                {
                    [weakSelf.navigationController pushViewController:queryVC animated:YES];
                }
                    break;
                default: {
                    [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
                }
                    break;
            }
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(176) : 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JPRealValue(28);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = JP_viewBackgroundColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, JPRealValue(176))];
    bgView.backgroundColor = JPBaseColor;
    [headerView addSubview:bgView];
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"jp_home_csns_band"];
    [bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.centerY.equalTo(bgView.mas_centerY).offset(JPRealValue(10));
        //        make.size.mas_equalTo(CGSizeMake(JPRealValue(502), JPRealValue(71)));
    }];
    return section == 0 ? headerView : nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = JP_viewBackgroundColor;
    return footerView;
}

#pragma mark - attributeString
- (NSMutableAttributedString *)attributeStrWithOriginStr:(NSString *)originStr {
    
//    NSString *lastDayStr = nil;
//    double originMoney = [originStr doubleValue];
//    if (originMoney >= 100000000.0) {
//        lastDayStr = [NSString stringWithFormat:@"%.2f万元", originMoney / 10000];
//    } else {
//        lastDayStr = [NSString stringWithFormat:@"%.2f元", originMoney];
//    }
//    
//    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:lastDayStr];
//    
//    NSArray *arr = [lastDayStr componentsSeparatedByString:@"."];
//    NSRange range = [lastDayStr rangeOfString:[arr firstObject]];
    
    double originMoney = [originStr doubleValue];
    NSString *originMoneyStr = [NSString stringWithFormat:@"%.2f", originMoney];
    NSString *lastDayStr = [NSString stringWithFormat:@"%@元", originMoneyStr];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:lastDayStr];
    
    NSRange range = [lastDayStr rangeOfString:originMoneyStr];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:JPRealValue(60)] range:range];
    return attrStr;
//    return [NSString attributeString:lastDayStr rangeStr:[arr firstObject] rangeColor:JP_Content_Color rangeFont:JP_DefaultsFont];
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
