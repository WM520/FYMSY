//
//  JPQueryViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPQueryViewController.h"
#import "JPDealFlowViewController.h"
#import "KYSDatePickerView.h"
#import "JPDealMesRequest.h"
#import "JPDealMesModel.h"

@interface JPQueryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSArray <NSArray *>*nameArray;
@property (nonatomic, strong) NSArray <NSArray *>*detailedArray;
@property (nonatomic, strong) UIView *bgView;
/**
 列表筛选数据
 */
@property (nonatomic, strong) JPDealMesModel *dealModel;
@property (nonatomic, assign) NSInteger merNameIndex;

@end

@implementation JPQueryViewController
#pragma mark - lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorColor = JP_LineColor;
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
    }
    return _ctntView;
}

- (NSArray<NSArray *> *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSArray arrayWithObjects:@[@"开始时间", @"结束时间"], @[@"交易状态", @"支付方式"], nil];
    }
    return _nameArray;
}

- (NSArray<NSArray *> *)detailedArray {
    if (!_detailedArray) {
        _detailedArray = [NSArray arrayWithObjects:@[[NSDate getToday], [NSDate getToday]], @[@"交易成功", @"全部"], nil];
    }
    return _detailedArray;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _bgView;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JP_viewBackgroundColor;
    
    [self.view addSubview:self.ctntView];
    
    weakSelf_declare;
    //  请求商户可查询信息
    [JPDealMesRequest showCondFLowCallback:^(id resp) {
        JPLog(@"请求商户可查询信息 - %@", resp);
        if ([resp isKindOfClass:[NSString class]]) {
            [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
        } else {
            weakSelf.canSelect = YES;
            weakSelf.dealModel = [JPDealMesModel yy_modelWithJSON:resp];
            [weakSelf.ctntView reloadData];
        }
    }];
}

#pragma mark - tableViewDataSource
static NSString *const businessNameCellReuseIdentifier = @"businessNameCell";
static NSString *const normalCellReuseIdentifier = @"normalCell";
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:businessNameCellReuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:businessNameCellReuseIdentifier];
            cell.textLabel.text = @"商户名称";
            cell.textLabel.font = JP_DefaultsFont;
            cell.detailTextLabel.font = JP_DefaultsFont;
        }
        if ([self.dealModel.merchantType isEqualToString:@"2"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"全部";
        } else {
//            NSLog(@"dealModel - %@", self.dealModel);
            if (self.dealModel.mercList.count > 0) {
                JPDealBusinessNameModel *model = self.dealModel.mercList[0];
                cell.detailTextLabel.numberOfLines = 0;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.detailTextLabel.text = model.merchantName;
            } else {
                cell.detailTextLabel.text = [JPUserEntity sharedUserEntity].merchantName;
            }
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellReuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellReuseIdentifier];
            cell.textLabel.font = JP_DefaultsFont;
            cell.detailTextLabel.font = JP_DefaultsFont;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.nameArray[indexPath.section - 1][indexPath.row];
            cell.detailTextLabel.text = self.detailedArray[indexPath.section - 1][indexPath.row];
        }
        
        return cell;
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {

        if ([self.dealModel.merchantType isEqualToString:@"2"]) {
            
            if (self.dealModel.mercList.count <= 0) {
                return;
            }
            [MobClick event:@"deal_merchantName"];
            
            NSMutableArray *arr = @[].mutableCopy;
            [arr addObject:@"全部"];
            for (JPDealBusinessNameModel *model in self.dealModel.mercList) {
//                [arr addObject:model.merchantName];
                NSString *merNo = [model.merchantNo substringWithRange:NSMakeRange(model.merchantNo.length - 5, 5)];
                [arr addObject:[NSString stringWithFormat:@"%@(No.%@)", model.merchantName, merNo]];
            }
            //注意数据类型是数组包含数组
            weakSelf_declare;
            [KYSNormalPickerView KYSShowWithDataArray:@[arr] completeBlock:^(NSArray * selectedArray) {
                
                weakSelf.merNameIndex = [[selectedArray lastObject] integerValue];
                NSString *selectStr = [arr objectAtIndex:weakSelf.merNameIndex];
                
                cell.detailTextLabel.text = selectStr;
                
//                NSInteger index = [[selectedArray lastObject] integerValue];
//                NSString *selectStr = [arr objectAtIndex:index];
                JPLog(@"selectStr -- %@", selectStr);
                
//                weakSelf.merNameIndex = [[selectedArray lastObject] integerValue];
//                cell.detailTextLabel.text = selectStr;
            }];
        }
    } else {
        if (indexPath.section == 1) {
            
            UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            
            [KYSDatePickerView KYSShowWithCompleteBlock:^(NSDate *date) {
                JPLog(@"%@",[NSDate stringFromDate:date withFormat:@"yyyy/M/dd"]);
                cell.detailTextLabel.text = [NSDate stringFromDate:date withFormat:@"yyyy/M/dd"];
                
                NSDate *startDate = [NSDate dateFromString:cell0.detailTextLabel.text withFormat:@"yyyy/M/dd"];
                NSDate *endDate = [NSDate dateFromString:cell1.detailTextLabel.text withFormat:@"yyyy/M/dd"];
                
                //  开始时间距结束时间差
                NSTimeInterval timeDistance = [endDate timeIntervalSinceDate:startDate];
                
                if (timeDistance > 30 * 24 * 60 * 60) {
                    [SVProgressHUD showInfoWithStatus:@"开始时间和结束时间相差过长，系统默认为30天"];
                    //  若开始时间距结束时间超过30天，则endDate = 开始时间 + 30天
                    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:-timeDistance + 30 * 24 * 60 * 60];
                    NSLog(@"结束时间 - %@", [NSDate stringFromDate:endTime withFormat:@"yyyy/M/dd"]);
                    cell1.detailTextLabel.text = [NSDate stringFromDate:endTime withFormat:@"yyyy/M/dd"];
                } else {
                    //  否则，endDate不变
                }
                if ([startDate compare:endDate] == 1) {
                    [SVProgressHUD showInfoWithStatus:@"结束时间早于开始时间，系统将默认为开始时间"];
                    NSDate *tempDate = [endDate laterDate:startDate];
                    
                    cell1.detailTextLabel.text = [NSDate stringFromDate:tempDate withFormat:@"yyyy/M/dd"];
                }
            }];
        } else {
            if (indexPath.row == 0) {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:@"全部"];
                for (JPDealStateModel *model in self.dealModel.tranStatList2) {
                    [arr addObject:model.name];
                }
//                NSArray *dataList = @[@"全部", @"交易成功", @"交易失败", @"已冲正"];
                //注意数据类型是数组包含数组
                [KYSNormalPickerView KYSShowWithDataArray:@[arr] completeBlock:^(NSArray * selectedArray) {
                    JPLog(@"%@",selectedArray);
                    NSInteger index = [[selectedArray lastObject] integerValue];
                    NSString *selectStr = [arr objectAtIndex:index];
                    JPLog(@"selectStr -- %@", selectStr);
                    
                    cell.detailTextLabel.text = selectStr;
                }];
            } else {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:@"全部"];
                for (JPDealPayWayModel *model in self.dealModel.payList2) {
                    [arr addObject:model.name];
                }
