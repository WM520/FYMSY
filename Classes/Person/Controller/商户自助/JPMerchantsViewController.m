//
//  JPMerchantsViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/28.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPMerchantsViewController.h"
#import "JPMerchantsSHViewController.h"

@interface JPMerchantsHeaderView : UITableViewHeaderFooterView
/** 审核进度*/
@property (nonatomic, assign) JPApplyProgress progress;
/** 背景图*/
@property (nonatomic, strong) UIImageView *bgView;
/** Logo*/
@property (nonatomic, strong) UIImageView *logoView;
/** 审核状态*/
@property (nonatomic, strong) UILabel *statusLab;
@end
@implementation JPMerchantsHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.logoView];
        [self.bgView addSubview:self.statusLab];
    }
    return self;
}
- (void)setProgress:(JPApplyProgress)progress {
    switch (progress) {
        case JPApplyProgressNotThrough:
        {
            self.bgView.image = [UIImage imageNamed:@"jp_merchants_notThrough_bg"];
            self.logoView.image = [UIImage imageNamed:@"jp_merchants_notThrough"];
        }
            break;
        case JPApplyProgressThrough:
        {
            self.bgView.image = [UIImage imageNamed:@"jp_merchants_through_bg"];
            self.logoView.image = [UIImage imageNamed:@"jp_merchants_through"];
        }
            break;
        case JPApplyProgressApplying:
        {
            self.bgView.image = [UIImage imageNamed:@"jp_merchants_applying_bg"];
            self.logoView.image = [UIImage imageNamed:@"jp_merchants_applying"];
        }
            break;
        default:
            break;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.equalTo(weakSelf.contentView);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.top.equalTo(weakSelf.bgView.mas_top).offset(80);
    }];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.logoView.mas_bottom).offset(JPRealValue(30));
        make.centerX.equalTo(weakSelf.logoView.mas_centerX);
        make.width.equalTo(@(kScreenWidth - JPRealValue(60)));
    }];
}
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
    }
    return _bgView;
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
    }
    return _logoView;
}
- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [UILabel new];
        _statusLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
        _statusLab.textColor = [UIColor whiteColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLab;
}
@end

@interface JPMerchantsFooterView : UITableViewHeaderFooterView
@property (nonatomic, assign) JPApplyProgress progress;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, copy) void (^jp_merchantsClickBlock)();
@end
@implementation JPMerchantsFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nextButton];
    }
    return self;
}
- (void)setProgress:(JPApplyProgress)progress {
    switch (progress) {
        case JPApplyProgressNotThrough:
        {
            [self.nextButton setTitle:@"重新修改" forState:UIControlStateNormal];
            [self.nextButton setTitleColor:JP_NoticeRedColor forState:UIControlStateNormal];
        }
            break;
        case JPApplyProgressThrough:
        {
            [self.nextButton setTitle:@"查看详情" forState:UIControlStateNormal];
            [self.nextButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
        }
            break;
        case JPApplyProgressApplying:
        {
            [self.nextButton setTitle:@"查看详情" forState:UIControlStateNormal];
            [self.nextButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(100));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo((CGSize){JPRealValue(620), JPRealValue(90)});
    }];
}
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.titleLabel.font = JP_DefaultsFont;
        _nextButton.layer.cornerRadius = JPRealValue(10);
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.borderColor = JP_LayerColor.CGColor;
        _nextButton.layer.borderWidth = 1;
        [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
- (void)nextButtonClick:(UIButton *)sender {
    if (self.jp_merchantsClickBlock) {
        self.jp_merchantsClickBlock();
    }
}
@end

@interface JPMerchantsCell : UITableViewCell
/** 浅红色背景视图*/
@property (nonatomic, strong) UIView *bgView;
/** 白色背景*/
@property (nonatomic, strong) UIView *whiteView;
/** 左侧线条*/
@property (nonatomic, strong) UIImageView *leftView;
/** 右侧线条*/
@property (nonatomic, strong) UIImageView *rightView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLab;
/** 具体原因*/
@property (nonatomic, strong) UILabel *reasonLab;
@end
@implementation JPMerchantsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.whiteView];
        [self.whiteView addSubview:self.titleLab];
        [self.whiteView addSubview:self.leftView];
        [self.whiteView addSubview:self.rightView];
        [self.bgView addSubview:self.reasonLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(JPRealValue(-20));
    }];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(weakSelf.bgView);
        make.height.equalTo(@(JPRealValue(106)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.top.and.bottom.equalTo(weakSelf.whiteView);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.right.equalTo(weakSelf.titleLab.mas_left).offset(JPRealValue(-20));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
    }];
    [self.reasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(60));
        make.top.equalTo(weakSelf.whiteView.mas_bottom).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-60));
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(-30));
    }];
}
#pragma mark - Lazy
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"fffafa"];;
//        _bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _bgView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        _bgView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
//        _bgView.layer.shadowRadius = 4;//阴影半径，默认3
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"审核不通过原因";
        _titleLab.textColor = JP_NoticeRedColor;
        _titleLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
    }
    return _titleLab;
}
- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [UIImageView new];
        _leftView.image = [UIImage imageNamed:@"jp_merchants_left"];
    }
    return _leftView;
}
- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [UIImageView new];
        _rightView.image = [UIImage imageNamed:@"jp_merchants_right"];
    }
    return _rightView;
}
- (UILabel *)reasonLab {
    if (!_reasonLab) {
        _reasonLab = [UILabel new];
        _reasonLab.font = JP_DefaultsFont;
        _reasonLab.textColor = JP_NoticeRedColor;
        _reasonLab.numberOfLines = 0;
        _reasonLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _reasonLab;
}
@end

@interface JPMerchantsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) UIView *navImageView;
@end

