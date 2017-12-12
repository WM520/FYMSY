//
//  JPAnnouncementViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/27.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPAnnouncementViewController.h"
#import "JPInfoModel.h"
#import "JPLastestNewsDetailViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface JPAnnounceCell : UITableViewCell
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *showDetailLab;
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) JPInfoModel *infoModel;
@end
@implementation JPAnnounceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}
- (void)handleUserInterface {
    if (!self.logoView) {
        self.logoView = [UIImageView new];
        self.logoView.image = [UIImage imageNamed:@"jp_notice_logo"];
        [self.contentView addSubview:self.logoView];
    }
    if (!self.titleLab) {
        self.titleLab = [UILabel new];
        self.titleLab.text = @"服务商系统升级";
        self.titleLab.font = JP_DefaultsFont;
        self.titleLab.textColor = [UIColor colorWithHexString:@"333333"];
        [self.contentView addSubview:self.titleLab];
    }
    if (!self.timeLab) {
        self.timeLab = [UILabel new];
        self.timeLab.text = @"2017/05/26";
        self.timeLab.font = JP_DefaultsFont;
        self.timeLab.textColor = JP_NoticeText_Color;
        self.timeLab.textAlignment = NSTextAlignmentRight;
        // !!!:测试
//        self.timeLab.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.timeLab];
    }
    if (!self.contentLab) {
        self.contentLab = [UILabel new];
        self.contentLab.text = @"把思考的骄傲是肯定会来考核分为两节课后而我蝴蝶了会务费考虑好基尔霍夫回家看到是非得失大杀戮空间合计合计保温壶；华为；蜂王浆；";
        self.contentLab.numberOfLines = 2;
        self.contentLab.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLab.font = JP_DefaultsFont;
        self.contentLab.textColor = JP_NoticeText_Color;
        [self.contentView addSubview:self.contentLab];
    }
    if (!self.showDetailLab) {
        self.showDetailLab = [UILabel new];
        self.showDetailLab.text = @"查看详情";
        self.showDetailLab.font = JP_DefaultsFont;
        self.showDetailLab.textColor = JP_Content_Color;
        [self.contentView addSubview:self.showDetailLab];
    }
    if (!self.indicatorView) {
        self.indicatorView = [UIImageView new];
        self.indicatorView.image = [UIImage imageNamed:@"jp_news_indicator"];
        [self.contentView addSubview:self.indicatorView];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    weakSelf_declare;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(30));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(44), JPRealValue(44)));
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.centerY.equalTo(weakSelf.logoView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.logoView.mas_centerY);
        make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.timeLab.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(JPRealValue(24));
        make.right.equalTo(weakSelf.timeLab.mas_right);
        make.height.equalTo(@(JPRealValue(70)));
    }];
    [self.showDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLab.mas_bottom).offset(JPRealValue(32));
        make.left.equalTo(weakSelf.contentLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.showDetailLab.mas_centerY);
        make.right.equalTo(weakSelf.contentLab.mas_right);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(13), JPRealValue(21)));
    }];
}

- (void)setInfoModel:(JPInfoModel *)infoModel {
    self.titleLab.text = infoModel.title;
    
    NSString *timeStr = infoModel.createTimeSt;
    NSString *time = [NSDate stringFromDate:[NSDate dateFromString:timeStr withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];
    self.timeLab.text = time;
    
    NSString *str = infoModel.content;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.contentLab.text = str;
}
@end

@interface JPAnnouncementViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, getter=isLoading) BOOL loading;
@end

static NSString *announceCellReuseIdentifier = @"announceCell";

@implementation JPAnnouncementViewController

- (void)setLoading:(BOOL)loading {
    if (self.isLoading == loading) {
        return;
    }
    
    _loading = loading;
    
    [self.ctntView reloadEmptyDataSet];
}

#pragma mark - 断网
- (void)outsideNetworkWithStartRow:(NSInteger)startRow {
    weakSelf_declare;
    //  监控网络状态变化
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2:
            {
                [weakSelf getInfoWithStartRow:startRow];
            }
                break;
            default: {
                JPLog(@"没网");
                [weakSelf.ctntView.mj_header endRefreshing];
            }
                break;
        }
    }];
}
#pragma mark - request
- (void)getInfoWithStartRow:(NSInteger)startRow {
    NSString *Url = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_getInfoList_url];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(startRow) forKey:@"startRow"];
    
    weakSelf_declare;
    [JPNetworking postUrl:Url params:params progress:nil callback:^(id resp) {
        JPLog(@"%@", resp);
        if ([resp isKindOfClass:[NSString class]]) {
            [weakSelf.ctntView.mj_header endRefreshing];
            return;
        }
        if ([resp[@"informationList"] isKindOfClass:[NSArray class]]) {
            NSArray *infoList = resp[@"informationList"];
            if (infoList.count > 0) {
                for (NSDictionary *dic in infoList) {
                    JPInfoModel *model = [JPInfoModel yy_modelWithDictionary:dic];
                    [weakSelf.dataSource addObject:model];
                }
                weakSelf.ctntView.mj_footer.hidden = infoList.count != 10;
                if (infoList.count == 10) {
                    [weakSelf.ctntView.mj_footer resetNoMoreData];
                } else {
                    [weakSelf.ctntView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            self.ctntView.mj_header.hidden = infoList.count <= 0;
            [weakSelf.ctntView reloadData];
        }
        [weakSelf.ctntView.mj_header endRefreshing];
        [weakSelf.ctntView.mj_footer endRefreshing];
    }];
}

#pragma mark - lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.rowHeight = JPRealValue(242);
        [_ctntView registerClass:[JPAnnounceCell class] forCellReuseIdentifier:announceCellReuseIdentifier];
    }
    return _ctntView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.ctntView];
    self.ctntView.emptyDataSetSource = self;
    self.ctntView.emptyDataSetDelegate = self;
    
    // 删除单元格分隔线的一个小技巧
    self.ctntView.tableFooterView = [UIView new];
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 0;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf outsideNetworkWithStartRow:weakSelf.pageNo];
    }];
    self.ctntView.mj_header.hidden = YES;
    
    self.ctntView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNo ++;
        [weakSelf outsideNetworkWithStartRow:weakSelf.pageNo * 10];
    }];
    self.ctntView.mj_footer.hidden = YES;
    
    [self.ctntView.mj_header beginRefreshing];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPAnnounceCell *cell = [tableView dequeueReusableCellWithIdentifier:announceCellReuseIdentifier forIndexPath:indexPath];
    cell.infoModel = self.dataSource[indexPath.section];
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JPLastestNewsDetailViewController *detailVC = [[JPLastestNewsDetailViewController alloc] init];
    detailVC.navigationItem.title = @"公告详情";
    //        JPInfoModel *model = self.dataSource[indexPath.row];
    //        detailVC.infoID = model.infoID;
    detailVC.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
#pragma mark 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        // 圆形加载图片
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }else {
        // 默认静态图片
        return [UIImage imageNamed:@"jp_result_noNotice"];
    }
}

#pragma mark 图片旋转动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
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

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -64;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"正在加载，请稍后...";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return self.loading ? [[NSAttributedString alloc] initWithString:text attributes:attributes] : nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