//                NSArray *dataList = @[@"请选择交易方式", @"支付宝", @"微信", @"借记卡", @"贷记卡"];
                //注意数据类型是数组包含数组
                [KYSNormalPickerView KYSShowWithDataArray:@[arr] completeBlock:^(NSArray * selectedArray) {
                    JPLog(@"%@",selectedArray);
                    NSInteger index = [[selectedArray lastObject] integerValue];
                    NSString *selectStr = [arr objectAtIndex:index];
                    JPLog(@"selectStr -- %@", selectStr);
                    
                    cell.detailTextLabel.text = selectStr;
                }];
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? JPRealValue(150) : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(12);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 100 : 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    
    UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    queryButton.titleLabel.font = JP_DefaultsFont;
    
    [queryButton setTitle:@"交易流水查询" forState:UIControlStateNormal];
    queryButton.layer.cornerRadius = 5;
    queryButton.layer.masksToBounds = YES;
    if (self.canSelect) {
        queryButton.userInteractionEnabled = YES;
        queryButton.backgroundColor = JPBaseColor;
    } else {
        queryButton.userInteractionEnabled = NO;
        queryButton.backgroundColor = JP_LayerColor;
    }
    [queryButton addTarget:self action:@selector(queryDealFlowClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:queryButton];
    
    [queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(JPRealValue(40));
        make.top.equalTo(footerView.mas_top).offset(JPRealValue(60));
        make.right.equalTo(footerView.mas_right).offset(JPRealValue(-40));
        make.height.equalTo(@(JPRealValue(80)));
    }];
    
    return section == 2 ? footerView : nil;
}

