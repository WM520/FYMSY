//
//  JPDealDetailViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealDetailViewController.h"
#import "JPDealStateView.h"

@interface JPDealDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSArray <NSArray *>*titleArray;
@end

@implementation JPDealDetailViewController

- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.rowHeight = JPRealValue(60);
    }
    return _ctntView;
}

- (NSArray<NSArray *> *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@[@"应付金额", @"优惠金额"], @[@"交易时间", @"商户号", @"商户名称"], @[@"交易类型", @"支付方式"], @[@"订单号", @"平台流水号", @"应答码"], nil];
    }
    return _titleArray;
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
static NSString *const cellReuseIdentifier = @"cell";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = JP_DefaultsFont;
        cell.textLabel.textColor = JP_NoticeText_Color;
        cell.detailTextLabel.font = JP_DefaultsFont;
        cell.detailTextLabel.textColor = JP_Content_Color;
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
        cell.textLabel.textColor = JP_Content_Color;
        if (indexPath.row == 0) {
            //  应付金额
            NSString *totalAmt = nil;
            if ([JPUserEntity sharedUserEntity].applyType == 1) {
                totalAmt = self.newsModel.transactionMoney;
            } else {
                totalAmt = self.newsModel.totalAmt;
                if (!totalAmt || [totalAmt doubleValue] == 0) {
                    totalAmt = @"0";
                }
            }
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元", totalAmt]];
            
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:JPRealValue(36)] range:NSMakeRange(0, attrStr.length - 2)];
            
            cell.detailTextLabel.attributedText = attrStr;
        } else {
            //  优惠金额
            NSString *couponAmt = self.newsModel.couponAmt;
            if (!couponAmt || [couponAmt doubleValue] == 0) {
                couponAmt = @"0";
            }
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元", couponAmt]];
            
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:JPRealValue(36)] range:NSMakeRange(0, attrStr.length - 2)];
            
            cell.detailTextLabel.attributedText = attrStr;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //  交易时间
            cell.detailTextLabel.text = self.newsModel.transactionTime;
        } else if (indexPath.row == 1) {
            //  商户号
            cell.detailTextLabel.text = self.newsModel.tenantsNumber;
        } else {
            //  商户名称
//            NSString *tenantsName = self.newsModel.tenantsName;
//            if (!tenantsName || tenantsName.length <= 0) {
//                tenantsName = [JPUserEntity sharedUserEntity].merchantName;
//            }
            cell.detailTextLabel.text = self.newsModel.tenantsName;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //  支付方式
            cell.detailTextLabel.text = self.newsModel.transactionType;
        } else {
            //  交易方式
            cell.detailTextLabel.text = self.newsModel.payType;
        }
    } else {
        if (indexPath.row == 0) {
            //  订单号
            cell.detailTextLabel.text = self.newsModel.orderNumber;
        } else if (indexPath.row == 1) {
            //  种类编号
            cell.detailTextLabel.text = self.newsModel.serialNumber;
        } else {
            //  应答码
            cell.detailTextLabel.text = self.newsModel.answerBackCode;
        }
    }
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(270) : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JPRealValue(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPDealStateView *stateView = [JPDealStateView new];
    stateView.state = [self.newsModel.transactionResult isEqualToString:@"交易成功"] ? JPDealStateSuccess : JPDealStateFailed;
    stateView.moneyLab.text = [NSString stringWithFormat:@"%@ 元", self.newsModel.transactionMoney];
    return section == 0 ? stateView : nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)onBackItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCFContentInsetNotification object:nil];
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
