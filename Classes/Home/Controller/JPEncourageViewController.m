//
//  JPEncourageViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/7.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPEncourageViewController.h"
#import "JP_EncourageCell.h"
#import "JP_EncourageModel.h"

@interface JPEncourageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@end

static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";
static NSString *const headerViewReuseIdentifier = @"headerViewReuseIdentifier";

@implementation JPEncourageViewController

- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - 64} style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.rowHeight = JPRealValue(100);
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        
        [_ctntView registerClass:[JP_EncourageCell class] forCellReuseIdentifier:cellReuseIdentifier];
        [_ctntView registerClass:[JP_EncourageHeaderView class] forHeaderFooterViewReuseIdentifier:headerViewReuseIdentifier];
    }
    return _ctntView;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JP_EncourageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.dateLab.text = @"本月取得鼓励金";
        if (self.totalWeek) {
            cell.numLab.text = [NSString stringWithFormat:@"%@元", self.totalWeek];
        }
        cell.topLineView.hidden = YES;
    } else {
        JP_EncourageModel *model = self.dataSource[indexPath.row - 1];
        cell.dateLab.text = model.byMonth;
        if (self.totalAll) {
            cell.numLab.text = [NSString stringWithFormat:@"%@元", model.totalFees];
        }
    }
    if (indexPath.row == self.dataSource.count) {
        cell.bottomLineView.hidden = YES;
    }
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(472);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JP_EncourageHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewReuseIdentifier];
    headerView.merchantLab.text = [JPUserEntity sharedUserEntity].merchantName;
    headerView.encourageLab.text = [NSString stringWithFormat:@"%@元", self.totalAll];
    return headerView;
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