#pragma mark - action
- (void)queryDealFlowClick:(UIButton *)sender {
    
    if ([JPUserEntity sharedUserEntity].merchantNo == nil || self.dealModel.mercList.count <= 0) {
        [SVProgressHUD showInfoWithStatus:@"账户状态异常！"];
        return;
    }
    [MobClick event:@"deal_dealFlowSearch"];
    
    UITableViewCell *cell00 = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *businessName = cell00.detailTextLabel.text;
    
    UITableViewCell *cell10 = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *startDate = cell10.detailTextLabel.text;
    NSDate *startD = [NSDate dateFromString:startDate withFormat:@"yyyy/M/dd"];
    startDate = [NSDate stringFromDate:startD withFormat:@"yyyyMMdd"];
    
    UITableViewCell *cell11 = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    NSString *endDate = cell11.detailTextLabel.text;
    NSDate *endD = [NSDate dateFromString:endDate withFormat:@"yyyy/M/dd"];
    endDate = [NSDate stringFromDate:endD withFormat:@"yyyyMMdd"];
    
    UITableViewCell *cell20 = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    NSString *dealType = cell20.detailTextLabel.text;
    
    
    UITableViewCell *cell21 = [self.ctntView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    NSString *payWay = cell21.detailTextLabel.text;
    
    //  查询交易流水
    JPDealFlowViewController *dealFlowVC = [[JPDealFlowViewController alloc] init];
    dealFlowVC.navigationItem.title = @"交易流水";
    dealFlowVC.msgFlag = 0;
    if (self.dealModel.merchantType.integerValue == 2) {
        //  总店
        if ([businessName isEqualToString:@"全部"]) {
            dealFlowVC.mercFlag = 0;
            dealFlowVC.merchantNo = [JPUserEntity sharedUserEntity].merchantNo;
            dealFlowVC.merchantId = [JPUserEntity sharedUserEntity].merchantId.integerValue;
        } else {
            dealFlowVC.mercFlag = 1;
            
            JPDealBusinessNameModel *merModel = self.dealModel.mercList[self.merNameIndex - 1];
            dealFlowVC.merchantNo = merModel.merchantNo;
            dealFlowVC.merchantId = merModel.merchantId.integerValue;
        }
    } else {
        dealFlowVC.mercFlag = 1;
        dealFlowVC.merchantNo = [JPUserEntity sharedUserEntity].merchantNo;
        dealFlowVC.merchantId = [JPUserEntity sharedUserEntity].merchantId.integerValue;
    }
    
//    if ([businessName isEqualToString:@"全部"]) {
//        dealFlowVC.mercFlag = 0;
//        dealFlowVC.merchantNo = [JPUserEntity sharedUserEntity].merchantNo;
//        dealFlowVC.merchantId = [[JPUserEntity sharedUserEntity].merchantId integerValue];
//    } else {
//        dealFlowVC.mercFlag = 1;
//
//        NSArray *typeArr = self.dealModel.mercList;
//        for (JPDealBusinessNameModel *model in typeArr) {
//            if ([model.merchantName isEqualToString:businessName]) {
//                dealFlowVC.merchantNo = model.merchantNo;
//                dealFlowVC.merchantId = [model.merchantId integerValue];
//            }
//        }
//    }
    
//    dealFlowVC.merchantNo = [JPUserEntity sharedUserEntity].merchantNo;
//    dealFlowVC.merchantId = [[JPUserEntity sharedUserEntity].merchantId integerValue];
    dealFlowVC.userName = [JPUserEntity sharedUserEntity].jp_user;
    dealFlowVC.startTime = startDate;
    dealFlowVC.endTime = endDate;
    
    dealFlowVC.isRed = ![dealType isEqualToString:@"全部"];
    if ([dealType isEqualToString:@"全部"]) {
        dealFlowVC.type = @"";
    } else {
        NSArray *typeArr = self.dealModel.tranStatList2;
        for (JPDealStateModel *model in typeArr) {
            if ([model.name isEqualToString:dealType]) {
                dealFlowVC.type = model.type;
            }
        }
    }
    
    if ([payWay isEqualToString:@"全部"]) {
        dealFlowVC.payChannel = @"";
    } else {
        for (JPDealPayWayModel *model in self.dealModel.payList2) {
            if ([model.name isEqualToString:payWay]) {
                dealFlowVC.payChannel = model.payChannel;
            }
        }
    }
    
    if (self.dealModel.mercList.count > 0) {
        JPDealBusinessNameModel *model = self.dealModel.mercList[0];
        dealFlowVC.businessShortName = model.merchantName;
    } else {
        dealFlowVC.businessShortName = [JPUserEntity sharedUserEntity].merchantName;
    }
    
    weakSelf_declare;
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2:
            {
                [weakSelf.navigationController pushViewController:dealFlowVC animated:YES];
            }
                break;
            default: {
                [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
            }
                break;
        }
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
