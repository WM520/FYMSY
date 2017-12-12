//
//  JPSearchIndustryViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPSearchIndustryViewController.h"

@interface JPSearchCell : UITableViewCell
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *textLab;
@property (nonatomic, strong) UIImageView *indicator;
@end
@implementation JPSearchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self handleUserInterface];
    }
    return self;
}
- (void)handleUserInterface {
    [self.contentView addSubview:self.logoView];
    [self.contentView addSubview:self.indicator];
    [self.contentView addSubview:self.textLab];
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
    }
    return _logoView;
}
- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.font = JP_DefaultsFont;
        _textLab.textColor = JP_Content_Color;
        _textLab.numberOfLines = 0;
        _textLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _textLab;
}
- (UIImageView *)indicator {
    if (!_indicator) {
        _indicator = [UIImageView new];
        _indicator.image = [UIImage imageNamed:@"jp_login_search_copy"];
    }
    return _indicator;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(JPRealValue(29), JPRealValue(29)));
    }];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(22), JPRealValue(22)));
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoView.mas_right);
        make.right.equalTo(weakSelf.indicator.mas_left).offset(JPRealValue(-10));
        make.top.and.bottom.equalTo(weakSelf.contentView);
    }];
}
@end
@interface JPSearchIndustryViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIView            *navigationBar;
@property (nonatomic, strong) UIView            *searchBgView;
@property (nonatomic, strong) UIButton          *searchButton;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UITableView       *ctntView;

@property (nonatomic, assign) BOOL              isSearch;

@property (nonatomic, strong) NSArray           *searchArray;
@end

static NSString *const searchCellReuseIdentifier = @"searchCell";

@implementation JPSearchIndustryViewController

#pragma mark - Request
//- (void)requestResponse {
//    weakSelf_declare;
//    [JPNetTools1_0_2 getIndustryTypeWithName:self.name callback:^(NSString *code, NSString *msg, id resp) {
//        
//        JPLog(@"行业子类 - %@", resp);
//        if ([code isEqualToString:@"00"]) {
//            //  成功
//            if ([resp isKindOfClass:[NSArray class]]) {
//                NSArray *arr = (NSArray *)resp;
//                                
//                for (NSDictionary *dic in arr) {
//                    JPIndustryModel *industryModel = [JPIndustryModel yy_modelWithDictionary:dic];
//                    [weakSelf.dataSource addObject:industryModel.name];
//                }
//                [weakSelf.ctntView reloadData];
//            }
//        } else {
//            //  失败
//            [SVProgressHUD showInfoWithStatus:msg];
//        }
//    }];
//}

//  !!!: 自定义导航栏
- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navigationBar.backgroundColor = JPBaseColor;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
        [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:rightButton];
        
        [_navigationBar addSubview:self.searchBgView];
        [_navigationBar addSubview:self.searchButton];
        [_navigationBar addSubview:self.textField];
        self.textField.hidden = YES;
        
        weakSelf_declare;
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_navigationBar.mas_right).offset(JPRealValue(-20));
            make.centerY.equalTo(leftButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 40));
        }];
        [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightButton.mas_left).offset(JPRealValue(-10));
            make.bottom.equalTo(_navigationBar.mas_bottom).offset(JPRealValue(-10));
            make.centerX.equalTo(_navigationBar.mas_centerX);
            make.height.equalTo(@(JPRealValue(68)));
        }];
        [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.searchBgView.mas_left).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.searchBgView.mas_right).offset(JPRealValue(-20));
            make.top.and.bottom.equalTo(weakSelf.searchBgView);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.searchBgView.mas_left).offset(JPRealValue(20));
            make.right.equalTo(weakSelf.searchBgView.mas_right).offset(JPRealValue(-10));
            make.top.and.bottom.equalTo(weakSelf.searchBgView);
        }];
    }
    return _navigationBar;
}

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        [_ctntView registerClass:[JPSearchCell class] forCellReuseIdentifier:searchCellReuseIdentifier];
        _ctntView.tableFooterView = [UIView new];
        _ctntView.backgroundColor = JP_viewBackgroundColor;
//        _ctntView.separatorColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _ctntView;
}

