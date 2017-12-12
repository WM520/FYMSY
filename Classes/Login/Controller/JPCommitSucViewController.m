//
//  JPCommitSucViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCommitSucViewController.h"

@interface JPCommitSucStateCell : UITableViewCell
@property (nonatomic, strong) UIImageView       *logoView;
@property (nonatomic, strong) UILabel           *stateLab;
@end
@implementation JPCommitSucStateCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}
- (void)handleUserInterface {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.logoView) {
        self.logoView = [UIImageView new];
        self.logoView.image = [UIImage imageNamed:@"jp_apply_through"];
        [self.contentView addSubview:self.logoView];
    }
    if (!self.stateLab) {
        self.stateLab = [UILabel new];
        self.stateLab.text = @"您的资料提交申请成功！";
        self.stateLab.font = JP_DefaultsFont;
        self.stateLab.textAlignment = NSTextAlignmentCenter;
        self.stateLab.textColor = JP_NoticeText_Color;
        [self.contentView addSubview:self.stateLab];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(40));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(100), JPRealValue(100)));
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.logoView.mas_bottom).offset(JPRealValue(30));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, JPRealValue(30)));
    }];
}
@end

@interface JPInitialAccountCell : UITableViewCell
@property (nonatomic, strong) UILabel *initialUserName;
@property (nonatomic, strong) UILabel *initialPassword;
@property (nonatomic, strong) UILabel *attentionWords;
@end
@implementation JPInitialAccountCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.initialUserName];
        [self.contentView addSubview:self.initialPassword];
//        [self.contentView addSubview:self.attentionWords];
    }
    return self;
}
- (UILabel *)initialUserName {
    if (!_initialUserName) {
        _initialUserName = [UILabel new];
        _initialUserName.text = @"一码付账号为：zs1234";
        _initialUserName.font = JP_DefaultsFont;
        _initialUserName.textAlignment = NSTextAlignmentCenter;
        _initialUserName.textColor = JP_Content_Color;
    }
    return _initialUserName;
}
- (UILabel *)initialPassword {
    if (!_initialPassword) {
        _initialPassword = [UILabel new];
        _initialPassword.text = @"初始密码为：abc123";
        _initialPassword.font = JP_DefaultsFont;
        _initialPassword.textAlignment = NSTextAlignmentCenter;
        _initialPassword.textColor = JP_Content_Color;
    }
    return _initialPassword;
}
- (UILabel *)attentionWords {
    if (!_attentionWords) {
        _attentionWords = [UILabel new];
        _attentionWords.text = @"请耐心等待审核，审核通过将会以短信的方式通知您！";
        _attentionWords.font = [UIFont systemFontOfSize:JPRealValue(22)];
        _attentionWords.textAlignment = NSTextAlignmentCenter;
        _attentionWords.textColor = JP_NoticeRedColor;
    }
    return _attentionWords;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.initialUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.height.equalTo(@(JPRealValue(30)));
    }];
    [self.initialPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.height.equalTo(weakSelf.initialUserName);
        make.top.equalTo(weakSelf.initialUserName.mas_bottom);
    }];
//    [self.attentionWords mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.and.height.equalTo(weakSelf.initialUserName);
//        make.top.equalTo(weakSelf.initialPassword.mas_bottom).offset(JPRealValue(10));
//    }];
}
@end

@interface JPCommitSucViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@end
static NSString *const commitSucStateCellReuseIdentifier = @"commitSucStateCell";
static NSString *const initialAccountCellReuseIdentifier = @"initialAccountCell";
@implementation JPCommitSucViewController

- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        
        [_ctntView registerClass:[JPCommitSucStateCell class] forCellReuseIdentifier:commitSucStateCellReuseIdentifier];
        [_ctntView registerClass:[JPInitialAccountCell class] forCellReuseIdentifier:initialAccountCellReuseIdentifier];
    }
    return _ctntView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"提交信息成功";
    [self.view addSubview:self.ctntView];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JPCommitSucStateCell *cell = [tableView dequeueReusableCellWithIdentifier:commitSucStateCellReuseIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        JPInitialAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:initialAccountCellReuseIdentifier forIndexPath:indexPath];
        cell.initialUserName.text = [NSString stringWithFormat:@"一码付账号为：%@", self.userName];
        cell.initialPassword.text = [NSString stringWithFormat:@"初始密码为：%@", self.password];
        return cell;
    }
}
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? JPRealValue(240) : JPRealValue(120);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(28) : JPRealValue(300);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(JPRealValue(64), JPRealValue(40), kScreenWidth - JPRealValue(128), JPRealValue(90));
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    nextButton.titleLabel.font = JP_DefaultsFont;
    nextButton.backgroundColor = JPBaseColor;
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(handleNextEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
    
    return section == 1 ? footerView : nil;
}

#pragma mark - action
- (void)handleNextEvent:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onBackItemClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