static NSString *const merchantsHeaderViewReuseIdentifier = @"merchantsHeaderView";
static NSString *const merchantsFooterViewReuseIdentifier = @"merchantsFooterView";
static NSString *const merchantsCellReuseIdentifier = @"merchantsCell";
static NSString *const otherCellReuseIdentifier = @"otherCell";

@implementation JPMerchantsViewController

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight} style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        
        _ctntView.backgroundColor = [UIColor whiteColor];
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.contentInset = (UIEdgeInsets){-20, 0, 0, 0};
        [_ctntView registerClass:[JPMerchantsCell class] forCellReuseIdentifier:merchantsCellReuseIdentifier];
        [_ctntView registerClass:[JPMerchantsHeaderView class] forHeaderFooterViewReuseIdentifier:merchantsHeaderViewReuseIdentifier];
        [_ctntView registerClass:[JPMerchantsFooterView class] forHeaderFooterViewReuseIdentifier:merchantsFooterViewReuseIdentifier];
    }
    return _ctntView;
}
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 64}];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:(CGRect){kScreenWidth / 2.0 - 100, 20, 200, 44}];
    titleLab.text = @"商户自助";
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [_navImageView addSubview:titleLab];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = (CGRect){10, 25, JPRealValue(60), JPRealValue(60)};
    leftButton.imageEdgeInsets = (UIEdgeInsets){JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15)};
    [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:leftButton];
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutHomeView];
    
    [self.view addSubview:self.ctntView];
    [self.view bringSubviewToFront:self.navImageView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applyProgress == JPApplyProgressNotThrough ? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        JPMerchantsCell *cell = [tableView dequeueReusableCellWithIdentifier:merchantsCellReuseIdentifier forIndexPath:indexPath];
        NSString *content = self.merchantsModel.unpassCause;
        if (content.length <= 0) {
            content = @"暂无原因";
        }
        cell.reasonLab.text = content;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellReuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:otherCellReuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = JP_DefaultsFont;
            cell.textLabel.textColor = JP_Content_Color;
            cell.detailTextLabel.font = JP_DefaultsFont;
            cell.detailTextLabel.textColor = JP_Content_Color;
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"商户名称";
            cell.detailTextLabel.text = self.merchantsModel.merchantName;
            cell.imageView.image = [UIImage imageNamed:@"jp_merchants_name"];
        } else {
            cell.textLabel.text = @"法人名称";
            cell.detailTextLabel.text = self.merchantsModel.legalPerson;
            cell.imageView.image = [UIImage imageNamed:@"jp_merchants_legal"];
        }
        return cell;
    }
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content = self.merchantsModel.unpassCause;
    if (content.length <= 0) {
        content = @"暂无原因";
    }
    CGRect rect = [NSString getHeightOfText:content width:(kScreenWidth - JPRealValue(180)) font:JP_DefaultsFont];
    return indexPath.row == 2 ? JPRealValue(212) + rect.size.height : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(555);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPMerchantsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:merchantsHeaderViewReuseIdentifier];
//    JPMerchantsHeaderView *headerView = [[JPMerchantsHeaderView alloc] init];
    headerView.progress = self.applyProgress;
    headerView.statusLab.text = self.merchantsModel.reviewStatus;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JPRealValue(250);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JPMerchantsFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:merchantsFooterViewReuseIdentifier];
    footerView.progress = self.applyProgress;
    
    weakSelf_declare;
    footerView.jp_merchantsClickBlock = ^{
        
        [MobClick event:@"selfHelp_detail"];
        
        JPMerchantsSHViewController *merchantsVC = [[JPMerchantsSHViewController alloc] init];
        merchantsVC.applyProgress = weakSelf.applyProgress;
        merchantsVC.reviewStatus = weakSelf.merchantsModel.reviewStatus;
        [weakSelf.navigationController pushViewController:merchantsVC animated:YES];
    };
    return footerView;
}

#pragma mark - Action
- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