- (UIView *)searchBgView {
    if (!_searchBgView) {
        _searchBgView = [UIView new];
        _searchBgView.backgroundColor = [UIColor colorWithHexString:@"4476f2"];
        _searchBgView.layer.cornerRadius = JPRealValue(10);
        _searchBgView.layer.masksToBounds = YES;
    }
    return _searchBgView;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_searchButton setImage:[UIImage imageNamed:@"jp_login_search_white"] forState:UIControlStateNormal];
        [_searchButton setTitle:@"请输入搜索关键字" forState:UIControlStateNormal];
        _searchButton.titleLabel.font = JP_DefaultsFont;
        _searchButton.backgroundColor = [UIColor colorWithHexString:@"4476f2"];
        [_searchButton addTarget:self action:@selector(handleSearchBarClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:JPRealValue(32)];
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor colorWithHexString:@"4476f2"];
        _textField.tintColor = [UIColor whiteColor];
        [_textField addTarget:self action:@selector(jp_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
- (NSArray *)searchArray {
    if (!_searchArray) {
        _searchArray = @[];
    }
    return _searchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.ctntView];
//    [self requestResponse];
    self.isSearch = NO;
    
    //  监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isSearch && self.textField.text > 0) ? self.searchArray.count : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellReuseIdentifier forIndexPath:indexPath];
    cell.logoView.image = (self.isSearch && self.textField.text > 0) ? [UIImage imageNamed:@"jp_login_search_black"] : nil;
    cell.textLab.text = (self.isSearch && self.textField.text > 0) ? self.searchArray[indexPath.row] : self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.jp_returnSearchValue) {
        self.jp_returnSearchValue((self.isSearch && self.textField.text > 0) ? self.searchArray[indexPath.row] : self.dataSource[indexPath.row]);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return (self.isSearch && self.textField.text > 0) ? 0.01 : JPRealValue(88);
    return _searchArray.count > 0 ? 0.01 : JPRealValue(88);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLab = [UILabel new];
    headerLab.text = @"所有分类";
    headerLab.font = JP_DefaultsFont;
    headerLab.textColor = JP_NoticeText_Color;
    headerLab.textAlignment = NSTextAlignmentCenter;
    headerLab.backgroundColor = [UIColor whiteColor];
    headerLab.layer.borderWidth = 1;
    headerLab.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
//    return (self.isSearch && self.textField.text > 0) ? nil : headerLab;
    return _searchArray.count > 0 ? nil : headerLab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = (self.isSearch && self.textField.text > 0) ? self.searchArray[indexPath.row] : self.dataSource[indexPath.row];
    CGRect rect = [NSString getHeightOfText:text width:(kScreenWidth - JPRealValue(72)) font:JP_DefaultsFont];
    return rect.size.height + JPRealValue(40);
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType == UIReturnKeySearch) {
        //  键盘Search按钮搜索
        [self filterBySubstring:self.textField.text];
        [self.ctntView reloadData];
        //  取消键盘第一响应
        [self.textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - textFieldValueChanged
- (void)jp_textFieldValueChanged:(UITextField *)textField {
    //  边输入边匹配
//    [self filterBySubstring:textField.text];
//    [self.ctntView reloadData];
}

#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification *)noti {
    self.isSearch = YES;
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (self.textField.text.length > 0) {
        self.isSearch = YES;
    } else {
        self.isSearch = NO;
        [self.ctntView reloadData];
    }
}

#pragma mark - Action
// !!!: 返回按钮
- (void)leftButtonClick {
    if (self.jp_returnSearchValue) {
        self.jp_returnSearchValue(@"");
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
// !!!: 搜索框
- (void)handleSearchBarClick:(UIButton *)sender {
    self.isSearch = YES;
}
// !!!: 搜索按钮
- (void)rightItemClick:(UIButton *)rightItem {
    [self filterBySubstring:self.textField.text];
    [self.ctntView reloadData];
    
    [self.textField resignFirstResponder];
}

- (void)filterBySubstring:(NSString *)subStr {
    //设置搜索状态
    _isSearch = YES;
    /**
     * 定义谓词来匹配搜索
     * 搜索规则：包含搜索
     */
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c]%@", subStr];
    //使用谓词过滤NSArray
    _searchArray = [self.dataSource filteredArrayUsingPredicate:pred];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter
- (void)setIsSearch:(BOOL)isSearch {
    if (isSearch) {
        self.searchButton.hidden = YES;
        self.textField.hidden = NO;
        [self.textField becomeFirstResponder];
    } else {
        self.searchButton.hidden = NO;
        self.textField.hidden = YES;
        [self.textField resignFirstResponder];
    }
    _isSearch = isSearch;
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
