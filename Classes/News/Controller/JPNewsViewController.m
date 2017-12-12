//
//  JPNewsViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNewsViewController.h"
#import "JPDealDetailViewController.h"
#import "JPNewsHeaderView.h"
#import "JPNewsCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "IBDataBase.h"
#import "IBNewsModel.h"

@interface JPNewsViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, getter=isLoading) BOOL loading;
@end

static NSString *const headerReuseIdentifier = @"headerReuseIdentifier";
static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";

@implementation JPNewsViewController

- (void)setLoading:(BOOL)loading {
    if (self.isLoading == loading) {
        return;
    }
    
    _loading = loading;
    
    [self.ctntView reloadEmptyDataSet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFContentInsetNotification object:nil];
}

#pragma mark - 获取DataBase数据
- (void)getDataFromDataBase {
    
    NSMutableArray *dataArray = [[IBDataBase sharedDataBase] getAllPerson];
    NSMutableArray *smallArray = @[].mutableCopy;
    if (dataArray.count > 50) {
        smallArray = [dataArray subarrayWithRange:NSMakeRange(0, 50)].mutableCopy;
    } else {
        smallArray = dataArray;
    }
    
    NSArray *sortArray = [smallArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        IBNewsModel *pModel1 = obj1;
        IBNewsModel *pModel2 = obj2;
        
        NSDate *date1 = [NSDate dateFromString:pModel1.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date2 = [NSDate dateFromString:pModel2.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        if ([date1 compare:date2] == NSOrderedDescending) {
            //不使用intValue比较无效
            return NSOrderedAscending;//降序
        } else if ([date1 compare:date2] == NSOrderedAscending) {
            return NSOrderedDescending;//升序
        } else {
            return NSOrderedSame;//相等
        }
    }];
    
    if (sortArray.count > 0) {
        //  !!!:    对plist获取到的数组按时间再次分组 分配给tableView数据源
        NSMutableArray *timeArr = @[].mutableCopy;
        [sortArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            IBNewsModel *model = obj;
            NSDate *modelDate = [NSDate dateFromString:model.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *modelTimeString = [NSDate stringFromDate:modelDate withFormat:@"yyyy-MM-dd HH"];
            [timeArr addObject:modelTimeString];
        }];
        //使用asset把timeArr的日期去重
        NSSet *set = [NSSet setWithArray:timeArr];
        NSArray *userArray = [set allObjects];
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
        //按日期降序排列的日期数组
        NSArray *myary = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
        //此时得到的myary就是按照时间降序排列拍好的数组
        //遍历myary把_titleArray按照myary里的时间分成几个组每个组都是空的数组
        [myary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *arr = @[].mutableCopy;
            [self.dataSource addObject:arr];
            
        }];
        //遍历_dataArray取其中每个数据的日期看看与myary里的那个日期匹配就把这个数据装到_titleArray 对应的组中
        [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            IBNewsModel *model = obj;
            NSDate *modelDate = [NSDate dateFromString:model.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *modelTimeString = [NSDate stringFromDate:modelDate withFormat:@"yyyy-MM-dd HH"];
            for (NSString *str in myary) {
                if([str isEqualToString:modelTimeString]) {
                    NSMutableArray *arr = [self.dataSource objectAtIndex:[myary indexOfObject:str]];
                    [arr addObject:model];
                }
            }
        }];
    }
//    self.ctntView.mj_header.hidden = dataArray.count <= 0;
    self.ctntView.mj_header.hidden = smallArray.count <= 0;
    [self.ctntView reloadData];
    [self.ctntView.mj_header endRefreshing];
}

#pragma mark - lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.rowHeight = JPRealValue(630);
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        [_ctntView registerClass:[JPNewsHeaderView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
        [_ctntView registerClass:[JPNewsCell class] forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _ctntView;
}
//  数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

#pragma mark - view
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFContentInsetNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.ctntView];
    
    self.ctntView.emptyDataSetSource = self;
    self.ctntView.emptyDataSetDelegate = self;
    
    // 删除单元格分隔线的一个小技巧
    self.ctntView.tableFooterView = [UIView new];
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataSource removeAllObjects];
        [weakSelf getDataFromDataBase];
        JPLog(@"data - %@", [[IBDataBase sharedDataBase] getAllPerson]);
    }];
    self.ctntView.mj_header.hidden = YES;
    [self.ctntView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.ctntView.mj_header beginRefreshing];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFContentInsetNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf getDataFromDataBase];
        weakSelf.ctntView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        weakSelf.ctntView.frame = (CGRect){0, 0, kScreenWidth, kScreenHeight - 64 - 49};
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.newsModel = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - tableVieDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"news_detailed"];
    JPDealDetailViewController *dealDetailVC = [[JPDealDetailViewController alloc] init];
    dealDetailVC.navigationItem.title = @"交易详情";
    dealDetailVC.hidesBottomBarWhenPushed = YES;
    dealDetailVC.newsModel = self.dataSource[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:dealDetailVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPNewsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    IBNewsModel *newsModel = self.dataSource[section][0];
    headerView.timeString = newsModel.transactionTime;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - DZNEmptyDataSetSource
#pragma mark 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        // 圆形加载图片
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    } else {
        // 默认静态图片
        return [UIImage imageNamed:@"jp_result_noNews"];
    }
}

#pragma mark 图片旋转动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

#pragma mark - DZNEmptyDataSetDelegate
#pragma mark 是否开启动画
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.isLoading;
}

#pragma mark 空白页面被点击时刷新页面
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    // 空白页面被点击时开启动画，reloadEmptyDataSet
    self.loading = YES;
    [self.ctntView.mj_header beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 关闭动画，reloadEmptyDataSet
        self.loading = NO;
    });
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"正在加载，请稍后...";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor lightGrayColor], NSParagraphStyleAttributeName:paragraph};
    
    return self.loading ? [[NSAttributedString alloc] initWithString:text attributes:attributes] : nil;
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
